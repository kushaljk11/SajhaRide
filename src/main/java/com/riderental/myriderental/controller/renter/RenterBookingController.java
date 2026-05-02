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

/**
 * Controller for viewing a renter's incoming and outgoing bookings.
 */
@WebServlet("/renter/booking")
public class RenterBookingController extends HttpServlet {
    private final BookingService bookingService = new BookingService();

    /**
     * Handles GET requests to display the renter's bookings page.
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
            List<Booking> ownerBookings = bookingService.getOwnerBookings(sessionUser.getUserId());
            List<Booking> renterBookings = bookingService.getRenterBookings(sessionUser.getUserId());

            List<Booking> pendingRequests = new ArrayList<>();
            List<Booking> activeRequests = new ArrayList<>();
            List<Booking> completedRequests = new ArrayList<>();

            for (Booking b : ownerBookings) {
                switch (b.getStatus() != null ? b.getStatus() : "PENDING") {
                    case "PENDING" -> pendingRequests.add(b);
                    case "APPROVED" -> activeRequests.add(b);
                    case "COMPLETED" -> completedRequests.add(b);
                    default -> pendingRequests.add(b);
                }
            }

            request.setAttribute("ownerBookings", ownerBookings);
            request.setAttribute("renterBookings", renterBookings);
            
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("activeRequests", activeRequests);
            request.setAttribute("completedRequests", completedRequests);
            
            request.setAttribute("totalRequests", ownerBookings.size());
            request.setAttribute("pendingCount", pendingRequests.size());
            request.setAttribute("activeCount", activeRequests.size());
            request.setAttribute("completedCount", completedRequests.size());
            
            request.setAttribute("totalTrips", renterBookings.size());

            String successMessage = request.getParameter("success");
            if (successMessage != null && !successMessage.isBlank()) {
                request.setAttribute("successMessage", successMessage);
            }

            String errorMessage = request.getParameter("error");
            if (errorMessage != null && !errorMessage.isBlank()) {
                request.setAttribute("errorMessage", errorMessage);
            }

            request.getRequestDispatcher("/WEB-INF/views/renter/booking.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load renter booking requests", e);
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
