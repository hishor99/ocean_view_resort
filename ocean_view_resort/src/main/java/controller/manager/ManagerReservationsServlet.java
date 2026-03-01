package controller.manager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ReservationDAO;

@WebServlet("/manager/reservations")
public class ManagerReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String status = request.getParameter("status"); // ALL / PENDING / CONFIRMED / CANCELLED
            List<Map<String, Object>> list = reservationDAO.getAllReservations(status);

            request.setAttribute("list", list);
            request.setAttribute("status", (status == null || status.isBlank()) ? "ALL" : status);

            request.getRequestDispatcher("/manager/reservations.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load reservations (manager)", e);
        }
    }
}