package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/users/*")
public class AdminUsersActionController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo(); // e.g. /delete or /suspend
        if (path == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        // Ensure admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            if (path.equalsIgnoreCase("/delete")) {
                userDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
                return;
            }

            if (path.equalsIgnoreCase("/suspend")) {
                User u = userDAO.findById(id);
                if (u != null) {
                    u.setAccountStatus("SUSPENDED");
                    userDAO.update(u);
                }
                response.sendRedirect(request.getContextPath() + "/admin/users?success=suspended");
                return;
            }

        } catch (NumberFormatException e) {
            // ignore
        } catch (SQLException e) {
            throw new ServletException("Unable to perform admin user action", e);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private boolean isAdmin(HttpServletRequest request) {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        User loggedIn = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return false;
        String role = loggedIn.getRole() == null ? "" : loggedIn.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role);
    }
}


