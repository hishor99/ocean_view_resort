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
            HttpSession session = req.getSession(false);

            // ✅ optional security
            if (session == null || session.getAttribute("user_id") == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }
            String role = (String) session.getAttribute("role");
            if (role != null && !role.equalsIgnoreCase("MANAGER")) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

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
            throw new ServletException("Failed to load vehicles", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);

            // ✅ optional security
            if (session == null || session.getAttribute("user_id") == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }
            String role = (String) session.getAttribute("role");
            if (role != null && !role.equalsIgnoreCase("MANAGER")) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

            VehicleDAO dao = new VehicleDAO();

            String idStr = req.getParameter("vehicle_id");
            String type = req.getParameter("type");
            String model = req.getParameter("model");
            String plate = req.getParameter("plate_no");

            String priceStr = req.getParameter("price_per_day");
            String capStr = req.getParameter("capacity");

            if (type == null || type.isBlank()) throw new Exception("Vehicle type is required.");
            if (priceStr == null || priceStr.isBlank()) throw new Exception("Price per day is required.");
            if (capStr == null || capStr.isBlank()) throw new Exception("Capacity is required.");

            double price = Double.parseDouble(priceStr);
            int capacity = Integer.parseInt(capStr);

            boolean active = "1".equals(req.getParameter("is_active"));
            String notes = req.getParameter("notes");

            if (idStr == null || idStr.isBlank()) {
                dao.insert(type.trim(), model, plate, price, capacity, active, notes);
            } else {
                dao.update(Integer.parseInt(idStr), type.trim(), model, plate, price, capacity, active, notes);
            }

            resp.sendRedirect(req.getContextPath() + "/manager/vehicles");

        } catch (Exception e) {
            throw new ServletException("Failed to save vehicle", e);
        }
    }
}