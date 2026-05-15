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

/**
 * Filter to ensure the user is authenticated and has the OWNER role.
 */
@WebFilter("/owner/*")
public class OwnerAuthFilter implements Filter {

    /**
     * Allows only authenticated OWNER users to access owner routes.
     *
     * @param request the ServletRequest object
     * @param response the ServletResponse object
     * @param chain the FilterChain
     * @throws IOException if an I/O error occurs
     * @throws ServletException if a servlet-specific error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("OWNER".equalsIgnoreCase(role)) {
            chain.doFilter(request, response);
            return;
        }

        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        if ("RENTER".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/renter/dashboard");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
