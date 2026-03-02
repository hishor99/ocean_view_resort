package controller.manager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import dao.RoomDAO;
import model.Room;

@WebServlet("/manager/rooms")
public class ManagerRoomsServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Room> rooms = roomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);

            // ✅ JSP location (as you mentioned)
            request.getRequestDispatcher("/manager/rooms.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to load rooms: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomNumber  = request.getParameter("roomNumber");
            String roomType    = request.getParameter("roomType");
            String description = request.getParameter("description"); // ✅ NEW
            String status      = request.getParameter("status");

            double price = Double.parseDouble(request.getParameter("pricePerNight"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));

            // ✅ Updated DAO call (6 params)
            roomDAO.addRoom(
                    roomNumber != null ? roomNumber.trim() : null,
                    roomType != null ? roomType.trim() : null,
                    price,
                    capacity,
                    description,  // ✅ pass description
                    status
            );

            response.sendRedirect(request.getContextPath() + "/manager/rooms");

        } catch (NumberFormatException nfe) {
            // If user typed invalid numbers
            request.setAttribute("error", "Invalid number format for capacity or price.");
            doGet(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to add room: " + e.getMessage(), e);
        }
    }
}