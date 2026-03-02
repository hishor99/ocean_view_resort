package controller.staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // You can load dashboard data here later

        request.getRequestDispatcher("/staff/dashboard.jsp")
               .forward(request, response);
    }
}