package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;

public class UserDAO {

    // ✅ Check if email already exists
    public boolean emailExists(String email) throws Exception {
        String sql = "SELECT user_id FROM users WHERE email = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ✅ Register new customer
    public void registerCustomer(String fullName, String email, String phone, String passwordHash) throws Exception {

        String sql = "INSERT INTO users (full_name, email, phone, password_hash, role, status) " +
                     "VALUES (?, ?, ?, ?, 'CUSTOMER', 'ACTIVE')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, (phone == null || phone.isBlank()) ? null : phone.trim());
            ps.setString(4, passwordHash);

            ps.executeUpdate();
        }
    }

    // ✅ Login (SAFE) -> returns User object (NOT ResultSet)
    public User login(String email, String passwordHash) throws Exception {

        String sql = "SELECT user_id, full_name, role, status FROM users " +
                     "WHERE email = ? AND password_hash = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("role"),
                            rs.getString("status")
                    );
                }
            }
        }

        return null; // invalid login
    }
}