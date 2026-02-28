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
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            FoodPackageDAO dao = new FoodPackageDAO();

            String idStr = req.getParameter("food_id");
            String name = req.getParameter("name");
            double price = Double.parseDouble(req.getParameter("price_per_day"));
            String pricingType = req.getParameter("pricing_type");
            boolean active = "1".equals(req.getParameter("is_active"));
            String description = req.getParameter("description");

            if (idStr == null || idStr.isBlank()) {
                dao.insert(name.trim(), price, pricingType, active, description);
            } else {
                dao.update(Integer.parseInt(idStr), name.trim(), price, pricingType, active, description);
            }

            resp.sendRedirect(req.getContextPath() + "/manager/food-packages");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}