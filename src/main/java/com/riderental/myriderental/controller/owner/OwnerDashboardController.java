package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Vehicle;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/owner/dashboard")
public class OwnerDashboardController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Only owners can access this dashboard
        if (!"OWNER".equals(sessionUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Pass success message if redirected from approve/reject
        String success = request.getParameter("success");
        if (success != null && !success.isBlank()) {
            request.setAttribute("successMessage", success);
        }

        try {
            int ownerId = sessionUser.getUserId();

            // Get owner vehicles
            List<Vehicle> vehicles = vehicleDAO.findByOwner(ownerId);

            // Get all bookings for owner vehicles
            List<Booking> allBookings = bookingService.getOwnerBookings(ownerId);

            // Get pending bookings for the requests table
            List<Booking> pendingBookings = bookingService.getOwnerPendingBookings(ownerId);

            // Get total earnings
            double totalEarnings = bookingService.getOwnerEarnings(ownerId);

            // Pass everything to JSP
            request.setAttribute("vehicles", vehicles);
            request.setAttribute("allBookings", allBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("totalVehicles", vehicles.size());
            request.setAttribute("totalBookings", allBookings.size());
            request.setAttribute("pendingCount", pendingBookings.size());

            request.getRequestDispatcher("/views/owner/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load owner dashboard", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}