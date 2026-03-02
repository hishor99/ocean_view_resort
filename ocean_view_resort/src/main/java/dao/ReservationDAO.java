package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class ReservationDAO {

    // =========================
    // A) Customer: create reservation (PENDING)
    // =========================
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

            ps.setObject(7, foodId, Types.INTEGER);
            ps.setObject(8, vehicleId, Types.INTEGER);

            ps.setDouble(9, roomTotal);
            ps.setDouble(10, foodTotal);
            ps.setDouble(11, vehicleTotal);
            ps.setDouble(12, grandTotal);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // =========================
    // B0) Staff Walk-in (compat): create reservation (CONFIRMED) with NO extras
    //     (kept for old servlet calls)
    // =========================
    public int createWalkInReservation(int staffUserId,
                                       String guestName, String guestAddress,
                                       String guestPhone, String guestEmail,
                                       int roomId, LocalDate checkIn, LocalDate checkOut,
                                       int guestsCount) throws Exception {
        return createWalkInReservation(staffUserId,
                guestName, guestAddress, guestPhone, guestEmail,
                roomId, checkIn, checkOut, guestsCount,
                null, null);
    }

    // =========================
    // B1) Staff Walk-in: create reservation (CONFIRMED) with extras selected BEFORE insert
    //    ✅ store guest in guests table
    //    ✅ store guest_id in reservations (customer_id = NULL)
    //    ✅ calculate food_total based on food_packages.pricing_type + price_per_day
    //    ✅ calculate vehicle_total based on vehicles.price_per_day
    // =========================
    public int createWalkInReservation(int staffUserId,
                                       String guestName, String guestAddress,
                                       String guestPhone, String guestEmail,
                                       int roomId, LocalDate checkIn, LocalDate checkOut,
                                       int guestsCount,
                                       Integer foodId, Integer vehicleId) throws Exception {

        if (guestName == null || guestName.isBlank()) throw new Exception("Guest name is required");
        if (guestPhone == null || guestPhone.isBlank()) throw new Exception("Contact number is required");
        if (checkIn == null || checkOut == null) throw new Exception("Dates are required");
        if (guestsCount <= 0) throw new Exception("Guests must be at least 1.");

        int nights = (int) ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights <= 0) throw new Exception("Check-out must be after check-in");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1) Check overlap (safety check)
            if (!isRoomAvailable(conn, roomId, checkIn, checkOut)) {
                throw new Exception("Selected room is not available for the chosen dates.");
            }

            // 2) Room totals
            double pricePerNight = getRoomPrice(conn, roomId);
            double roomTotal = pricePerNight * nights;

            // 3) Food + Vehicle totals
            double foodTotal = calculateFoodTotal(conn, foodId, guestsCount, nights);
            double vehicleTotal = calculateVehicleTotal(conn, vehicleId, nights);

            double grandTotal = roomTotal + foodTotal + vehicleTotal;

            // 4) Room details for guest table
            Map<String, String> roomDetails = getRoomDetails(conn, roomId);
            String roomType = roomDetails.get("roomType");
            String roomNumber = roomDetails.get("roomNumber");

            // 5) Find or create guest
            Integer guestId = findGuestIdByPhone(conn, guestPhone);
            if (guestId == null) {
                guestId = createGuest(conn, guestName, guestAddress, guestPhone, guestEmail, roomType, roomNumber);
            } else {
                updateGuestRoomInfo(conn, guestId, roomType, roomNumber);
            }

            // 6) Insert reservation
            String insertSql = "INSERT INTO reservations " +
                    "(reservation_no, guest_id, customer_id, room_id, check_in, check_out, nights, guests, " +
                    " food_id, vehicle_id, room_total, food_total, vehicle_total, grand_total, status, " +
                    " confirmed_by, confirmed_at) " +
                    "VALUES ('TEMP', ?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', ?, NOW())";

            int reservationId;
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, guestId);
                ps.setInt(2, roomId);
                ps.setDate(3, Date.valueOf(checkIn));
                ps.setDate(4, Date.valueOf(checkOut));
                ps.setInt(5, nights);
                ps.setInt(6, guestsCount);

                ps.setObject(7, foodId, Types.INTEGER);
                ps.setObject(8, vehicleId, Types.INTEGER);

                ps.setDouble(9, roomTotal);
                ps.setDouble(10, foodTotal);
                ps.setDouble(11, vehicleTotal);
                ps.setDouble(12, grandTotal);

                ps.setInt(13, staffUserId);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) throw new Exception("Failed to create reservation.");
                    reservationId = rs.getInt(1);
                }
            }

            // 7) Update reservation_no
            String reservationNo = formatReservationNo(reservationId);
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE reservations SET reservation_no=? WHERE reservation_id=?")) {
                ps.setString(1, reservationNo);
                ps.setInt(2, reservationId);
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

    // =========================
    // Room Availability
    // =========================
    private boolean isRoomAvailable(Connection conn, int roomId,
                                    LocalDate checkIn, LocalDate checkOut) throws Exception {

        String sql =
                "SELECT 1 FROM reservations " +
                "WHERE room_id=? " +
                "AND status IN ('PENDING','CONFIRMED','CHECKED_IN') " +
                "AND check_in < ? AND check_out > ? " +
                "LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));
            try (ResultSet rs = ps.executeQuery()) {
                return !rs.next();
            }
        }
    }

    // =========================
    // Helpers: Reservation No
    // =========================
    private String formatReservationNo(int reservationId) {
        int year = LocalDate.now().getYear();
        return String.format("RES-%d-%06d", year, reservationId);
    }

    // =========================
    // Helpers: Room
    // =========================
    private double getRoomPrice(Connection conn, int roomId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT price_per_night FROM rooms WHERE room_id=? LIMIT 1")) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Room not found.");
                return rs.getDouble("price_per_night");
            }
        }
    }

    private Map<String, String> getRoomDetails(Connection conn, int roomId) throws Exception {
        String sql = "SELECT room_type, room_number FROM rooms WHERE room_id=? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Room not found.");
                Map<String, String> m = new HashMap<>();
                m.put("roomType", rs.getString("room_type"));
                m.put("roomNumber", rs.getString("room_number"));
                return m;
            }
        }
    }

    // =========================
    // Helpers: Food + Vehicle totals
    // =========================
    private double calculateFoodTotal(Connection conn, Integer foodId, int guests, int nights) throws Exception {
        if (foodId == null) return 0;

        String sql = "SELECT price_per_day, pricing_type " +
                     "FROM food_packages WHERE food_id=? AND is_active=1 LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, foodId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Food package not found or inactive.");

                double pricePerDay = rs.getDouble("price_per_day");
                String pricingType = rs.getString("pricing_type");

                if ("PER_PERSON_PER_DAY".equalsIgnoreCase(pricingType)) {
                    return pricePerDay * guests * nights;
                }
                return pricePerDay * nights; // PER_ROOM_PER_DAY
            }
        }
    }

    private double calculateVehicleTotal(Connection conn, Integer vehicleId, int nights) throws Exception {
        if (vehicleId == null) return 0;

        String sql = "SELECT price_per_day FROM vehicles WHERE vehicle_id=? AND is_active=1 LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Vehicle service not found or inactive.");
                double pricePerDay = rs.getDouble("price_per_day");
                return pricePerDay * nights;
            }
        }
    }

    // =========================
    // Helpers: Guests table
    // =========================
    private Integer findGuestIdByPhone(Connection conn, String phone) throws Exception {
        String sql = "SELECT guest_id FROM guests WHERE phone=? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("guest_id") : null;
            }
        }
    }

    private int createGuest(Connection conn,
                            String name, String address,
                            String phone, String email,
                            String roomType, String roomNumber) throws Exception {

        String sql = "INSERT INTO guests(guest_name, address, phone, email, room_type, room_number) " +
                     "VALUES(?,?,?,?,?,?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, name.trim());
            ps.setString(2, (address == null || address.isBlank()) ? null : address.trim());
            ps.setString(3, phone.trim());
            ps.setString(4, (email == null || email.isBlank()) ? null : email.trim());
            ps.setString(5, roomType);
            ps.setString(6, roomNumber);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }

        throw new Exception("Failed to create guest.");
    }

    private void updateGuestRoomInfo(Connection conn, int guestId, String roomType, String roomNumber) throws Exception {
        String sql = "UPDATE guests SET room_type=?, room_number=? WHERE guest_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomType);
            ps.setString(2, roomNumber);
            ps.setInt(3, guestId);
            ps.executeUpdate();
        }
    }

    // =========================
    // C) Staff View: Pending reservations list
    // =========================
    public List<Map<String, Object>> getPendingReservations() throws Exception {
        String sql =
                "SELECT r.reservation_id, r.reservation_no, r.customer_id, r.guest_id, r.room_id, " +
                "       r.check_in, r.check_out, r.nights, r.guests, " +
                "       r.grand_total, r.status, r.created_at, " +
                "       rm.room_number, rm.room_type " +
                "FROM reservations r " +
                "JOIN rooms rm ON rm.room_id = r.room_id " +
                "WHERE r.status = 'PENDING' " +
                "ORDER BY r.created_at ASC";

        return fetchReservationList(sql, null);
    }

    // =========================
    // Invoice / Details
    // =========================
    public Map<String, Object> getReservationInvoice(int reservationId) throws Exception {

        String sql =
                "SELECT r.reservation_id, r.reservation_no, r.check_in, r.check_out, r.nights, r.guests, " +
                "       r.room_total, r.food_total, r.vehicle_total, r.grand_total, r.status, r.created_at, " +
                "       r.customer_id, r.guest_id, " +
                "       g.guest_name, g.address AS guest_address, g.phone AS guest_phone, g.email AS guest_email, " +
                "       rm.room_number, rm.room_type, rm.capacity, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN rooms rm ON rm.room_id = r.room_id " +
                "LEFT JOIN guests g ON g.guest_id = r.guest_id " +
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

                m.put("guestName", safeGet(rs, "guest_name"));
                m.put("guestAddress", safeGet(rs, "guest_address"));
                m.put("guestPhone", safeGet(rs, "guest_phone"));
                m.put("guestEmail", safeGet(rs, "guest_email"));

                m.put("roomNumber", rs.getString("room_number"));
                m.put("roomType", rs.getString("room_type"));
                m.put("capacity", rs.getInt("capacity"));
                m.put("pricePerNight", rs.getDouble("price_per_night"));

                return m;
            }
        }
    }

    private String safeGet(ResultSet rs, String col) {
        try { return rs.getString(col); } catch (Exception e) { return null; }
    }

    // =========================
    // D) Reservation Details (Search by reservation_no)
    // =========================
    public Map<String, Object> findByReservationNo(String reservationNo) throws Exception {

        String sql =
            "SELECT r.reservation_id, r.reservation_no, r.status, r.created_at, r.confirmed_at, " +
            "       r.check_in, r.check_out, r.nights, r.guests, r.room_id, r.room_type, " +
            "       r.food_id, r.vehicle_id, " +
            "       r.room_total, r.food_total, r.vehicle_total, r.grand_total, " +
            "       rm.room_number, rm.price_per_night, rm.capacity AS room_capacity, " +
            "       g.guest_name, g.address AS guest_address, g.phone AS guest_phone, g.email AS guest_email, " +
            "       fp.name AS food_name, fp.price_per_day AS food_price_per_day, fp.pricing_type AS food_pricing_type, " +
            "       v.type AS vehicle_type, v.model AS vehicle_model, v.plate_no, v.price_per_day AS vehicle_price_per_day " +
            "FROM reservations r " +
            "LEFT JOIN rooms rm ON rm.room_id = r.room_id " +
            "LEFT JOIN guests g ON g.guest_id = r.guest_id " +
            "LEFT JOIN food_packages fp ON fp.food_id = r.food_id " +
            "LEFT JOIN vehicles v ON v.vehicle_id = r.vehicle_id " +
            "WHERE r.reservation_no = ? " +
            "LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Map<String, Object> m = new HashMap<>();

                m.put("reservationId", rs.getInt("reservation_id"));
                m.put("reservationNo", rs.getString("reservation_no"));
                m.put("status", rs.getString("status"));
                m.put("createdAt", rs.getTimestamp("created_at"));
                m.put("confirmedAt", rs.getTimestamp("confirmed_at"));

                m.put("checkIn", rs.getDate("check_in"));
                m.put("checkOut", rs.getDate("check_out"));
                m.put("nights", rs.getInt("nights"));
                m.put("guests", rs.getInt("guests"));

                m.put("roomId", rs.getInt("room_id"));
                m.put("roomType", rs.getString("room_type"));
                m.put("roomNumber", rs.getString("room_number"));
                m.put("pricePerNight", rs.getDouble("price_per_night"));
                m.put("capacity", rs.getInt("room_capacity"));

                m.put("guestName", safeGet(rs, "guest_name"));
                m.put("guestAddress", safeGet(rs, "guest_address"));
                m.put("guestPhone", safeGet(rs, "guest_phone"));
                m.put("guestEmail", safeGet(rs, "guest_email"));

                m.put("foodId", (Integer) rs.getObject("food_id"));
                m.put("foodName", rs.getString("food_name"));
                m.put("foodPricePerDay", rs.getDouble("food_price_per_day"));
                m.put("foodPricingType", rs.getString("food_pricing_type"));

                m.put("vehicleId", (Integer) rs.getObject("vehicle_id"));
                m.put("vehicleType", rs.getString("vehicle_type"));
                m.put("vehicleModel", rs.getString("vehicle_model"));
                m.put("plateNo", rs.getString("plate_no"));
                m.put("vehiclePricePerDay", rs.getDouble("vehicle_price_per_day"));

                m.put("roomTotal", rs.getDouble("room_total"));
                m.put("foodTotal", rs.getDouble("food_total"));
                m.put("vehicleTotal", rs.getDouble("vehicle_total"));
                m.put("grandTotal", rs.getDouble("grand_total"));

                return m;
            }
        }
    }

    // =========================
    // List helper
    // =========================
    private interface Binder { void bind(PreparedStatement ps) throws Exception; }

    private List<Map<String, Object>> fetchReservationList(String sql, Binder binder) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (binder != null) binder.bind(ps);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("reservationId", rs.getInt("reservation_id"));
                    m.put("reservationNo", rs.getString("reservation_no"));
                    m.put("customerId", (Integer) rs.getObject("customer_id"));
                    m.put("guestId", (Integer) rs.getObject("guest_id"));
                    m.put("roomId", rs.getInt("room_id"));
                    m.put("roomNumber", rs.getString("room_number"));
                    m.put("roomType", rs.getString("room_type"));
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

    // =========================
    // REPORTS (Manager Graphs)
    // =========================

    // 1) Reservations count per month (for a given year)
    public Map<String, Integer> getReservationCountByMonth(int year) throws Exception {

        String sql =
            "SELECT DATE_FORMAT(check_in, '%Y-%m') AS ym, COUNT(*) AS cnt " +
            "FROM reservations " +
            "WHERE YEAR(check_in)=? " +
            "GROUP BY DATE_FORMAT(check_in, '%Y-%m') " +
            "ORDER BY ym";

        Map<String, Integer> map = new LinkedHashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("ym"), rs.getInt("cnt"));
                }
            }
        }

        return map;
    }

    // 2) Reservations count by status
    public Map<String, Integer> getReservationCountByStatus() throws Exception {

        String sql =
            "SELECT status, COUNT(*) AS cnt " +
            "FROM reservations " +
            "GROUP BY status " +
            "ORDER BY status";

        Map<String, Integer> map = new LinkedHashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("cnt"));
            }
        }

        return map;
    }

    // 3) Revenue per month (sum of grand_total) - using CONFIRMED/COMPLETED only
    public Map<String, Double> getRevenueByMonth(int year) throws Exception {

        String sql =
            "SELECT DATE_FORMAT(check_in, '%Y-%m') AS ym, COALESCE(SUM(grand_total),0) AS total " +
            "FROM reservations " +
            "WHERE YEAR(check_in)=? AND status IN ('CONFIRMED','COMPLETED') " +
            "GROUP BY DATE_FORMAT(check_in, '%Y-%m') " +
            "ORDER BY ym";

        Map<String, Double> map = new LinkedHashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, year);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("ym"), rs.getDouble("total"));
                }
            }
        }

        return map;
    }
}