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

        HttpSession session = req.getSession(false);
        String ctx = req.getContextPath();
        String path = req.getRequestURI();

        // ✅ Allow assets even if under these paths (optional)
        if (path.startsWith(ctx + "/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        Integer userId = (session == null) ? null : (Integer) session.getAttribute("user_id");
        String role = (session == null) ? null : (String) session.getAttribute("role");

        // ✅ Not logged in
        if (userId == null || role == null) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        // ✅ Normalize role
        String r = role.trim().toUpperCase();

        // ✅ CUSTOMER access
        if (path.contains("/customer/") && !r.equals("CUSTOMER")) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        // ✅ STAFF access (accept common names)
        if (path.contains("/staff/")) {
            boolean staffOk = r.equals("RECEPTION") || r.equals("STAFF") || r.equals("RECEPTION_STAFF");
            if (!staffOk) {
                res.sendRedirect(ctx + "/auth/login.jsp");
                return;
            }
        }

        // ✅ MANAGER access
        if (path.contains("/manager/") && !r.equals("MANAGER")) {
            res.sendRedirect(ctx + "/auth/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}