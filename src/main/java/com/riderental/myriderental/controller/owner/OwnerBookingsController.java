package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.OwnerDashboardDAO;
import com.riderental.myriderental.dao.BookingDAO;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/bookings")
public class OwnerBookingsController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final OwnerDashboardDAO ownerDashboardDAO = new OwnerDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null || !ensureOwnerAccess(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int ownerId = sessionUser.getUserId();
            List<Booking> bookings = bookingDAO.findByOwner(ownerId);
            List<Booking> pendingBookings = new ArrayList<>();
            List<Booking> approvedBookings = new ArrayList<>();
            List<Booking> completedBookings = new ArrayList<>();
            List<Booking> rejectedCancelledBookings = new ArrayList<>();

            for (Booking booking : bookings) {
                String status = booking.getStatus() == null ? "" : booking.getStatus().trim().toUpperCase();
                switch (status) {
                    case "PENDING" -> pendingBookings.add(booking);
                    case "APPROVED" -> approvedBookings.add(booking);
                    case "COMPLETED" -> completedBookings.add(booking);
                    default -> rejectedCancelledBookings.add(booking);
                }
            }

            request.setAttribute("bookings", bookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("approvedBookings", approvedBookings);
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("rejectedCancelledBookings", rejectedCancelledBookings);
            request.setAttribute("totalBookings", bookings.size());
            request.setAttribute("pendingCount", pendingBookings.size());
            request.setAttribute("approvedCount", approvedBookings.size());
            request.setAttribute("cancelledRejectedCount", rejectedCancelledBookings.size());
            request.setAttribute("totalEarnings", ownerDashboardDAO.calculateTotalEarnings(ownerId));
            request.getRequestDispatcher("/WEB-INF/views/owner/bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load owner bookings", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(User user) {
        String role = user.getRole() == null ? "" : user.getRole().trim();
        return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
    }
}
