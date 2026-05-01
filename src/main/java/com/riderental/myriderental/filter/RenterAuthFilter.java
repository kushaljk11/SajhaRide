package com.riderental.myriderental.filter;

import com.riderental.myriderental.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/renter/*")
public class RenterAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Payment gateway callbacks can return without an application session.
        if (isPublicPaymentCallback(req)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("RENTER".equalsIgnoreCase(role)) {
            chain.doFilter(request, response);
            return;
        }

        if ("OWNER".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/owner/dashboard");
            return;
        }

        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login");
    }

    private boolean isPublicPaymentCallback(HttpServletRequest req) {
        if (!"GET".equalsIgnoreCase(req.getMethod())) {
            return false;
        }

        String servletPath = req.getServletPath();
        if (!"/renter/payment".equals(servletPath)) {
            return false;
        }

        String action = req.getParameter("action");
        return "esewaSuccess".equalsIgnoreCase(action)
                || "esewaFailure".equalsIgnoreCase(action)
                || "khaltiReturn".equalsIgnoreCase(action);
    }
}

