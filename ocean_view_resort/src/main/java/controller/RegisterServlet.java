package controller;

import dao.UserDAO;

import java.io.IOException;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private String clean(String s) { return s == null ? "" : s.trim(); }

    // Simple hashing (OK for assignment). Later we can use BCrypt.
    private String sha256(String input) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(input.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fullName = clean(request.getParameter("full_name"));
            String email = clean(request.getParameter("email")).toLowerCase();
            String phone = clean(request.getParameter("phone"));
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm_password");

            if (fullName.isEmpty() || email.isEmpty() || password == null || confirm == null) {
                request.setAttribute("error", "Please fill all required fields.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirm)) {
                request.setAttribute("error", "Password and Confirm Password do not match.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            UserDAO dao = new UserDAO();

            if (dao.emailExists(email)) {
                request.setAttribute("error", "This email is already registered.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            String passwordHash = sha256(password);
            dao.registerCustomer(fullName, email, phone, passwordHash);

            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
        }
    }
}