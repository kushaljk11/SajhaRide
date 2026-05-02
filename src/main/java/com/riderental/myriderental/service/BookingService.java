package com.riderental.myriderental.service;

import com.riderental.myriderental.dao.BookingDAO;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.Vehicle;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.riderental.myriderental.dao.PaymentDAO;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final AvailabilityService availabilityService = new AvailabilityService();

    // CREATE A NEW BOOKING REQUEST
    public Booking requestBooking(int vehicleId, int userId,
                                  LocalDate startDate, LocalDate endDate) throws SQLException {

        // Check availability before creating
        if (!availabilityService.isAvailable(vehicleId, startDate, endDate)) {
            throw new IllegalStateException("Vehicle is not available for the selected dates.");
        }

        Vehicle vehicle = vehicleDAO.findById(vehicleId);
        if (vehicle == null) {
            throw new IllegalStateException("Vehicle not found.");
        }

        // Calculate total price
        double totalPrice = availabilityService.calculateTotalPrice(startDate, endDate,
                vehicle.getPricePerDay());

        Booking booking = new Booking();
        booking.setVehicleId(vehicleId);
        booking.setUserId(userId);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setTotalPrice(totalPrice);
        booking.setStatus("PENDING");

        Booking savedBooking = bookingDAO.create(booking);

        // Automatically create a PENDING payment record for the renter
        // Using 'ESEWA' as the default placeholder to satisfy DB ENUM('ESEWA', 'KHALTI')
        paymentDAO.savePayment(savedBooking.getBookingId(), "ESEWA", totalPrice, null, null);

        return savedBooking;
    }

    // APPROVE A BOOKING
    public boolean approveBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "APPROVED");
    }

    // REJECT A BOOKING
    public boolean rejectBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "REJECTED");
    }

    // COMPLETE A BOOKING
    public boolean completeBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "COMPLETED");
    }

    // GET ALL BOOKINGS FOR A RENTER
    public List<Booking> getRenterBookings(int userId) throws SQLException {
        return bookingDAO.findByRenter(userId);
    }

    // GET ALL BOOKINGS FOR AN OWNER
    public List<Booking> getOwnerBookings(int ownerId) throws SQLException {
        return bookingDAO.findByOwner(ownerId);
    }

    // GET ALL BOOKINGS (ADMIN)
    public List<Booking> getAllBookings() throws SQLException {
        return bookingDAO.findAll();
    }

    // GET PENDING BOOKINGS FOR AN OWNER
    public List<Booking> getOwnerPendingBookings(int ownerId) throws SQLException {
        List<Booking> all = bookingDAO.findByOwner(ownerId);
        List<Booking> pending = new java.util.ArrayList<>();
        for (Booking b : all) {
            if ("PENDING".equals(b.getStatus())) {
                pending.add(b);
            }
        }
        return pending;
    }

    // GET TOTAL EARNINGS FOR AN OWNER
    public double getOwnerEarnings(int ownerId) throws SQLException {
        return bookingDAO.calculateOwnerEarnings(ownerId);
    }

    // GET PLATFORM TOTAL REVENUE (ADMIN)
    public double getTotalRevenue() throws SQLException {
        return bookingDAO.calculateTotalRevenue();
    }

    // GET BOOKING COUNTS FOR ADMIN DASHBOARD
    public int getTotalBookingCount() throws SQLException {
        return bookingDAO.countAll();
    }

    public int getPendingBookingCount() throws SQLException {
        return bookingDAO.countByStatus("PENDING");
    }

    public int getApprovedBookingCount() throws SQLException {
        return bookingDAO.countByStatus("APPROVED");
    }

    public int getRejectedBookingCount() throws SQLException {
        return bookingDAO.countByStatus("REJECTED");
    }
}