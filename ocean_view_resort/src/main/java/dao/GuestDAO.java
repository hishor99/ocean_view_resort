package dao;

public class GuestDAO {

}
package dao;

import java.sql.*;

public class GuestDAO {

    public int createGuest(String name, String address, String phone, String email) throws Exception {
        String sql = "INSERT INTO guests (full_name, address, phone, email) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, name);
            ps.setString(2, (address == null || address.isBlank()) ? null : address.trim());
            ps.setString(3, (phone == null || phone.isBlank()) ? null : phone.trim());
            ps.setString(4, (email == null || email.isBlank()) ? null : email.trim());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Failed to create guest.");
    }
}