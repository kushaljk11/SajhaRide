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

        if (!ensureAdminAccess(request, response)) {
            return;
        }

        try {
            int totalUsers = userDAO.getTotalUsers();
            int totalVehicles = vehicleDAO.getTotalVehicles();
            int totalBookings = bookingService.getTotalBookingCount();
            int pendingBookings = bookingService.getPendingBookingCount();
            int approvedBookings = bookingService.getApprovedBookingCount();
            int rejectedBookings = bookingService.getRejectedBookingCount();
            double totalRevenue = bookingService.getTotalRevenue();

            List<Booking> recentBookings = new java.util.ArrayList<>();
            try {
                recentBookings = bookingService.getAllBookings();
            } catch (Exception ignored) {}

            List<User> recentUsers = new java.util.ArrayList<>();
            try {
                recentUsers = userDAO.findAll();
            } catch (Exception ignored) {}

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("rejectedBookings", rejectedBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("recentUsers", recentUsers);

            com.riderental.myriderental.dao.BookingDAO bookingDAO = new com.riderental.myriderental.dao.BookingDAO();
            List<Integer> weeklyBookings = bookingDAO.getLast7DaysBookings();
            List<Integer> weeklyPosts = vehicleDAO.getLast7DaysPosts();
            
            // Pass as JavaScript arrays using Gson or simple formatting
            request.setAttribute("weeklyBookingsStr", weeklyBookings.toString());
            request.setAttribute("weeklyPostsStr", weeklyPosts.toString());

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            // On DB failure, log and show safe defaults
            e.printStackTrace();
            request.setAttribute("totalUsers", 0);
            request.setAttribute("totalVehicles", 0);
            request.setAttribute("totalBookings", 0);
            request.setAttribute("pendingBookings", 0);
            request.setAttribute("approvedBookings", 0);
            request.setAttribute("rejectedBookings", 0);
            request.setAttribute("totalRevenue", 0.0);
            request.setAttribute("recentBookings", new java.util.ArrayList<>());
            request.setAttribute("recentUsers", new java.util.ArrayList<>());
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
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