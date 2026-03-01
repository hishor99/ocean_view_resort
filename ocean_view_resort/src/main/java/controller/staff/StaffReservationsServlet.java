package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ReservationDAO;

@WebServlet("/staff/reservations")
public class StaffReservationsServlet extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            List<Map<String, Object>> list = reservationDAO.getPendingReservations();
            request.setAttribute("reservations", list);

            // flash message
            Object msg = session.getAttribute("flash_success");
            Object err = session.getAttribute("flash_error");
            if (msg != null) { request.setAttribute("success", msg); session.removeAttribute("flash_success"); }
            if (err != null) { request.setAttribute("error", err); session.removeAttribute("flash_error"); }

            request.getRequestDispatcher("/staff/view-reservations.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load pending reservations", e);
        }
    }
}