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

            // ✅ Your JSP is here: src/main/webapp/manager/rooms.jsp
            request.getRequestDispatcher("/manager/rooms.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            double price = Double.parseDouble(request.getParameter("pricePerNight"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String status = request.getParameter("status");

            roomDAO.addRoom(roomNumber, roomType, price, capacity, status);

            response.sendRedirect(request.getContextPath() + "/manager/rooms");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}