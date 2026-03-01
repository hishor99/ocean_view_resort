package dao;

import java.sql.Connection;
import java.sql.Date; // ✅ needed
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import java.time.LocalDate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO {

    // ✅ Customer: create reservation (PENDING)
    public int createReservation(int customerId, int roomId,
                                 LocalDate checkIn, LocalDate checkOut,
                                 int nights, int guests,
                                 Integer foodId, Integer vehicleId,
                                 double roomTotal, double foodTotal,
                                 double vehicleTotal, double grandTotal) throws Exception {

        String sql = "INSERT INTO reservations " +
                "(customer_id, room_id, check_in, check_out, nights, guests, food_id, vehicle_id, " +
                " room_total, food_total, vehicle_total, grand_total, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerId);
            ps.setInt(2, roomId);

            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));

            ps.setInt(5, nights);
            ps.setInt(6, guests);

            if (foodId == null) ps.setNull(7, Types.INTEGER); else ps.setInt(7, foodId);
            if (vehicleId == null) ps.setNull(8, Types.INTEGER); else ps.setInt(8, vehicleId);

            ps.setDouble(9, roomTotal);
            ps.setDouble(10, foodTotal);
            ps.setDouble(11, vehicleTotal);
            ps.setDouble(12, grandTotal);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ✅ Staff Walk-in: create reservation (PENDING) with guest fields + lock room
    public int createWalkInReservation(String guestName, String guestAddress,
                                       String guestPhone, String guestEmail,
                                       int roomId, LocalDate checkIn, LocalDate checkOut,
                                       int guests) throws Exception {

        if (guestName == null || guestName.isBlank()) throw new Exception("Guest name is required");
        if (guestPhone == null || guestPhone.isBlank()) throw new Exception("Contact number is required");
        if (guestAddress == null || guestAddress.isBlank()) throw new Exception("Address is required");

        int nights = (int) java.time.temporal.ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights <= 0) throw new Exception("Check-out must be after check-in");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // ✅ Ensure room is AVAILABLE (lock)
            double pricePerNight;
            String roomStatus;

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT price_per_night, status FROM rooms WHERE room_id=? FOR UPDATE")) {
                ps.setInt(1, roomId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new Exception("Room not found");
                    pricePerNight = rs.getDouble("price_per_night");
                    roomStatus = rs.getString("status");
                }
            }

            if (!"AVAILABLE".equalsIgnoreCase(roomStatus)) {
                conn.rollback();
                throw new Exception("Selected room is not available now.");
            }

            double roomTotal = pricePerNight * nights;
            double grandTotal = roomTotal;

            // ✅ Insert reservation (PENDING) with guest fields
            String sql = "INSERT INTO reservations " +
                    "(customer_id, guest_name, guest_address, guest_phone, guest_email, " +
                    " room_id, check_in, check_out, nights, guests, food_id, vehicle_id, " +
                    " room_total, food_total, vehicle_total, grand_total, status) " +
                    "VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, NULL, ?, 0, 0, ?, 'PENDING')";

            int reservationId = 0;

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, guestName.trim());
                ps.setString(2, guestAddress.trim());
                ps.setString(3, guestPhone.trim());
                ps.setString(4, (guestEmail == null || guestEmail.isBlank()) ? null : guestEmail.trim());
                ps.setInt(5, roomId);
                ps.setDate(6, Date.valueOf(checkIn));
                ps.setDate(7, Date.valueOf(checkOut));
                ps.setInt(8, nights);
                ps.setInt(9, guests);
                ps.setDouble(10, roomTotal);
                ps.setDouble(11, grandTotal);

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) reservationId = rs.getInt(1);
                }
            }

            // ✅ Lock room immediately to avoid double booking
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE rooms SET status='BOOKED' WHERE room_id=?")) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            conn.commit();
            return reservationId;

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignore) {}
                try { conn.close(); } catch (Exception ignore) {}
            }
        }
    }

    // ✅ Staff: list PENDING reservations
    public List<Map<String, Object>> getPendingReservations() throws Exception {
        String sql =
            "SELECT r.reservation_id, r.customer_id, r.room_id, r.check_in, r.check_out, r.nights, r.guests, " +
            "       r.grand_total, r.status, r.created_at, r.reservation_no, " +
            "       rm.room_number, rm.room_type " +
            "FROM reservations r " +
            "JOIN rooms rm ON rm.room_id = r.room_id " +
            "WHERE r.status = 'PENDING' " +
            "ORDER BY r.created_at ASC";

        return fetchList(sql, null);
    }

    // ✅ Customer: reservation history
    public List<Map<String, Object>> getReservationsByCustomer(int customerId) throws Exception {
        String sql =
            "SELECT r.reservation_id, r.reservation_no, r.customer_id, r.room_id, r.check_in, r.check_out, r.nights, r.guests, " +
            "       r.grand_total, r.status, r.created_at, " +
            "       rm.room_number, rm.room_type " +
            "FROM reservations r " +
            "JOIN rooms rm ON rm.room_id = r.room_id " +
            "WHERE r.customer_id = ? " +
            "ORDER BY r.created_at DESC";

        return fetchList(sql, ps -> ps.setInt(1, customerId));
    }

    // ✅ Manager: list reservations (optional status filter)
    public List<Map<String, Object>> getAllReservations(String status) throws Exception {
        boolean hasStatus = status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status);

        String sql =
            "SELECT r.reservation_id, r.reservation_no, r.customer_id, r.room_id, r.check_in, r.check_out, r.nights, r.guests, " +
            "       r.grand_total, r.status, r.created_at, " +
            "       rm.room_number, rm.room_type " +
            "FROM reservations r " +
            "JOIN rooms rm ON rm.room_id = r.room_id " +
            (hasStatus ? "WHERE r.status = ? " : "") +
            "ORDER BY r.created_at DESC";

        if (!hasStatus) return fetchList(sql, null);
        return fetchList(sql, ps -> ps.setString(1, status.trim().toUpperCase()));
    }

    // ✅ CONFIRM reservation + reservation number + set room BOOKED (transaction)
    public void confirmReservation(int reservationId, int staffUserId) throws Exception {

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int roomId;
            String status;

            // lock reservation row
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT room_id, status FROM reservations WHERE reservation_id=? FOR UPDATE")) {
                ps.setInt(1, reservationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new Exception("Reservation not found");
                    roomId = rs.getInt("room_id");
                    status = rs.getString("status");
                }
            }

            if (!"PENDING".equalsIgnoreCase(status)) {
                conn.rollback();
                return;
            }

            String reservationNo = generateReservationNo(conn);

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE reservations SET reservation_no=?, status='CONFIRMED', confirmed_by=?, confirmed_at=NOW() " +
                    "WHERE reservation_id=?")) {
                ps.setString(1, reservationNo);
                ps.setInt(2, staffUserId);
                ps.setInt(3, reservationId);
                ps.executeUpdate();
            }

            // ✅ keep status consistent with walk-in locking
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE rooms SET status='BOOKED' WHERE room_id=?")) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            conn.commit();
        } catch (Exception ex) {
            if (conn != null) conn.rollback();
            throw ex;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignore) {}
                try { conn.close(); } catch (Exception ignore) {}
            }
        }
    }

    // ✅ CANCEL reservation (PENDING only) + room back to AVAILABLE
    public void cancelReservation(int reservationId, int staffUserId, String reason) throws Exception {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int roomId;
            String status;

            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT room_id, status FROM reservations WHERE reservation_id=? FOR UPDATE")) {
                ps.setInt(1, reservationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new Exception("Reservation not found");
                    roomId = rs.getInt("room_id");
                    status = rs.getString("status");
                }
            }

            if (!"PENDING".equalsIgnoreCase(status)) {
                conn.rollback();
                return;
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE reservations SET status='CANCELLED', cancelled_by=?, cancelled_at=NOW(), cancel_reason=? " +
                    "WHERE reservation_id=?")) {
                ps.setInt(1, staffUserId);
                ps.setString(2, (reason == null || reason.isBlank()) ? null : reason.trim());
                ps.setInt(3, reservationId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE rooms SET status='AVAILABLE' WHERE room_id=?")) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }

            conn.commit();
        } catch (Exception ex) {
            if (conn != null) conn.rollback();
            throw ex;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignore) {}
                try { conn.close(); } catch (Exception ignore) {}
            }
        }
    }

    // ✅ Invoice / Details
    public Map<String, Object> getReservationInvoice(int reservationId) throws Exception {
        String sql =
            "SELECT r.reservation_id, r.reservation_no, r.check_in, r.check_out, r.nights, r.guests, " +
            "       r.room_total, r.food_total, r.vehicle_total, r.grand_total, r.status, r.created_at, " +
            "       rm.room_number, rm.room_type, rm.capacity, rm.price_per_night " +
            "FROM reservations r " +
            "JOIN rooms rm ON rm.room_id = r.room_id " +
            "WHERE r.reservation_id=? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Map<String, Object> m = new HashMap<>();
                m.put("reservationId", rs.getInt("reservation_id"));
                m.put("reservationNo", rs.getString("reservation_no"));
                m.put("checkIn", rs.getDate("check_in"));
                m.put("checkOut", rs.getDate("check_out"));
                m.put("nights", rs.getInt("nights"));
                m.put("guests", rs.getInt("guests"));
                m.put("roomTotal", rs.getDouble("room_total"));
                m.put("foodTotal", rs.getDouble("food_total"));
                m.put("vehicleTotal", rs.getDouble("vehicle_total"));
                m.put("grandTotal", rs.getDouble("grand_total"));
                m.put("status", rs.getString("status"));
                m.put("createdAt", rs.getTimestamp("created_at"));
                m.put("roomNumber", rs.getString("room_number"));
                m.put("roomType", rs.getString("room_type"));
                m.put("capacity", rs.getInt("capacity"));
                m.put("pricePerNight", rs.getDouble("price_per_night"));
                return m;
            }
        }
    }

    // ---------------- Helpers ----------------

    private interface Binder { void bind(PreparedStatement ps) throws Exception; }

    private List<Map<String, Object>> fetchList(String sql, Binder binder) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (binder != null) binder.bind(ps);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("reservationId", safeGetInt(rs, "reservation_id"));
                    m.put("reservationNo", safeGet(rs, "reservation_no"));
                    m.put("customerId", safeGetInt(rs, "customer_id"));
                    m.put("roomId", safeGetInt(rs, "room_id"));
                    m.put("roomNumber", safeGet(rs, "room_number"));
                    m.put("roomType", safeGet(rs, "room_type"));
                    m.put("checkIn", rs.getDate("check_in"));
                    m.put("checkOut", rs.getDate("check_out"));
                    m.put("nights", rs.getInt("nights"));
                    m.put("guests", rs.getInt("guests"));
                    m.put("grandTotal", rs.getDouble("grand_total"));
                    m.put("status", rs.getString("status"));
                    m.put("createdAt", rs.getTimestamp("created_at"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    private String safeGet(ResultSet rs, String col) {
        try { return rs.getString(col); } catch (Exception e) { return null; }
    }

    private int safeGetInt(ResultSet rs, String col) {
        try { return rs.getInt(col); } catch (Exception e) { return 0; }
    }

    private String generateReservationNo(Connection conn) throws Exception {
        int next = 1;

        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT MAX(reservation_id) AS max_id FROM reservations")) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) next = rs.getInt("max_id") + 1;
            }
        }

        int year = java.time.LocalDate.now().getYear();
        return String.format("RES-%d-%04d", year, next);
    }
}