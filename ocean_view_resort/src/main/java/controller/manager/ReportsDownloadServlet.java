package controller.manager;

import dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.Map;

@WebServlet("/manager/reports/download")
public class ReportsDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int year = LocalDate.now().getYear();
        try {
            String y = req.getParameter("year");
            if (y != null && !y.isBlank()) year = Integer.parseInt(y.trim());
        } catch (Exception ignore) {}

        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"reports_" + year + ".csv\"");

        try (PrintWriter out = resp.getWriter()) {
            ReservationDAO dao = new ReservationDAO();

            Map<String, Integer> byMonth = dao.getReservationCountByMonth(year);
            Map<String, Integer> byStatus = dao.getReservationCountByStatus();
            Map<String, Double> revenue = dao.getRevenueByMonth(year);

            out.println("Reservations per Month");
            out.println("month,count");
            for (var e : byMonth.entrySet()) {
                out.println(e.getKey() + "," + e.getValue());
            }
            out.println();

            out.println("Reservations by Status");
            out.println("status,count");
            for (var e : byStatus.entrySet()) {
                out.println(e.getKey() + "," + e.getValue());
            }
            out.println();

            out.println("Revenue per Month (CONFIRMED/COMPLETED)");
            out.println("month,revenue");
            for (var e : revenue.entrySet()) {
                out.println(e.getKey() + "," + e.getValue());
            }
        } catch (Exception e) {
            resp.reset();
            resp.setContentType("text/plain; charset=UTF-8");
            resp.getWriter().println("Failed to generate CSV: " + e.getMessage());
        }
    }
}