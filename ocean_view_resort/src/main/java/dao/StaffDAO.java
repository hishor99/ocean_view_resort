package dao;

import java.sql.*;
import java.util.*;

public class StaffDAO {

    private static final String ROLE_STAFF = "RECEPTION"; // your table enum uses RECEPTION

    public List<Map<String, Object>> getAllStaff() throws Exception {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT user_id, full_name, email, phone, status " +
                     "FROM users " +
                     "WHERE role = ? " +
                     "ORDER BY user_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ROLE_STAFF);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("user_id", rs.getInt("user_id"));
                    row.put("full_name", rs.getString("full_name"));
                    row.put("email", rs.getString("email"));
                    row.put("phone", rs.getString("phone"));
                    row.put("status", rs.getString("status"));

                    list.add(row);
                }
            }
        }

        return list;
    }

    public void addStaff(String name, String email, String phone, String passwordHash) throws Exception {

        String sql = "INSERT INTO users(full_name, email, phone, password_hash, role, status) " +
                     "VALUES(?, ?, ?, ?, ?, 'ACTIVE')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, (phone == null || phone.isBlank()) ? null : phone.trim());
            ps.setString(4, passwordHash); // should be hashed already
            ps.setString(5, ROLE_STAFF);

            ps.executeUpdate();

        } catch (SQLIntegrityConstraintViolationException dup) {
            // because users.email is UNIQUE
            throw new Exception("Email already exists. Use another email.");
        }
    }

    public void deleteStaff(int id) throws Exception {

        // safer: only delete reception staff, not manager/customer by mistake
        String sql = "DELETE FROM users WHERE user_id = ? AND role = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setString(2, ROLE_STAFF);

            ps.executeUpdate();
        }
    }
}