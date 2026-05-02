package com.riderental.myriderental.controller.renter;

import com.riderental.myriderental.dao.BookingDAO;
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

/**
 * Controller for handling booking approvals by a renter (for renter's own vehicles).
 */
@WebServlet("/renter/booking/approve")
public class RenterApproveBookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final BookingDAO bookingDAO = new BookingDAO();

    /**
     * Handles POST requests to approve a booking.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/renter/booking?error=Missing+booking+id");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);

            if (!bookingDAO.isOwnedBy(bookingId, sessionUser.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/renter/booking?error=Unauthorized+booking+action");
                return;
            }

            bookingService.approveBooking(bookingId);
            response.sendRedirect(request.getContextPath() + "/renter/booking?success=Booking+approved+successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/renter/booking?error=Invalid+booking+id");
        } catch (SQLException e) {
            throw new ServletException("Unable to approve booking", e);
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

