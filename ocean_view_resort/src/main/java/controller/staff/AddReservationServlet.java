package controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import dao.RoomDAO;
import dao.ReservationDAO;
import model.Room;

@WebServlet("/staff/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    private Integer intOrNull(String v) {
        if (v == null || v.isBlank()) return null;
        return Integer.parseInt(v.trim());
    }

    private Double doubleOrZero(String v) {
        if (v == null || v.isBlank()) return 0.0;
        return Double.parseDouble(v.trim());
    }

    private void ensureLoggedIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        }
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user_id") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // login check
        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            // show AVAILABLE rooms
            List<Room> rooms = roomDAO.getAvailableRooms();
            request.setAttribute("rooms", rooms);

            request.getRequestDispatcher("/staff/add-reservation.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load available rooms", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // login check
        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            // Decide which flow based on customerId presence
            String customerIdStr = request.getParameter("customerId");

            // Common fields
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
            int guests = Integer.parseInt(request.getParameter("guests"));

            if (!checkOut.isAfter(checkIn)) {
                throw new IllegalArgumentException("Check-out must be after check-in.");
            }

            // If nights not provided, compute it safely
            Integer nightsParam = intOrNull(request.getParameter("nights"));
            int nights = (nightsParam != null) ? nightsParam : (int) ChronoUnit.DAYS.between(checkIn, checkOut);

            int reservationId;

            // ===== FLOW 1: Existing customer reservation (with totals & optional add-ons) =====
            if (customerIdStr != null && !customerIdStr.isBlank()) {

                int customerId = Integer.parseInt(customerIdStr.trim());

                Integer foodId = intOrNull(request.getParameter("foodId"));
                Integer vehicleId = intOrNull(request.getParameter("vehicleId"));

                double roomTotal = doubleOrZero(request.getParameter("roomTotal"));
                double foodTotal = doubleOrZero(request.getParameter("foodTotal"));
                double vehicleTotal = doubleOrZero(request.getParameter("vehicleTotal"));
                double grandTotal = doubleOrZero(request.getParameter("grandTotal"));

                reservationId = reservationDAO.createReservation(
                        customerId, roomId,
                        checkIn, checkOut,
                        nights, guests,
                        foodId, vehicleId,
                        roomTotal, foodTotal,
                        vehicleTotal, grandTotal
                );

                request.setAttribute("success", "Reservation created successfully! ID: " + reservationId);

                // reload rooms for UI
                try {
                    List<Room> rooms = roomDAO.getAvailableRooms();
                    request.setAttribute("rooms", rooms);
                } catch (Exception ignore) {}

                request.getRequestDispatcher("/staff/add-reservation.jsp").forward(request, response);
                return;
            }

            // ===== FLOW 2: Walk-in reservation (guest details) =====
            String guestName = request.getParameter("guestName");
            String guestAddress = request.getParameter("guestAddress");
            String guestPhone = request.getParameter("guestPhone");
            String guestEmail = request.getParameter("guestEmail");

            // Basic validation (you can relax if you want)
            if (guestName == null || guestName.isBlank()) {
                throw new IllegalArgumentException("Guest name is required for walk-in reservations.");
            }

            reservationId = reservationDAO.createWalkInReservation(
                    guestName, guestAddress, guestPhone, guestEmail,
                    roomId, checkIn, checkOut, guests
            );

            // Go to Step 2 (optional add-ons)
            response.sendRedirect(request.getContextPath() + "/staff/add-ons?rid=" + reservationId);

        } catch (Exception e) {
            // reload rooms for UI
            try {
                List<Room> rooms = roomDAO.getAvailableRooms();
                request.setAttribute("rooms", rooms);
            } catch (Exception ignore) {}

            request.setAttribute("error", "Create failed: " + e.getMessage());
            request.getRequestDispatcher("/staff/add-reservation.jsp").forward(request, response);
        }
    }
}