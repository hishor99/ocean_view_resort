package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.FoodPackage;

public class FoodPackageDAO {

    // ✅ Main method you already had (keep this)
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

    // ✅ Alias method (optional) - so other code can call findActive()
    // This avoids changing servlet code if it's using findActive()
    public List<FoodPackage> findActive() throws Exception {
        return getActivePackages();
    }

    // ✅ Find one package by id (keep this)
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
}