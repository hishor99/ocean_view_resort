package controller.manager;

import dao.FoodPackageDAO;
import model.FoodPackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/manager/food-packages")
public class FoodPackagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);

            // ✅ Optional security check (recommended)
            if (session == null || session.getAttribute("user_id") == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }
            String role = (String) session.getAttribute("role");
            if (role != null && !role.equalsIgnoreCase("MANAGER")) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

            FoodPackageDAO dao = new FoodPackageDAO();

            String editId = req.getParameter("edit");
            if (editId != null && !editId.isBlank()) {
                FoodPackage fp = dao.findById(Integer.parseInt(editId));
                req.setAttribute("editFood", fp);
            }

            List<FoodPackage> list = dao.findAll();
            req.setAttribute("foods", list);

            req.getRequestDispatcher("/manager/food-packages.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Failed to load food packages", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);

            // ✅ Optional security check (recommended)
            if (session == null || session.getAttribute("user_id") == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }
            String role = (String) session.getAttribute("role");
            if (role != null && !role.equalsIgnoreCase("MANAGER")) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

            FoodPackageDAO dao = new FoodPackageDAO();

            String idStr = req.getParameter("food_id");
            String name = req.getParameter("name");

            String priceStr = req.getParameter("price_per_day");
            if (priceStr == null || priceStr.isBlank()) throw new Exception("Price per day is required.");
            double price = Double.parseDouble(priceStr);

            String pricingType = req.getParameter("pricing_type");
            boolean active = "1".equals(req.getParameter("is_active"));
            String description = req.getParameter("description");

            if (name == null || name.isBlank()) throw new Exception("Food package name is required.");

            if (idStr == null || idStr.isBlank()) {
                dao.insert(name.trim(), price, pricingType, active, description);
            } else {
                dao.update(Integer.parseInt(idStr), name.trim(), price, pricingType, active, description);
            }

            resp.sendRedirect(req.getContextPath() + "/manager/food-packages");

        } catch (Exception e) {
            throw new ServletException("Failed to save food package", e);
        }
    }
}