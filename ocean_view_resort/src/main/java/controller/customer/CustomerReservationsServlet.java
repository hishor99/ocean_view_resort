package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.ReservationDAO;

@WebServlet("/customer/reservations")
public class CustomerReservationsServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer customerId = (Integer) request.getSession().getAttribute("user_id");
            if (customerId == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }

            List<Map<String, Object>> list = reservationDAO.getReservationsByCustomer(customerId);
            request.setAttribute("reservations", list);

            request.getRequestDispatcher("/customer/reservations.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}