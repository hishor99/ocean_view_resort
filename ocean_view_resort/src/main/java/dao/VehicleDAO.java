package dao;

import model.Vehicle;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public List<Vehicle> findAll() throws Exception {
        String sql = "SELECT vehicle_id, type, model, plate_no, price_per_day, capacity, is_active, notes FROM vehicles ORDER BY type, price_per_day";
        List<Vehicle> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Vehicle(
                        rs.getInt("vehicle_id"),
                        rs.getString("type"),
                        rs.getString("model"),
                        rs.getString("plate_no"),
                        rs.getDouble("price_per_day"),
                        rs.getInt("capacity"),
                        rs.getInt("is_active") == 1,
                        rs.getString("notes")
                ));
            }
        }
        return list;
    }

    public Vehicle findById(int id) throws Exception {
        String sql = "SELECT vehicle_id, type, model, plate_no, price_per_day, capacity, is_active, notes FROM vehicles WHERE vehicle_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vehicle(
                            rs.getInt("vehicle_id"),
                            rs.getString("type"),
                            rs.getString("model"),
                            rs.getString("plate_no"),
                            rs.getDouble("price_per_day"),
                            rs.getInt("capacity"),
                            rs.getInt("is_active") == 1,
                            rs.getString("notes")
                    );
                }
            }
        }
        return null;
    }

    public void insert(String type, String model, String plateNo, double pricePerDay, int capacity, boolean active, String notes) throws Exception {
        String sql = "INSERT INTO vehicles (type, model, plate_no, price_per_day, capacity, is_active, notes) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setString(2, (model == null || model.isBlank()) ? null : model.trim());
            ps.setString(3, (plateNo == null || plateNo.isBlank()) ? null : plateNo.trim());
            ps.setDouble(4, pricePerDay);
            ps.setInt(5, capacity);
            ps.setInt(6, active ? 1 : 0);
            ps.setString(7, (notes == null || notes.isBlank()) ? null : notes.trim());
            ps.executeUpdate();
        }
    }

    public void update(int vehicleId, String type, String model, String plateNo, double pricePerDay, int capacity, boolean active, String notes) throws Exception {
        String sql = "UPDATE vehicles SET type=?, model=?, plate_no=?, price_per_day=?, capacity=?, is_active=?, notes=? WHERE vehicle_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setString(2, (model == null || model.isBlank()) ? null : model.trim());
            ps.setString(3, (plateNo == null || plateNo.isBlank()) ? null : plateNo.trim());
            ps.setDouble(4, pricePerDay);
            ps.setInt(5, capacity);
            ps.setInt(6, active ? 1 : 0);
            ps.setString(7, (notes == null || notes.isBlank()) ? null : notes.trim());
            ps.setInt(8, vehicleId);
            ps.executeUpdate();
        }
    }
}