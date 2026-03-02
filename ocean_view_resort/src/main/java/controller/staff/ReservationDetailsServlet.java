package controller.staff;

import dao.ReservationDAO;
import dao.Reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/staff/reservation-details")
public class ReservationDetailsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String no = req.getParameter("no");
            Reservation r = reservationDAO.findByReservationNo(no);

            if (r == null) {
                req.setAttribute("error", "Reservation not found.");
            } else {
                req.setAttribute("res", r);
            }

            req.getRequestDispatcher("/WEB-INF/staff/reservation_details.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}