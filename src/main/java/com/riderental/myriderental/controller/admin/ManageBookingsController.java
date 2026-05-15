package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.service.BookingService;
import jakarta.servlet.ServletException;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller for managing bookings from the admin panel.
 */
@WebServlet("/admin/bookings")
public class ManageBookingsController extends HttpServlet {
    private final BookingService bookingService = new BookingService();

    /**
     * Handles GET requests to view the manage bookings page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            java.util.List<Booking> bookings = bookingService.getAllBookings();
            request.setAttribute("bookings", bookings);
            request.setAttribute("totalBookings", bookings == null ? 0 : bookings.size());
            request.setAttribute("totalRevenue", bookingService.getTotalRevenue());
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-bookings.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load bookings for admin", e);
        }
    }
}
