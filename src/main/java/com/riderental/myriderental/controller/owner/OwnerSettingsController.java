package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller for viewing an owner's settings/profile page.
 */
@WebServlet("/owner/settings")
public class OwnerSettingsController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Handles GET requests to display the owner's settings.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null || !ensureOwnerAccess(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            User freshUser = userDAO.findById(sessionUser.getUserId());
            request.setAttribute("user", freshUser != null ? freshUser : sessionUser);
            request.getRequestDispatcher("/WEB-INF/views/owner/settings.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load owner settings", e);
        }
    }

    /**
     * Retrieves the logged-in user from the session.
     * @param request the HTTP request
     * @return the logged-in User, or null if not found
     */
    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    /**
     * Ensures that the requesting user has owner access.
     * @param user the currently logged-in user
     * @return true if the user is an owner, false otherwise
     */
    private boolean ensureOwnerAccess(User user) {
        String role = user.getRole() == null ? "" : user.getRole().trim();
        return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
    }
}
