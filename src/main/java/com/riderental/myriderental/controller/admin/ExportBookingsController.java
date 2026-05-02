package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/bookings/export-csv")
public class ExportBookingsController extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Fetch all bookings
            List<Booking> bookings = bookingService.getAllBookings();

            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"bookings_" + System.currentTimeMillis() + ".csv\"");

            PrintWriter writer = response.getWriter();

            // Write CSV header
            writer.println("Booking ID,User ID,Vehicle ID,Renter Name,Vehicle Name,Start Date,End Date,Duration (Days),Total Price,Status,Created At");

            // Write booking data
            if (bookings != null) {
                for (Booking b : bookings) {
                    long days = 0;
                    if (b.getStartDate() != null && b.getEndDate() != null) {
                        days = java.time.temporal.ChronoUnit.DAYS.between(b.getStartDate(), b.getEndDate());
                    }
                    writer.println(escapeCSV(b.getBookingId()) + "," +
                            escapeCSV(b.getUserId()) + "," +
                            escapeCSV(b.getVehicleId()) + "," +
                            escapeCSV(b.getRenterName()) + "," +
                            escapeCSV(b.getVehicleName()) + "," +
                            escapeCSV(b.getStartDate()) + "," +
                            escapeCSV(b.getEndDate()) + "," +
                            escapeCSV(days) + "," +
                            escapeCSV(b.getTotalPrice()) + "," +
                            escapeCSV(b.getStatus()) + "," +
                            escapeCSV(b.getCreatedAt() != null ? b.getCreatedAt().toString() : ""));
                }
            }

            writer.flush();
            writer.close();

        } catch (SQLException e) {
            throw new ServletException("Unable to export bookings", e);
        }
    }

    private String escapeCSV(Object value) {
        if (value == null) return "";
        String str = value.toString();
        if (str.contains(",") || str.contains("\"") || str.contains("\n")) {
            return "\"" + str.replace("\"", "\"\"") + "\"";
        }
        return str;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User loggedIn = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return false;
        String role = loggedIn.getRole() == null ? "" : loggedIn.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role);
    }
}

