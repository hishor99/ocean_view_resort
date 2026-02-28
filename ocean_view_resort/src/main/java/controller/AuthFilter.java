package controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
        "/customer/*",
        "/staff/*",
        "/manager/*"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String path = req.getRequestURI();

        // Role-based protection
        if (path.contains("/customer/") && !role.equals("CUSTOMER")) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        if (path.contains("/staff/") && !role.equals("RECEPTION")) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        if (path.contains("/manager/") && !role.equals("MANAGER")) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}