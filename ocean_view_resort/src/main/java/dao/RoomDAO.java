package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Room;

public class RoomDAO {

    // Allowed DB statuses for rooms table
    private static final String STATUS_AVAILABLE = "AVAILABLE";
    private static final String STATUS_BOOKED = "BOOKED";
    private static final String STATUS_MAINTENANCE = "MAINTENANCE";

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) return STATUS_AVAILABLE;
        String s = status.trim().toUpperCase();
        if (!s.equals(STATUS_AVAILABLE) && !s.equals(STATUS_BOOKED) && !s.equals(STATUS_MAINTENANCE)) {
            return STATUS_AVAILABLE;
        }
        return s;
    }

    private String cleanDescription(String desc) {
        if (desc == null) return null;
        String d = desc.trim();
        return d.isBlank() ? null : d;
    }

    private Room mapRoom(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("room_id"),
                rs.getString("room_number"),
                rs.getString("room_type"),
                rs.getDouble("price_per_night"),
                rs.getInt("capacity"),
                rs.getString("description"),  // ✅ NEW
                rs.getString("status")
        );
    }

    // ---------------------------
    // Create
    // ---------------------------
    public void addRoom(String roomNumber, String roomType,
                        double pricePerNight, int capacity,
                        String description, String status) throws Exception {

        if (roomNumber == null || roomNumber.isBlank())
            throw new IllegalArgumentException("Room number is required");
        if (roomType == null || roomType.isBlank())
            throw new IllegalArgumentException("Room type is required");
        if (pricePerNight < 0)
            throw new IllegalArgumentException("Price per night must be >= 0");
        if (capacity <= 0)
            throw new IllegalArgumentException("Capacity must be >= 1");

        String sql = "INSERT INTO rooms (room_number, room_type, price_per_night, capacity, description, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber.trim());
            ps.setString(2, roomType.trim());
            ps.setDouble(3, pricePerNight);
            ps.setInt(4, capacity);
            ps.setString(5, cleanDescription(description)); // ✅ NEW
            ps.setString(6, normalizeStatus(status));
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // Read
    // ---------------------------
    public List<Room> getAllRooms() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, description, status " +
                     "FROM rooms ORDER BY room_id DESC";

        List<Room> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRoom(rs));
        }
        return list;
    }

    // NOT date-aware (simple)
    public List<Room> getAvailableRooms() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, description, status " +
                     "FROM rooms WHERE status='AVAILABLE' ORDER BY room_id DESC";

        List<Room> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRoom(rs));
        }
        return list;
    }

    // ✅ Date-aware availability (Overlap rule)
    // overlap if (existing.check_in < new.check_out) AND (existing.check_out > new.check_in)
    public List<Room> findAvailableRooms(LocalDate checkIn, LocalDate checkOut, int guests) throws Exception {

        if (checkIn == null || checkOut == null)
            throw new IllegalArgumentException("Check-in and check-out dates are required");
        if (!checkOut.isAfter(checkIn))
            throw new IllegalArgumentException("Check-out must be after check-in");
        if (guests <= 0)
            throw new IllegalArgumentException("Guests must be >= 1");

        String sql =
                "SELECT r.room_id, r.room_number, r.room_type, r.price_per_night, r.capacity, r.description, r.status " +
                "FROM rooms r " +
                "WHERE r.status = 'AVAILABLE' " +
                "  AND r.capacity >= ? " +
                "  AND r.room_id NOT IN ( " +
                "       SELECT res.room_id FROM reservations res " +
                "       WHERE res.status IN ('PENDING','CONFIRMED','CHECKED_IN') " +
                "         AND res.check_in < ? " +
                "         AND res.check_out > ? " +
                "  ) " +
                "ORDER BY r.price_per_night ASC";

        List<Room> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, guests);
            ps.setDate(2, Date.valueOf(checkOut));
            ps.setDate(3, Date.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRoom(rs));
            }
        }
        return list;
    }

    public Room findById(int roomId) throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, description, status " +
                     "FROM rooms WHERE room_id=? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRoom(rs);
            }
        }
        return null;
    }

    // ---------------------------
    // Update
    // ---------------------------
    public void updateStatus(int roomId, String status) throws Exception {
        String sql = "UPDATE rooms SET status=? WHERE room_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, normalizeStatus(status));
            ps.setInt(2, roomId);
            ps.executeUpdate();
        }
    }

    // Full update
    public void updateRoom(int roomId, String roomNumber, String roomType,
                           double pricePerNight, int capacity,
                           String description, String status) throws Exception {

        if (roomNumber == null || roomNumber.isBlank())
            throw new IllegalArgumentException("Room number is required");
        if (roomType == null || roomType.isBlank())
            throw new IllegalArgumentException("Room type is required");
        if (pricePerNight < 0)
            throw new IllegalArgumentException("Price per night must be >= 0");
        if (capacity <= 0)
            throw new IllegalArgumentException("Capacity must be >= 1");

        String sql = "UPDATE rooms SET room_number=?, room_type=?, price_per_night=?, capacity=?, description=?, status=? " +
                     "WHERE room_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber.trim());
            ps.setString(2, roomType.trim());
            ps.setDouble(3, pricePerNight);
            ps.setInt(4, capacity);
            ps.setString(5, cleanDescription(description)); // ✅ NEW
            ps.setString(6, normalizeStatus(status));
            ps.setInt(7, roomId);
            ps.executeUpdate();
        }
    }

    // ✅ Small update method for your table "Save" button (capacity + description + price + status)
    public void updateRoomPricing(int roomId, int capacity, String description,
                                  double pricePerNight, String status) throws Exception {

        if (pricePerNight < 0)
            throw new IllegalArgumentException("Price per night must be >= 0");
        if (capacity <= 0)
            throw new IllegalArgumentException("Capacity must be >= 1");

        String sql = "UPDATE rooms SET capacity=?, description=?, price_per_night=?, status=? WHERE room_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, capacity);
            ps.setString(2, cleanDescription(description));
            ps.setDouble(3, pricePerNight);
            ps.setString(4, normalizeStatus(status));
            ps.setInt(5, roomId);
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // Delete
    // ---------------------------
    public void deleteRoom(int roomId) throws Exception {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ps.executeUpdate();
        }
    }
}