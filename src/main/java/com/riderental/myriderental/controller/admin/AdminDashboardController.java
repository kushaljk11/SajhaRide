package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.User;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final UserDAO userDAO = new UserDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Only admins can access this dashboard
        if (!"ADMIN".equals(sessionUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Platform wide stats for KPI cards
            int totalUsers = userDAO.findAll().size();
            int totalVehicles = vehicleDAO.countAll();
            int totalBookings = bookingService.getTotalBookingCount();
            int pendingBookings = bookingService.getPendingBookingCount();
            int approvedBookings = bookingService.getApprovedBookingCount();
            int rejectedBookings = bookingService.getRejectedBookingCount();
            double totalRevenue = bookingService.getTotalRevenue();

            // Recent bookings for the bookings table
            List<Booking> recentBookings = bookingService.getAllBookings();

            // Recent users for the users table
            List<User> recentUsers = userDAO.findAll();

            // Pass everything to JSP
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("rejectedBookings", rejectedBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("recentUsers", recentUsers);

            request.getRequestDispatcher("/views/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin dashboard", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}