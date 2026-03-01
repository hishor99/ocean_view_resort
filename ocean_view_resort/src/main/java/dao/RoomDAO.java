package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Room;

public class RoomDAO {

    // ---------------------------
    // Helpers
    // ---------------------------
    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) return "AVAILABLE";
        return status.trim().toUpperCase();
    }

    private Room mapRoom(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("room_id"),
                rs.getString("room_number"),
                rs.getString("room_type"),
                rs.getDouble("price_per_night"),
                rs.getInt("capacity"),
                rs.getString("status")
        );
    }

    // ---------------------------
    // Create
    // ---------------------------
    // ✅ Add Room (Manager)
    public void addRoom(String roomNumber, String roomType,
                        double pricePerNight, int capacity, String status) throws Exception {

        if (roomNumber == null || roomNumber.isBlank()) {
            throw new IllegalArgumentException("Room number is required");
        }
        if (roomType == null || roomType.isBlank()) {
            throw new IllegalArgumentException("Room type is required");
        }

        String sql = "INSERT INTO rooms (room_number, room_type, price_per_night, capacity, status) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber.trim());
            ps.setString(2, roomType.trim());
            ps.setDouble(3, pricePerNight);
            ps.setInt(4, capacity);
            ps.setString(5, normalizeStatus(status));
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // Read
    // ---------------------------
    // ✅ Get All Rooms (Manager & Staff)
    public List<Room> getAllRooms() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, status " +
                     "FROM rooms ORDER BY room_id DESC";

        List<Room> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRoom(rs));
            }
        }
        return list;
    }

    // ✅ Get Only Available Rooms (Customer)
    public List<Room> getAvailableRooms() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, status " +
                     "FROM rooms WHERE status='AVAILABLE' ORDER BY room_id DESC";

        List<Room> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRoom(rs));
            }
        }
        return list;
    }

    // ✅ Optional: find by ID
    public Room findById(int roomId) throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, status " +
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

    // ✅ Update only status (Merged)
    public void updateStatus(int roomId, String status) throws Exception {
        String sql = "UPDATE rooms SET status=? WHERE room_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, normalizeStatus(status));
            ps.setInt(2, roomId);
            ps.executeUpdate();
        }
    }

    // ✅ Used by UpdateRoomServlet (price + status + capacity)
    public void updatePriceAndStatus(int roomId, double pricePerNight, String status, int capacity) throws Exception {
        String sql = "UPDATE rooms SET price_per_night = ?, status = ?, capacity = ? WHERE room_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, pricePerNight);
            ps.setString(2, normalizeStatus(status));
            ps.setInt(3, capacity);
            ps.setInt(4, roomId);
            ps.executeUpdate();
        }
    }

    // ✅ Optional full update
    public void updateRoom(int roomId, String roomNumber, String roomType,
                           double pricePerNight, int capacity, String status) throws Exception {

        if (roomNumber == null || roomNumber.isBlank()) {
            throw new IllegalArgumentException("Room number is required");
        }
        if (roomType == null || roomType.isBlank()) {
            throw new IllegalArgumentException("Room type is required");
        }

        String sql = "UPDATE rooms SET room_number=?, room_type=?, price_per_night=?, capacity=?, status=? " +
                     "WHERE room_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber.trim());
            ps.setString(2, roomType.trim());
            ps.setDouble(3, pricePerNight);
            ps.setInt(4, capacity);
            ps.setString(5, normalizeStatus(status));
            ps.setInt(6, roomId);

            ps.executeUpdate();
        }
    }

    // ---------------------------
    // Delete
    // ---------------------------
    // ✅ Delete room (Manager)
    public void deleteRoom(int roomId) throws Exception {
        String sql = "DELETE FROM rooms WHERE room_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ps.executeUpdate();
        }
    }
}