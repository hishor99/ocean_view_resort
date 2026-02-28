package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private String sha256(String input) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
                request.setAttribute("error", "Please enter email and password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            email = email.trim().toLowerCase();
            String passwordHash = sha256(password);

            UserDAO dao = new UserDAO();
            User user = dao.login(email, passwordHash); // ✅ returns User (not ResultSet)

            if (user == null) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            if (!"ACTIVE".equals(user.getStatus())) {
                request.setAttribute("error", "Account is inactive.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // ✅ Create Session
            HttpSession session = request.getSession(true);
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("full_name", user.getFullName());
            session.setAttribute("role", user.getRole());

            String role = user.getRole();

            // ✅ Role-based redirect
            if ("CUSTOMER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
            } else if ("RECEPTION".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/staff/dashboard.jsp");
            } else if ("MANAGER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            } else {
                // fallback if role is unknown
                session.invalidate();
                request.setAttribute("error", "Unknown role. Please contact admin.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
}