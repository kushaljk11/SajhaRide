package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Vehicle;
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

@WebServlet("/owner/dashboard")
public class OwnerDashboardController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!ensureOwnerAccess(request, response)) {
            return;
        }

        User sessionUser = getSessionUser(request);

        try {
            int ownerId = sessionUser.getUserId();

            List<Vehicle> vehicles = vehicleDAO.findByOwner(ownerId);
            List<Booking> allBookings = bookingService.getOwnerBookings(ownerId);
            List<Booking> pendingBookings = bookingService.getOwnerPendingBookings(ownerId);
            double totalEarnings = bookingService.getOwnerEarnings(ownerId);

            String success = request.getParameter("success");
            if (success != null && !success.isBlank()) {
                request.setAttribute("successMessage", success);
            }

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("allBookings", allBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("totalVehicles", vehicles.size());
            request.setAttribute("totalBookings", allBookings.size());
            request.setAttribute("pendingCount", pendingBookings.size());

            request.getRequestDispatcher("/WEB-INF/views/owner/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load owner dashboard", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();

        if ("owner".equalsIgnoreCase(role)) {
            return true;
        }

        if ("renter".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/renter/dashboard");
            return false;
        }

        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }
}