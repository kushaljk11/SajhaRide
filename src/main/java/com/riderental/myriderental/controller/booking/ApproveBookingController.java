package com.riderental.myriderental.controller.booking;

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

@WebServlet("/booking/approve")
public class ApproveBookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = sessionUser.getRole() == null ? "" : sessionUser.getRole().trim();
        if (!"OWNER".equalsIgnoreCase(role) && !"RENTER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            if (!bookingDAO.isOwnedBy(bookingId, sessionUser.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                return;
            }
            bookingService.approveBooking(bookingId);

            response.sendRedirect(request.getContextPath()
                    + "/owner/dashboard?success=Booking+approved+successfully");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        } catch (SQLException e) {
            throw new ServletException("Unable to approve booking", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}