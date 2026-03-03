package controller.staff;

import dao.RoomDAO;
import model.Room;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/staff/available-rooms")
public class AvailableRoomsServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        try {
            String roomType = req.getParameter("room_type");
            LocalDate checkIn = LocalDate.parse(req.getParameter("check_in"));
            LocalDate checkOut = LocalDate.parse(req.getParameter("check_out"));

            List<Room> rooms = roomDAO.getAvailableRoomsByTypeAndDates(roomType, checkIn, checkOut);

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < rooms.size(); i++) {
                Room r = rooms.get(i);

                json.append("{")
                        .append("\"roomId\":").append(r.getRoomId()).append(",")
                        .append("\"roomNumber\":\"").append(escape(r.getRoomNumber())).append("\",")
                        .append("\"price\":").append(r.getPricePerNight()).append(",")
                        .append("\"capacity\":").append(r.getCapacity())
                        .append("}");

                if (i < rooms.size() - 1) json.append(",");
            }

            json.append("]");
            resp.getWriter().write(json.toString());

        } catch (Exception e) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"" + escape(e.getMessage()) + "\"}");
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}