package dao;

import model.Room;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> findAll() throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, status FROM rooms ORDER BY room_type, room_number";
        List<Room> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Room(
                        rs.getInt("room_id"),
                        rs.getString("room_number"),
                        rs.getString("room_type"),
                        rs.getDouble("price_per_night"),
                        rs.getInt("capacity"),
                        rs.getString("status")
                ));
            }
        }
        return list;
    }

    public Room findById(int id) throws Exception {
        String sql = "SELECT room_id, room_number, room_type, price_per_night, capacity, status FROM rooms WHERE room_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Room(
                            rs.getInt("room_id"),
                            rs.getString("room_number"),
                            rs.getString("room_type"),
                            rs.getDouble("price_per_night"),
                            rs.getInt("capacity"),
                            rs.getString("status")
                    );
                }
            }
        }
        return null;
    }

    public void updatePriceAndStatus(int roomId, double pricePerNight, String status, int capacity) throws Exception {
        String sql = "UPDATE rooms SET price_per_night=?, status=?, capacity=? WHERE room_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, pricePerNight);
            ps.setString(2, status);
            ps.setInt(3, capacity);
            ps.setInt(4, roomId);
            ps.executeUpdate();
        }
    }
}