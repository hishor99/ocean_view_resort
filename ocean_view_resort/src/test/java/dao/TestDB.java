package dao;

import java.sql.*;

public final class TestDB {

    private TestDB() {}

    /** Ensures DB is reachable. Fails fast if DB not running / wrong config. */
    public static void assertDbConnectionWorks() throws Exception {
        try (Connection c = DBConnection.getConnection()) {
            if (c == null || c.isClosed()) {
                throw new SQLException("DBConnection.getConnection() returned null/closed connection");
            }
        }
    }

    /** Get any ID from a table (used when you already have seed data). */
    public static Integer getAnyId(String table, String idCol) throws Exception {
        String sql = "SELECT " + idCol + " FROM " + table + " ORDER BY " + idCol + " ASC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
            return null;
        }
    }

    /** Get any CUSTOMER user_id (recommended for reservation tests). */
    public static Integer getAnyCustomerId() throws Exception {
        // If your role values differ, change 'CUSTOMER'
        String sql = "SELECT user_id FROM users WHERE role='CUSTOMER' ORDER BY user_id ASC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
            // fallback: any user
            return getAnyId("users", "user_id");
        }
    }

    /** Delete by ID helper (cleanup). */
    public static int deleteById(String table, String idCol, int id) throws Exception {
        String sql = "DELETE FROM " + table + " WHERE " + idCol + "=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    /** Check if a row exists. */
    public static boolean existsById(String table, String idCol, int id) throws Exception {
        String sql = "SELECT 1 FROM " + table + " WHERE " + idCol + "=? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}