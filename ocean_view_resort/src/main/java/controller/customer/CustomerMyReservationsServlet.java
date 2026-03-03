package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ReservationDAO;

@WebServlet("/customer/myreservations")
public class CustomerMyReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ✅ login check
        Integer customerId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // ✅ optional role check (recommended)
        String role = (String) session.getAttribute("role");
        if (role != null && !role.equalsIgnoreCase("CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            List<Map<String, Object>> list = reservationDAO.getReservationsByCustomer(customerId);
            request.setAttribute("reservations", list);

            request.getRequestDispatcher("/customer/my-reservations.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load customer reservations", e);
        }
    }
}