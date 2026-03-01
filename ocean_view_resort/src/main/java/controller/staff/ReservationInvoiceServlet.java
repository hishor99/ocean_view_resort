package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

import dao.ReservationDAO;

@WebServlet("/staff/reservation-invoice")
public class ReservationInvoiceServlet extends HttpServlet {
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
            int id = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> invoice = reservationDAO.getReservationInvoice(id);

            if (invoice == null) {
                response.sendRedirect(request.getContextPath() + "/staff/reservations");
                return;
            }

            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/staff/reservation-invoice.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load invoice", e);
        }
    }
}