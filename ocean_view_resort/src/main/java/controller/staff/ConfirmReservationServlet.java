package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import dao.ReservationDAO;

@WebServlet("/staff/confirm-reservation")
public class ConfirmReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Get existing session only
        HttpSession session = request.getSession(false);

        // ✅ Check staff login
        Integer staffId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (staffId == null || role == null || !"STAFF".equalsIgnoreCase(role)) {
            // No session / not staff -> go login
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // ✅ Validate reservation ID
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            session.setAttribute("flash_error", "Confirm failed: Reservation ID is missing.");
            response.sendRedirect(request.getContextPath() + "/staff/reservations");
            return;
        }

        int reservationId;
        try {
            reservationId = Integer.parseInt(idParam);
            if (reservationId <= 0) throw new NumberFormatException("ID must be positive");
        } catch (NumberFormatException nfe) {
            session.setAttribute("flash_error", "Confirm failed: Invalid reservation ID.");
            response.sendRedirect(request.getContextPath() + "/staff/reservations");
            return;
        }

        try {
            // ✅ Confirm in DB (transaction)
            reservationDAO.confirmReservation(reservationId, staffId);

            session.setAttribute("flash_success", "Reservation confirmed successfully!");
            response.sendRedirect(request.getContextPath() + "/staff/reservations");

        } catch (Exception e) {
            // ✅ Print FULL error in server console (Eclipse)
            e.printStackTrace();

            // ✅ More helpful message for UI
            String msg = e.getMessage();
            if (msg == null || msg.isBlank()) msg = "Unknown error occurred while confirming reservation.";

            session.setAttribute("flash_error", "Confirm failed: " + msg);
            response.sendRedirect(request.getContextPath() + "/staff/reservations");
        }
    }
}