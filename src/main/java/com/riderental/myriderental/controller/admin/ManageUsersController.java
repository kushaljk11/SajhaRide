package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.dao.UserDAO;
import jakarta.servlet.ServletException;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller for managing users from the admin panel.
 */
@WebServlet("/admin/users")
public class ManageUsersController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    /**
     * Handles GET requests to view the manage users page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAdminAccess(request, response)) {
            return;
        }

        try {
            java.util.List<User> users = userDAO.findAll();
            int totalUsers = userDAO.getTotalUsers();
            int activeToday = userDAO.getTotalUsers(); // Or use login tracking if available
            int newRequests = userDAO.countByStatus("PENDING");

            request.setAttribute("users", users);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeToday", activeToday);
            request.setAttribute("newRequests", newRequests);
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load users for admin", e);
        }
    }

    private boolean ensureAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("admin".equalsIgnoreCase(role)) {
            return true;
        }

        if ("owner".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return false;
        }

        if ("renter".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/renter/dashboard");
            return false;
        }

        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }
}
