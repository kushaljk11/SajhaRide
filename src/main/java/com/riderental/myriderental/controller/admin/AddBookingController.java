package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDateTime;

/**
 * Controller for adding a new booking from the admin panel.
 */
@WebServlet("/admin/bookings/create")
public class AddBookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    /**
     * Shows the add booking form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/add-booking.jsp").forward(request, response);
    }

    /**
     * Processes the submission to create a new booking.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String userIdStr = request.getParameter("userId");
            String vehicleIdStr = request.getParameter("vehicleId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String totalPriceStr = request.getParameter("totalPrice");
            String status = request.getParameter("status");

            if (userIdStr == null || userIdStr.isBlank() || vehicleIdStr == null || vehicleIdStr.isBlank() ||
                    startDateStr == null || startDateStr.isBlank() || endDateStr == null || endDateStr.isBlank() ||
                    totalPriceStr == null || totalPriceStr.isBlank() || status == null || status.isBlank()) {
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/WEB-INF/views/admin/add-booking.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdStr);
            int vehicleId = Integer.parseInt(vehicleIdStr);
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);
            double totalPrice = Double.parseDouble(totalPriceStr);

            Booking newBooking = new Booking();
            newBooking.setUserId(userId);
            newBooking.setVehicleId(vehicleId);
            newBooking.setStartDate(startDate.toLocalDate());
            newBooking.setEndDate(endDate.toLocalDate());
            newBooking.setTotalPrice(totalPrice);
            newBooking.setStatus(status);
            newBooking.setCreatedAt(LocalDateTime.now());

            bookingDAO.create(newBooking);
            response.sendRedirect(request.getContextPath() + "/admin/bookings?success=created");

        } catch (NumberFormatException e) {
            throw new ServletException("Invalid input format", e);
        } catch (SQLException e) {
            throw new ServletException("Unable to create booking", e);
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





