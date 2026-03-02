package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Vehicle;

public class VehicleDAO {

    // ✅ Main method you already had (keep this)
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

    // ✅ Alias method (optional) - so servlet code can call findActive()
    public List<Vehicle> findActive() throws Exception {
        return getActiveVehicles();
    }

    // ✅ Find one vehicle by id (keep this)
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
}