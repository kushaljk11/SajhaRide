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

        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();

        if ("owner".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        if ("renter".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/renter/dashboard");
            return;
        }

        if (!"admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int totalUsers = userDAO.findAll().size();
            int totalVehicles = vehicleDAO.countAll();
            int totalBookings = bookingService.getTotalBookingCount();
            int pendingBookings = bookingService.getPendingBookingCount();
            int approvedBookings = bookingService.getApprovedBookingCount();
            int rejectedBookings = bookingService.getRejectedBookingCount();
            double totalRevenue = bookingService.getTotalRevenue();

            List<Booking> recentBookings = bookingService.getAllBookings();
            List<User> recentUsers = userDAO.findAll();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalVehicles", totalVehicles);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("rejectedBookings", rejectedBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("recentUsers", recentUsers);

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin dashboard", e);
        }
    }
}