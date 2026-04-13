package com.riderental.myriderental.controller.renter;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/renter/dashboard")
public class RenterDashboardController extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Only renters can access this dashboard
        if (!"RENTER".equals(sessionUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Booking> allBookings = bookingService.getRenterBookings(
                    sessionUser.getUserId());

            // Separate bookings by status for dashboard stats
            List<Booking> pendingBookings = new ArrayList<>();
            List<Booking> approvedBookings = new ArrayList<>();
            List<Booking> completedBookings = new ArrayList<>();
            List<Booking> rejectedBookings = new ArrayList<>();

            for (Booking b : allBookings) {
                switch (b.getStatus()) {
                    case "PENDING" -> pendingBookings.add(b);
                    case "APPROVED" -> approvedBookings.add(b);
                    case "COMPLETED" -> completedBookings.add(b);
                    case "REJECTED" -> rejectedBookings.add(b);
                }
            }

            // Pass data to JSP
            request.setAttribute("allBookings", allBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("rejectedBookings", rejectedBookings);

            // Stats for the summary cards
            request.setAttribute("totalBookings", allBookings.size());
            request.setAttribute("pendingCount", pendingBookings.size());
            request.setAttribute("approvedCount", approvedBookings.size());
            request.setAttribute("completedCount", completedBookings.size());

            request.getRequestDispatcher("/views/renter/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load renter dashboard", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}