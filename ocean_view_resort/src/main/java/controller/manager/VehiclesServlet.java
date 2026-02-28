package controller.manager;

import dao.VehicleDAO;
import model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/manager/vehicles")
public class VehiclesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            VehicleDAO dao = new VehicleDAO();

            String editId = req.getParameter("edit");
            if (editId != null && !editId.isBlank()) {
                Vehicle v = dao.findById(Integer.parseInt(editId));
                req.setAttribute("editVehicle", v);
            }

            List<Vehicle> list = dao.findAll();
            req.setAttribute("vehicles", list);
            req.getRequestDispatcher("/manager/vehicles.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            VehicleDAO dao = new VehicleDAO();

            String idStr = req.getParameter("vehicle_id");
            String type = req.getParameter("type");
            String model = req.getParameter("model");
            String plate = req.getParameter("plate_no");
            double price = Double.parseDouble(req.getParameter("price_per_day"));
            int capacity = Integer.parseInt(req.getParameter("capacity"));
            boolean active = "1".equals(req.getParameter("is_active"));
            String notes = req.getParameter("notes");

            if (idStr == null || idStr.isBlank()) {
                dao.insert(type.trim(), model, plate, price, capacity, active, notes);
            } else {
                dao.update(Integer.parseInt(idStr), type.trim(), model, plate, price, capacity, active, notes);
            }

            resp.sendRedirect(req.getContextPath() + "/manager/vehicles");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}