package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Controller for exporting the admin dashboard report to a text file.
 */
@WebServlet("/admin/dashboard/export-report")
public class ExportDashboardController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final BookingService bookingService = new BookingService();

    /**
     * Handles GET requests to generate and download the dashboard report text file.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Gather dashboard statistics
            int totalUsers = userDAO.getTotalUsers();
            int totalVehicles = vehicleDAO.getTotalVehicles();
            int totalBookings = bookingService.getTotalBookingCount();
            int pendingBookings = bookingService.getPendingBookingCount();
            int approvedBookings = bookingService.getApprovedBookingCount();
            int rejectedBookings = bookingService.getRejectedBookingCount();
            double totalRevenue = bookingService.getTotalRevenue();

            // Set response headers for file download
            response.setContentType("text/plain");
            response.setHeader("Content-Disposition", "attachment; filename=\"dashboard_report_" + System.currentTimeMillis() + ".txt\"");

            PrintWriter writer = response.getWriter();

            // Write report header
            writer.println("===========================================");
            writer.println("         SAJHARIDE ADMIN DASHBOARD REPORT");
            writer.println("===========================================");
            writer.println("Generated: " + new java.util.Date());
            writer.println();

            // Write KPI metrics
            writer.println("PLATFORM METRICS");
            writer.println("-------------------------------------------");
            writer.println("Total Users:                   " + totalUsers);
            writer.println("Total Vehicles:                " + totalVehicles);
            writer.println("Total Bookings:                " + totalBookings);
            writer.println("Total Revenue:                 NPR " + String.format("%.2f", totalRevenue));
            writer.println();

            // Write booking status breakdown
            writer.println("BOOKING STATUS BREAKDOWN");
            writer.println("-------------------------------------------");
            writer.println("Pending Bookings:              " + pendingBookings);
            writer.println("Approved Bookings:             " + approvedBookings);
            writer.println("Rejected Bookings:             " + rejectedBookings);
            writer.println("Completed Bookings:            " + (totalBookings - pendingBookings - approvedBookings - rejectedBookings));
            writer.println();

            // Write summary
            writer.println("SUMMARY");
            writer.println("-------------------------------------------");
            writer.println("Platform is running with " + totalUsers + " registered users");
            writer.println("and " + totalVehicles + " active vehicle listings.");
            writer.println("Revenue from " + totalBookings + " bookings totals NPR " + String.format("%.2f", totalRevenue) + ".");
            writer.println();

            writer.println("===========================================");
            writer.println("           END OF REPORT");
            writer.println("===========================================");

            writer.flush();
            writer.close();

        } catch (SQLException e) {
            throw new ServletException("Unable to export dashboard report", e);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User loggedIn = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return false;
        String role = loggedIn.getRole() == null ? "" : loggedIn.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role);
    }
}

