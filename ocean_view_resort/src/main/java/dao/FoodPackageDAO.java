package dao;

import model.FoodPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodPackageDAO {

    public List<FoodPackage> findAll() throws Exception {
        String sql = "SELECT food_id, name, price_per_day, pricing_type, is_active, description FROM food_packages ORDER BY name";
        List<FoodPackage> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new FoodPackage(
                        rs.getInt("food_id"),
                        rs.getString("name"),
                        rs.getDouble("price_per_day"),
                        rs.getString("pricing_type"),
                        rs.getInt("is_active") == 1,
                        rs.getString("description")
                ));
            }
        }
        return list;
    }

    public FoodPackage findById(int id) throws Exception {
        String sql = "SELECT food_id, name, price_per_day, pricing_type, is_active, description FROM food_packages WHERE food_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new FoodPackage(
                            rs.getInt("food_id"),
                            rs.getString("name"),
                            rs.getDouble("price_per_day"),
                            rs.getString("pricing_type"),
                            rs.getInt("is_active") == 1,
                            rs.getString("description")
                    );
                }
            }
        }
        return null;
    }

    public void insert(String name, double pricePerDay, String pricingType, boolean active, String description) throws Exception {
        String sql = "INSERT INTO food_packages (name, price_per_day, pricing_type, is_active, description) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, pricePerDay);
            ps.setString(3, pricingType);
            ps.setInt(4, active ? 1 : 0);
            ps.setString(5, (description == null || description.isBlank()) ? null : description.trim());
            ps.executeUpdate();
        }
    }

    public void update(int foodId, String name, double pricePerDay, String pricingType, boolean active, String description) throws Exception {
        String sql = "UPDATE food_packages SET name=?, price_per_day=?, pricing_type=?, is_active=?, description=? WHERE food_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, pricePerDay);
            ps.setString(3, pricingType);
            ps.setInt(4, active ? 1 : 0);
            ps.setString(5, (description == null || description.isBlank()) ? null : description.trim());
            ps.setInt(6, foodId);
            ps.executeUpdate();
        }
    }
}