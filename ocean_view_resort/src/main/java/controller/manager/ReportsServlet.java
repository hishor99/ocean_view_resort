package controller.manager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

import dao.ReportDAO;

@WebServlet("/manager/reports")
public class ReportsServlet extends HttpServlet {

    private ReportDAO dao = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int year;

        try {
            String yearParam = request.getParameter("year");
            year = (yearParam == null || yearParam.isBlank())
                    ? LocalDate.now().getYear()
                    : Integer.parseInt(yearParam);
        } catch (Exception e) {
            year = LocalDate.now().getYear();
        }

        try {

            // ✅ Load data from DAO
            Map<String,Integer> monthData = dao.getReservationsPerMonth(year);
            Map<String,Integer> statusData = dao.getReservationsByStatus();
            Map<String,Double> revenueData = dao.getRevenuePerMonth(year);

            // ✅ Send data to JSP
            request.setAttribute("monthData", monthData);
            request.setAttribute("statusData", statusData);
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("year", year);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load report data.");
        }

        request.getRequestDispatcher("/manager/reports.jsp").forward(request, response);
    }
}