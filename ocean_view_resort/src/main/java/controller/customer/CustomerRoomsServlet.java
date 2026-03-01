package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import dao.RoomDAO;
import model.Room;

@WebServlet("/customer/rooms")
public class CustomerRoomsServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Room> rooms = roomDAO.getAvailableRooms(); // only AVAILABLE
            request.setAttribute("rooms", rooms);

            // ✅ Your JSP is here: src/main/webapp/customer/rooms.jsp
            request.getRequestDispatcher("/customer/rooms.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}