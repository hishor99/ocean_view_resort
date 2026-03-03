package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import dao.ReservationDAO;

@WebServlet("/staff/confirm-reservation")
public class ConfirmReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    private Integer toInt(Object v) {
        if (v == null) return null;
        if (v instanceof Integer) return (Integer) v;
        if (v instanceof String) {
            try { return Integer.parseInt(((String) v).trim()); }
            catch (Exception ignore) { return null; }
        }
        return null;
    }

    private boolean isStaffRole(String role) {
        if (role == null) return false;
        return role.equalsIgnoreCase("STAFF")
                || role.equalsIgnoreCase("RECEPTION_STAFF")
                || role.equalsIgnoreCase("RECEPTION");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Integer staffId = (session == null) ? null : toInt(session.getAttribute("user_id"));
        String role = (session == null) ? null : (String) session.getAttribute("role");

        // DEBUG (check Tomcat console)
        System.out.println("[CONFIRM] session=" + (session != null)
                + " user_id=" + staffId + " role=" + role);

        if (staffId == null || !isStaffRole(role)) {
            // keep a helpful message too
            if (session != null) session.setAttribute("flash_error", "Session/role invalid. Please login again.");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // reservation id
        int reservationId;
        try {
            reservationId = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            session.setAttribute("flash_error", "Invalid reservation id.");
            response.sendRedirect(request.getContextPath() + "/staff/view-reservations");
            return;
        }

        try {
            boolean ok = reservationDAO.confirmReservation(reservationId, staffId);

            if (ok) session.setAttribute("flash_success", "Reservation confirmed successfully!");
            else session.setAttribute("flash_error", "Cannot confirm. It may not be PENDING anymore.");

            response.sendRedirect(request.getContextPath() + "/staff/view-reservations");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Confirm failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/view-reservations");
        }
    }
}