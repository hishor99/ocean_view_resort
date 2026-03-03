package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Vehicle;

public class VehicleDAO {

    // ✅ Return ALL vehicles (active + inactive) - for Manager pages
    public List<Vehicle> findAll() throws Exception {
        String sql = "SELECT vehicle_id, type, model, plate_no, price_per_day, capacity, is_active, notes " +
                     "FROM vehicles ORDER BY vehicle_id DESC";

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
                        rs.getInt("is_active"),
                        rs.getString("notes")
                ));
            }
        }
        return list;
    }

    // ✅ Alias (optional)
    public List<Vehicle> getAllVehicles() throws Exception {
        return findAll();
    }

    // ✅ ACTIVE only - for Customer/Reservation pages
    public List<Vehicle> getActiveVehicles() throws Exception {
        String sql = "SELECT vehicle_id, type, model, plate_no, price_per_day, capacity, is_active, notes " +
                     "FROM vehicles WHERE is_active=1 ORDER BY type, model";

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
                        rs.getInt("is_active"),
                        rs.getString("notes")
                ));
            }
        }
        return list;
    }

    // ✅ Alias
    public List<Vehicle> findActive() throws Exception {
        return getActiveVehicles();
    }

    // ✅ Find one vehicle by id
    public Vehicle findById(int vehicleId) throws Exception {
        String sql = "SELECT vehicle_id, type, model, plate_no, price_per_day, capacity, is_active, notes " +
                     "FROM vehicles WHERE vehicle_id=? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vehicle(
                            rs.getInt("vehicle_id"),
                            rs.getString("type"),
                            rs.getString("model"),
                            rs.getString("plate_no"),
                            rs.getDouble("price_per_day"),
                            rs.getInt("capacity"),
                            rs.getInt("is_active"),
                            rs.getString("notes")
                    );
                }
            }
        }
        return null;
    }

    // ✅ Insert new vehicle (Manager)
    public void insert(String type, String model, String plateNo,
                       double pricePerDay, int capacity,
                       boolean active, String notes) throws Exception {

        if (type == null || type.isBlank()) throw new Exception("Vehicle type is required.");
        if (model == null) model = "";
        if (plateNo == null) plateNo = "";
        if (capacity <= 0) throw new Exception("Capacity must be at least 1.");

        String sql = "INSERT INTO vehicles (type, model, plate_no, price_per_day, capacity, is_active, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type.trim());
            ps.setString(2, model.trim());
            ps.setString(3, plateNo.trim());
            ps.setDouble(4, pricePerDay);
            ps.setInt(5, capacity);
            ps.setInt(6, active ? 1 : 0);
            ps.setString(7, (notes == null || notes.isBlank()) ? null : notes.trim());

            ps.executeUpdate();
        }
    }

    // ✅ Update existing vehicle (Manager)
    public void update(int vehicleId, String type, String model, String plateNo,
                       double pricePerDay, int capacity,
                       boolean active, String notes) throws Exception {

        if (vehicleId <= 0) throw new Exception("Invalid vehicle_id.");
        if (type == null || type.isBlank()) throw new Exception("Vehicle type is required.");
        if (model == null) model = "";
        if (plateNo == null) plateNo = "";
        if (capacity <= 0) throw new Exception("Capacity must be at least 1.");

        String sql = "UPDATE vehicles " +
                     "SET type=?, model=?, plate_no=?, price_per_day=?, capacity=?, is_active=?, notes=? " +
                     "WHERE vehicle_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type.trim());
            ps.setString(2, model.trim());
            ps.setString(3, plateNo.trim());
            ps.setDouble(4, pricePerDay);
            ps.setInt(5, capacity);
            ps.setInt(6, active ? 1 : 0);
            ps.setString(7, (notes == null || notes.isBlank()) ? null : notes.trim());
            ps.setInt(8, vehicleId);

            ps.executeUpdate();
        }
    }
}