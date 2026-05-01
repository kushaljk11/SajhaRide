package com.riderental.myriderental.controller.renter;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/renter/dashboard")
public class RenterDashboardController extends HttpServlet {

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

        // Only renters allowed
        if (!"RENTER".equalsIgnoreCase(sessionUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int renterId = sessionUser.getUserId();
            List<Vehicle> vehicles = vehicleDAO.findByOwner(renterId);
            List<Booking> allBookings = bookingService.getOwnerBookings(renterId);

            List<Booking> pendingBookings = new ArrayList<>();
            List<Booking> activeBookings = new ArrayList<>();
            List<Booking> completedBookings = new ArrayList<>();

            for (Booking b : allBookings) {
                switch (b.getStatus()) {
                    case "PENDING" -> pendingBookings.add(b);
                    case "APPROVED" -> activeBookings.add(b);
                    case "COMPLETED" -> completedBookings.add(b);
                }
            }

            double totalEarnings = bookingService.getOwnerEarnings(renterId);

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("allBookings", allBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("activeBookings", activeBookings);
            request.setAttribute("completedBookings", completedBookings);

            request.setAttribute("totalVehicles", vehicles.size());
            request.setAttribute("totalBookings", allBookings.size());
            request.setAttribute("pendingCount", pendingBookings.size());
            request.setAttribute("activeCount", activeBookings.size());
            request.setAttribute("completedCount", completedBookings.size());
            request.setAttribute("totalEarnings", totalEarnings);

            request.getRequestDispatcher("/WEB-INF/views/renter/dashboard.jsp")
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