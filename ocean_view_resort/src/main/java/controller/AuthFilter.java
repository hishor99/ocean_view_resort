package controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

@WebFilter(urlPatterns = {"/customer/*", "/staff/*", "/manager/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String ctx = req.getContextPath();
        String uri = req.getRequestURI(); // includes context path
        String path = uri.substring(ctx.length()); // starts with /customer/... etc.

        HttpSession session = req.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        String role = (session == null) ? null : (String) session.getAttribute("role");

        // not logged in
        if (userId == null || role == null) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        String r = role.trim().toUpperCase();

        // CUSTOMER
        if (path.startsWith("/customer/") && !r.equals("CUSTOMER")) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        // STAFF (accept common names)
        if (path.startsWith("/staff/")) {
            boolean staffOk = r.equals("STAFF") || r.equals("RECEPTION") || r.equals("RECEPTION_STAFF");
            if (!staffOk) {
                res.sendRedirect(ctx + "/auth/login.jsp");
                return;
            }
        }

        // MANAGER
        if (path.startsWith("/manager/") && !r.equals("MANAGER")) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}