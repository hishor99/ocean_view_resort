package dao;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class UserDAOTest {

    @BeforeAll
    static void checkDb() throws Exception {
        TestDB.assertDbConnectionWorks();
    }

    @Test
    void testEmailExists_falseForRandomEmail() throws Exception {
        UserDAO dao = new UserDAO();
        boolean exists = dao.emailExists("no_such_user_" + System.currentTimeMillis() + "@mail.com");
        assertFalse(exists);
    }

    @Test
    void testRegisterCustomer_thenEmailExistsTrue_thenCleanup() throws Exception {
        UserDAO dao = new UserDAO();

        String email = "junit_" + System.currentTimeMillis() + "@mail.com";
        String fullName = "JUnit Test User";
        String phone = "0771234567";
        String passwordHash = "test_hash"; // your system uses hashing; for test DB it's okay

        // If you don't have registerCustomer method, comment this test.
        dao.registerCustomer(fullName, email, phone, passwordHash);

        assertTrue(dao.emailExists(email), "Email should exist after registration");

        // Find inserted user_id then delete (cleanup)
        Integer userId = null;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT user_id FROM users WHERE email=? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) userId = rs.getInt(1);
            }
        }

        assumeTrue(userId != null, "Inserted test user not found for cleanup");
        TestDB.deleteById("users", "user_id", userId);
        assertFalse(dao.emailExists(email), "Email should not exist after cleanup delete");
    }
}