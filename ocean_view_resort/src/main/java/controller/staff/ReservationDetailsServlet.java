package controller.staff;

import dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/staff/reservation-details")
public class ReservationDetailsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If URL has ?no=RES-2026-000001 then load details directly
        String no = safe(req.getParameter("no"));

        if (!no.isEmpty()) {
            try {
                Map<String, Object> details = reservationDAO.findByReservationNo(no);

                if (details == null) {
                    req.setAttribute("error", "Reservation not found for: " + no);
                } else {
                    req.setAttribute("details", details);
                }

            } catch (Exception e) {
                req.setAttribute("error", e.getMessage());
            }
        }

        req.getRequestDispatcher("/staff/reservation-details.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String reservationNo = safe(req.getParameter("reservation_no")); // form field name

        if (reservationNo.isEmpty()) {
            req.setAttribute("error", "Reservation number is required.");
            req.getRequestDispatcher("/staff/reservation-details.jsp").forward(req, resp);
            return;
        }

        try {
            Map<String, Object> details = reservationDAO.findByReservationNo(reservationNo);

            if (details == null) {
                req.setAttribute("error", "Reservation not found for: " + reservationNo);
            } else {
                req.setAttribute("details", details);
            }

            req.getRequestDispatcher("/staff/reservation-details.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/staff/reservation-details.jsp").forward(req, resp);
        }
    }

    private String safe(String v) {
        return (v == null) ? "" : v.trim();
    }
}