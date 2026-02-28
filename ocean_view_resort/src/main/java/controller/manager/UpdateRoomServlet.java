package controller.manager;

import dao.RoomDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/manager/rooms/update")
public class UpdateRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(req.getParameter("room_id"));
            double price = Double.parseDouble(req.getParameter("price_per_night"));
            int capacity = Integer.parseInt(req.getParameter("capacity"));
            String status = req.getParameter("status");

            new RoomDAO().updatePriceAndStatus(roomId, price, status, capacity);

            resp.sendRedirect(req.getContextPath() + "/manager/rooms");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}