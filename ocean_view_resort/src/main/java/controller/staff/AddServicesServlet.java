package controller.staff;

import dao.ReservationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/add-services")
public class AddServicesServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String reservationIdStr = req.getParameter("reservationId");
        String resNo = req.getParameter("resNo");

        try {
            int reservationId = Integer.parseInt(reservationIdStr);

            List<Map<String, Object>> foods = reservationDAO.listActiveFoodPackages();
            List<Map<String, Object>> vehicles = reservationDAO.listActiveVehicles();

            req.setAttribute("reservationId", reservationId);
            req.setAttribute("resNo", resNo);
            req.setAttribute("foods", foods);
            req.setAttribute("vehicles", vehicles);

            req.getRequestDispatcher("/WEB-INF/staff/add_services.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            String resNo = req.getParameter("resNo");

            String foodIdStr = req.getParameter("food_id");
            String vehicleIdStr = req.getParameter("vehicle_id");

            Integer foodId = (foodIdStr == null || foodIdStr.isBlank()) ? null : Integer.parseInt(foodIdStr);
            Integer vehicleId = (vehicleIdStr == null || vehicleIdStr.isBlank()) ? null : Integer.parseInt(vehicleIdStr);

            reservationDAO.updateServicesAndRecalculate(reservationId, foodId, vehicleId);

            resp.sendRedirect(req.getContextPath() + "/staff/reservation-details?resNo=" + resNo);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}