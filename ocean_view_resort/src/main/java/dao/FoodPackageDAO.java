package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.FoodPackage;

public class FoodPackageDAO {

    // ✅ Return ALL packages (active + inactive) - for Manager pages
    public List<FoodPackage> findAll() throws Exception {
        String sql = "SELECT food_id, name, price_per_day, pricing_type, is_active, description " +
                     "FROM food_packages ORDER BY food_id DESC";

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
                        rs.getInt("is_active"),
                        rs.getString("description")
                ));
            }
        }
        return list;
    }

    // ✅ Alias (optional)
    public List<FoodPackage> getAllPackages() throws Exception {
        return findAll();
    }

    // ✅ ACTIVE only - for Customer/Reservation pages
    public List<FoodPackage> getActivePackages() throws Exception {
        String sql = "SELECT food_id, name, price_per_day, pricing_type, is_active, description " +
                     "FROM food_packages WHERE is_active = 1 ORDER BY name";

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
                        rs.getInt("is_active"),
                        rs.getString("description")
                ));
            }
        }
        return list;
    }

    // ✅ Alias method - so other code can call findActive()
    public List<FoodPackage> findActive() throws Exception {
        return getActivePackages();
    }

    // ✅ Find one package by id
    public FoodPackage findById(int foodId) throws Exception {
        String sql = "SELECT food_id, name, price_per_day, pricing_type, is_active, description " +
                     "FROM food_packages WHERE food_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, foodId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new FoodPackage(
                            rs.getInt("food_id"),
                            rs.getString("name"),
                            rs.getDouble("price_per_day"),
                            rs.getString("pricing_type"),
                            rs.getInt("is_active"),
                            rs.getString("description")
                    );
                }
            }
        }
        return null;
    }

    // ✅ Insert new food package (Manager)
    public void insert(String name, double pricePerDay, String pricingType, boolean active, String description) throws Exception {

        if (name == null || name.isBlank()) throw new Exception("Food package name is required.");
        if (pricingType == null || pricingType.isBlank()) pricingType = "PER_ROOM_PER_DAY";

        String sql = "INSERT INTO food_packages (name, price_per_day, pricing_type, is_active, description) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setDouble(2, pricePerDay);
            ps.setString(3, pricingType.trim());
            ps.setInt(4, active ? 1 : 0);
            ps.setString(5, (description == null || description.isBlank()) ? null : description.trim());

            ps.executeUpdate();
        }
    }

    // ✅ Update existing food package (Manager)
    public void update(int foodId, String name, double pricePerDay, String pricingType, boolean active, String description) throws Exception {

        if (foodId <= 0) throw new Exception("Invalid food_id.");
        if (name == null || name.isBlank()) throw new Exception("Food package name is required.");
        if (pricingType == null || pricingType.isBlank()) pricingType = "PER_ROOM_PER_DAY";

        String sql = "UPDATE food_packages " +
                     "SET name=?, price_per_day=?, pricing_type=?, is_active=?, description=? " +
                     "WHERE food_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setDouble(2, pricePerDay);
            ps.setString(3, pricingType.trim());
            ps.setInt(4, active ? 1 : 0);
            ps.setString(5, (description == null || description.isBlank()) ? null : description.trim());
            ps.setInt(6, foodId);

            ps.executeUpdate();
        }
    }
}