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

@WebServlet("/owner/settings")
public class OwnerSettingsController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(User user) {
        String role = user.getRole() == null ? "" : user.getRole().trim();
        return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
    }
}
