package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import dao.ReservationDAO;

@WebServlet("/staff/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    private boolean isStaffRole(String role) {
        return role != null && (role.equalsIgnoreCase("STAFF")
                || role.equalsIgnoreCase("RECEPTION_STAFF")
                || role.equalsIgnoreCase("RECEPTION"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer staffId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (staffId == null || !isStaffRole(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int reservationId;
        try {
            reservationId = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            session.setAttribute("flash_error", "Invalid reservation id.");
            response.sendRedirect(request.getContextPath() + "/staff/view-reservations");
            return;
        }

        String reason = request.getParameter("reason");
        if (reason == null || reason.isBlank()) reason = "Cancelled by staff";

        try {
            boolean ok = reservationDAO.cancelReservation(reservationId, staffId, reason.trim());
            if (ok) session.setAttribute("flash_success", "Reservation cancelled successfully!");
            else session.setAttribute("flash_error", "Cancel failed. Reservation may not be PENDING.");
        } catch (Exception ex) {
            session.setAttribute("flash_error", "Cancel failed: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/staff/view-reservations");
    }
}