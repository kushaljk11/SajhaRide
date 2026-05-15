package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.dao.VehicleDAO;
import jakarta.servlet.ServletException;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller for managing vehicles from the admin panel.
 */
@WebServlet("/admin/vehicles")
public class ManageVehiclesController extends HttpServlet {
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to view the manage vehicles page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAdminAccess(request, response)) {
            return;
        }

        try {
            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");
            String status = request.getParameter("status");

            java.util.List<com.riderental.myriderental.model.Vehicle> vehicles =
                    vehicleDAO.findForAdmin(keyword, type, status);
            int totalVehicles = vehicleDAO.getTotalVehicles();
            int activePosts = vehicleDAO.countByStatus("AVAILABLE");
            int awaitingApproval = vehicleDAO.countByStatus("PENDING");
            int blockedListings = vehicleDAO.countByStatusIn("BLOCKED", "MAINTENANCE");

            // Calculate total booking value from all approved/completed bookings
            double totalBookingValue = 0;
            try {
                com.riderental.myriderental.dao.BookingDAO bookingDAO = new com.riderental.myriderental.dao.BookingDAO();
                totalBookingValue = bookingDAO.calculateTotalRevenue();
            } catch (Exception ignored) {}

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("activePosts", activePosts);
            request.setAttribute("awaitingApproval", awaitingApproval);
            request.setAttribute("blockedListings", blockedListings);
            request.setAttribute("totalBookingValue", totalBookingValue);
            request.setAttribute("keyword", keyword);
            request.setAttribute("type", type);
            request.setAttribute("status", status);
            request.setAttribute("filteredVehicleCount", vehicles.size());
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-vehicles.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load vehicles for admin", e);
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
