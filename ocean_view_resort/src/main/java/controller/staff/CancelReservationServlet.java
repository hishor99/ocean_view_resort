package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import dao.ReservationDAO;

@WebServlet("/staff/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer staffId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            int reservationId = Integer.parseInt(request.getParameter("id"));
            String reason = request.getParameter("reason");
            reservationDAO.cancelReservation(reservationId, staffId, reason);

            session.setAttribute("flash_success", "Reservation cancelled successfully!");
            response.sendRedirect(request.getContextPath() + "/staff/reservations");
        } catch (Exception e) {
            session.setAttribute("flash_error", "Cancel failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/reservations");
        }
    }
}