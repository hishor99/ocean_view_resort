package controller.staff;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Room;
import model.FoodPackage;
import model.Vehicle;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/staff/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FoodPackageDAO foodDAO = new FoodPackageDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/staff/add-reservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        Integer staffId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        String role = (session == null) ? null : (String) session.getAttribute("role");

        String r = (role == null) ? "" : role.trim().toUpperCase();
        boolean staffOk = "STAFF".equals(r) || "RECEPTION".equals(r) || "RECEPTION_STAFF".equals(r);

        if (staffId == null || !staffOk) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        String step = safe(req.getParameter("step"));

        try {

            // =========================
            // STEP 1: Check available rooms
            // =========================
            if ("checkRooms".equals(step)) {

                String fullName = safe(req.getParameter("full_name"));
                String address  = safe(req.getParameter("address"));
                String phone    = safe(req.getParameter("phone"));
                String email    = safe(req.getParameter("email"));

                String inStr  = safe(req.getParameter("check_in"));
                String outStr = safe(req.getParameter("check_out"));
                String gStr   = safe(req.getParameter("guests"));

                if (fullName.isEmpty()) throw new Exception("Guest name is required.");
                if (phone.isEmpty()) throw new Exception("Contact number is required.");
                if (inStr.isEmpty() || outStr.isEmpty()) throw new Exception("Check-in and check-out dates are required.");
                if (gStr.isEmpty()) throw new Exception("Guests is required.");

                LocalDate checkIn = LocalDate.parse(inStr);
                LocalDate checkOut = LocalDate.parse(outStr);

                int guests = Integer.parseInt(gStr);
                if (guests <= 0) throw new Exception("Guests must be at least 1.");
                if (!checkOut.isAfter(checkIn)) throw new Exception("Check-out must be after check-in.");

                HttpSession s = req.getSession(true);
                s.setAttribute("tmp_full_name", fullName);
                s.setAttribute("tmp_address", address);
                s.setAttribute("tmp_phone", phone);
                s.setAttribute("tmp_email", email);
                s.setAttribute("tmp_check_in", checkIn);
                s.setAttribute("tmp_check_out", checkOut);
                s.setAttribute("tmp_guests", guests);

                List<Room> rooms = roomDAO.findAvailableRooms(checkIn, checkOut, guests);
                List<FoodPackage> foodPackages = foodDAO.getActivePackages();
                List<Vehicle> vehicles = vehicleDAO.getActiveVehicles();

                req.setAttribute("rooms", rooms);
                req.setAttribute("foodPackages", foodPackages);
                req.setAttribute("vehicles", vehicles);

                req.getRequestDispatcher("/staff/select-room.jsp").forward(req, resp);
                return;
            }

            // =========================
            // STEP 2: Create reservation
            // =========================
            if ("createReservation".equals(step)) {

                HttpSession s = req.getSession(false);
                if (s == null) {
                    resp.sendRedirect(req.getContextPath() + "/staff/add-reservation");
                    return;
                }

                String fullName = (String) s.getAttribute("tmp_full_name");
                String address  = (String) s.getAttribute("tmp_address");
                String phone    = (String) s.getAttribute("tmp_phone");
                String email    = (String) s.getAttribute("tmp_email");

                LocalDate checkIn  = (LocalDate) s.getAttribute("tmp_check_in");
                LocalDate checkOut = (LocalDate) s.getAttribute("tmp_check_out");
                Integer guests     = (Integer) s.getAttribute("tmp_guests");

                String roomIdStr = safe(req.getParameter("room_id"));
                if (roomIdStr.isEmpty()) throw new Exception("Please select a room.");

                int roomId = Integer.parseInt(roomIdStr);

                // NEW ADD-ONS
                String foodIdStr = safe(req.getParameter("food_id"));
                String vehicleIdStr = safe(req.getParameter("vehicle_id"));

                Integer foodId = foodIdStr.isEmpty() ? null : Integer.parseInt(foodIdStr);
                Integer vehicleId = vehicleIdStr.isEmpty() ? null : Integer.parseInt(vehicleIdStr);

                int reservationId = reservationDAO.createWalkInReservation(
                        staffId,
                        fullName, address, phone, email,
                        roomId, checkIn, checkOut,
                        guests,
                        foodId, vehicleId
                );

                clearTmp(s);

                resp.sendRedirect(req.getContextPath() +
                        "/staff/reservation-invoice?reservationId=" + reservationId);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/staff/add-reservation");

        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/staff/add-reservation.jsp").forward(req, resp);
        }
    }

    private String safe(String v) {
        return (v == null) ? "" : v.trim();
    }

    private void clearTmp(HttpSession session) {
        session.removeAttribute("tmp_full_name");
        session.removeAttribute("tmp_address");
        session.removeAttribute("tmp_phone");
        session.removeAttribute("tmp_email");
        session.removeAttribute("tmp_check_in");
        session.removeAttribute("tmp_check_out");
        session.removeAttribute("tmp_guests");
    }
}