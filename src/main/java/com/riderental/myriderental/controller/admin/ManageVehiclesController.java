package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/vehicles")
public class ManageVehiclesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAdminAccess(request, response)) {
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-vehicles.jsp").forward(request, response);
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
