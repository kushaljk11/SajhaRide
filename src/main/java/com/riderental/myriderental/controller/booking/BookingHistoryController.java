package com.riderental.myriderental.controller.booking;

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

@WebServlet("/booking/history")
public class BookingHistoryController extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Pass success message if redirected from booking request
        String success = request.getParameter("success");
        if (success != null && !success.isBlank()) {
            request.setAttribute("successMessage", success);
        }

        try {
            List<Booking> bookings = bookingService.getRenterBookings(sessionUser.getUserId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/views/booking/booking-history.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load booking history", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}