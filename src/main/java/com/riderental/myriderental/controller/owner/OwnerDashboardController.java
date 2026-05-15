package com.riderental.myriderental.controller.owner;

import com.google.gson.Gson;
import com.riderental.myriderental.dao.OwnerDashboardDAO;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller for displaying the owner dashboard and its metrics.
 */
@WebServlet("/owner/dashboard")
public class OwnerDashboardController extends HttpServlet {

    private final OwnerDashboardDAO ownerDashboardDAO = new OwnerDashboardDAO();
    private final Gson gson = new Gson();

    /**
     * Handles GET requests to populate and display the owner dashboard.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int ownerId = sessionUser.getUserId();

            int totalVehicles = ownerDashboardDAO.countTotalVehicles(ownerId);
            int availableVehicles = ownerDashboardDAO.countAvailableVehicles(ownerId);
            int bookedVehicles = ownerDashboardDAO.countBookedVehicles(ownerId);
            int maintenanceVehicles = ownerDashboardDAO.countMaintenanceVehicles(ownerId);

            int totalBookings = ownerDashboardDAO.countTotalBookings(ownerId);
            int pendingBookings = ownerDashboardDAO.countPendingBookings(ownerId);
            int approvedBookings = ownerDashboardDAO.countApprovedBookings(ownerId);
            int cancelledRejectedBookings = ownerDashboardDAO.countRejectedOrCancelledBookings(ownerId);

            double totalEarnings = ownerDashboardDAO.calculateTotalEarnings(ownerId);

            List<Booking> recentBookings = ownerDashboardDAO.findRecentBookings(ownerId, 5);

            String success = request.getParameter("success");
            if (success != null && !success.isBlank()) {
                request.setAttribute("successMessage", success);
            }

            request.setAttribute("ownerUser", sessionUser);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("availableVehicles", availableVehicles);
            request.setAttribute("bookedVehicles", bookedVehicles);
            request.setAttribute("maintenanceVehicles", maintenanceVehicles);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("cancelledRejectedBookings", cancelledRejectedBookings);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("recentBookings", recentBookings);

            request.setAttribute("bookingStatusChartJson", gson.toJson(ownerDashboardDAO.findBookingStatusSeries(ownerId)));
            request.setAttribute("monthlyEarningsChartJson", gson.toJson(ownerDashboardDAO.findMonthlyEarningsSeries(ownerId, LocalDate.now().getYear())));
            request.setAttribute("vehicleAvailabilityChartJson", gson.toJson(ownerDashboardDAO.findVehicleAvailabilitySeries(ownerId)));

            request.getRequestDispatcher("/WEB-INF/views/owner/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("ownerUser", sessionUser);
            request.setAttribute("totalVehicles", 0);
            request.setAttribute("availableVehicles", 0);
            request.setAttribute("bookedVehicles", 0);
            request.setAttribute("maintenanceVehicles", 0);
            request.setAttribute("totalBookings", 0);
            request.setAttribute("pendingBookings", 0);
            request.setAttribute("approvedBookings", 0);
            request.setAttribute("cancelledRejectedBookings", 0);
            request.setAttribute("totalEarnings", 0.0);
            request.setAttribute("recentBookings", java.util.Collections.emptyList());
            request.setAttribute("bookingStatusChartJson", "[]");
            request.setAttribute("monthlyEarningsChartJson", "[]");
            request.setAttribute("vehicleAvailabilityChartJson", "[]");
            request.getRequestDispatcher("/WEB-INF/views/owner/dashboard.jsp").forward(request, response);
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
}
