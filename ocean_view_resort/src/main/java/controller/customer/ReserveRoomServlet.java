package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import dao.*;
import model.*;

@WebServlet("/customer/reserve")
public class ReserveRoomServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final FoodPackageDAO foodDAO = new FoodPackageDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Room room = roomDAO.findById(roomId);

            List<FoodPackage> foods = foodDAO.getActivePackages();
            List<Vehicle> vehicles = vehicleDAO.getActiveVehicles();

            request.setAttribute("room", room);
            request.setAttribute("foods", foods);
            request.setAttribute("vehicles", vehicles);

            request.getRequestDispatcher("/customer/reserve.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer customerId = (Integer) request.getSession().getAttribute("user_id");
            if (customerId == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }

            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int guests = Integer.parseInt(request.getParameter("guests"));

            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

            if (!checkOut.isAfter(checkIn)) {
                request.setAttribute("error", "Check-out must be after check-in.");
                request.setAttribute("room", roomDAO.findById(roomId));
                request.setAttribute("foods", foodDAO.getActivePackages());
                request.setAttribute("vehicles", vehicleDAO.getActiveVehicles());
                request.getRequestDispatcher("/customer/reserve.jsp").forward(request, response);
                return;
            }

            int nights = (int) ChronoUnit.DAYS.between(checkIn, checkOut);

            Room room = roomDAO.findById(roomId);
            if (room == null) throw new ServletException("Room not found");

            if (guests < 1) guests = 1;
            if (guests > room.getCapacity()) guests = room.getCapacity();

            Integer foodId = null;
            String foodIdStr = request.getParameter("foodId");
            if (foodIdStr != null && !foodIdStr.isBlank() && !"0".equals(foodIdStr)) foodId = Integer.parseInt(foodIdStr);

            Integer vehicleId = null;
            String vehicleIdStr = request.getParameter("vehicleId");
            if (vehicleIdStr != null && !vehicleIdStr.isBlank() && !"0".equals(vehicleIdStr)) vehicleId = Integer.parseInt(vehicleIdStr);

            double roomTotal = nights * room.getPricePerNight();

            double foodTotal = 0;
            FoodPackage fp = null;
            if (foodId != null) {
                fp = foodDAO.findById(foodId);
                if (fp != null) {
                    if ("PER_PERSON_PER_DAY".equalsIgnoreCase(fp.getPricingType())) {
                        foodTotal = nights * guests * fp.getPricePerDay();
                    } else {
                        foodTotal = nights * fp.getPricePerDay(); // PER_ROOM_PER_DAY
                    }
                }
            }

            double vehicleTotal = 0;
            Vehicle v = null;
            if (vehicleId != null) {
                v = vehicleDAO.findById(vehicleId);
                if (v != null) vehicleTotal = nights * v.getPricePerDay();
            }

            double grandTotal = roomTotal + foodTotal + vehicleTotal;

            int reservationId = reservationDAO.createReservation(
                    customerId, roomId, checkIn, checkOut, nights, guests,
                    foodId, vehicleId,
                    roomTotal, foodTotal, vehicleTotal, grandTotal
            );

            request.setAttribute("reservationId", reservationId);
            request.setAttribute("room", room);
            request.setAttribute("food", fp);
            request.setAttribute("vehicle", v);

            request.setAttribute("checkIn", checkIn.toString());
            request.setAttribute("checkOut", checkOut.toString());
            request.setAttribute("nights", nights);
            request.setAttribute("guests", guests);

            request.setAttribute("roomTotal", roomTotal);
            request.setAttribute("foodTotal", foodTotal);
            request.setAttribute("vehicleTotal", vehicleTotal);
            request.setAttribute("grandTotal", grandTotal);

            request.getRequestDispatcher("/customer/quote.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}