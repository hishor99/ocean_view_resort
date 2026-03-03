package controller.staff;

import dao.FoodPackageDAO;
import dao.VehicleDAO;
import dao.ReservationDAO;

import model.FoodPackage;
import model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/staff/add-services")
public class AddServicesServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FoodPackageDAO foodDAO = new FoodPackageDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String reservationIdStr = req.getParameter("reservationId");
        String resNo = req.getParameter("resNo");

        if (reservationIdStr == null || reservationIdStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/staff/view-reservations");
            return;
        }

        try {
            int reservationId = Integer.parseInt(reservationIdStr);

            List<FoodPackage> foods = foodDAO.findActive();     // ✅ ACTIVE food packages
            List<Vehicle> vehicles = vehicleDAO.findActive();   // ✅ ACTIVE vehicles

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int reservationId = Integer.parseInt(req.getParameter("reservationId"));
            String resNo = req.getParameter("resNo");

            String foodIdStr = req.getParameter("food_id");
            String vehicleIdStr = req.getParameter("vehicle_id");

            Integer foodId = (foodIdStr == null || foodIdStr.isBlank() || "0".equals(foodIdStr))
                    ? null : Integer.parseInt(foodIdStr);

            Integer vehicleId = (vehicleIdStr == null || vehicleIdStr.isBlank() || "0".equals(vehicleIdStr))
                    ? null : Integer.parseInt(vehicleIdStr);

            // ✅ Your DAO method
            reservationDAO.updateServicesAndRecalculate(reservationId, foodId, vehicleId);

            resp.sendRedirect(req.getContextPath() + "/staff/reservation-details?resNo=" + resNo);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}