package controller.manager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import dao.RoomDAO;

@WebServlet("/manager/rooms/delete")
public class DeleteRoomServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            roomDAO.deleteRoom(roomId);

            response.sendRedirect(request.getContextPath() + "/manager/rooms");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}