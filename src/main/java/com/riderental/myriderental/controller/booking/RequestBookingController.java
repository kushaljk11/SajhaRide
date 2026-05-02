package com.riderental.myriderental.controller.booking;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Vehicle;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.service.AvailabilityService;
import com.riderental.myriderental.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Controller for handling the initiation and submission of new booking requests.
 */
@WebServlet("/booking/request")
public class RequestBookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final AvailabilityService availabilityService = new AvailabilityService();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to display the booking form for a specific vehicle.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String vehicleIdParam = request.getParameter("vehicleId");
        if (vehicleIdParam == null || vehicleIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/vehicles");
            return;
        }

        try {
            int vehicleId = Integer.parseInt(vehicleIdParam);
            Vehicle vehicle = vehicleDAO.findById(vehicleId);

            if (vehicle == null) {
                request.setAttribute("errorMessage", "Vehicle not found.");
                request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-list.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicles");
        } catch (SQLException e) {
            throw new ServletException("Unable to load vehicle", e);
        }
    }

    /**
     * Processes POST requests containing the booking form submission data.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            com.riderental.myriderental.dao.KycDAO kycDAO = new com.riderental.myriderental.dao.KycDAO();
            com.riderental.myriderental.model.KycVerification kyc = kycDAO.findByUserId(sessionUser.getUserId());
            
            if (kyc == null || !"APPROVED".equals(kyc.getStatus())) {
                request.getSession().setAttribute("profileError", "You must upload and verify your driving license in your profile before you can book a vehicle.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Error verifying KYC status", e);
        }

        String vehicleIdParam = request.getParameter("vehicleId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Validate date inputs
        String dateError = availabilityService.validate(startDateStr, endDateStr);
        if (dateError != null) {
            request.setAttribute("errorMessage", dateError);
            doGet(request, response);
            return;
        }

        try {
            int vehicleId = Integer.parseInt(vehicleIdParam);
            LocalDate startDate = LocalDate.parse(startDateStr.trim());
            LocalDate endDate = LocalDate.parse(endDateStr.trim());

            // Check availability
            if (!availabilityService.isAvailable(vehicleId, startDate, endDate)) {
                request.setAttribute("errorMessage",
                        "This vehicle is already booked for the selected dates. Please choose different dates.");
                request.setAttribute("vehicleId", vehicleId);
                doGet(request, response);
                return;
            }

            // Create booking
            bookingService.requestBooking(vehicleId, sessionUser.getUserId(), startDate, endDate);

            // Redirect to booking history with success message
            response.sendRedirect(request.getContextPath()
                    + "/booking/history?success=Booking+request+submitted+successfully");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid vehicle ID.");
            doGet(request, response);
        } catch (IllegalStateException e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to create booking", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}