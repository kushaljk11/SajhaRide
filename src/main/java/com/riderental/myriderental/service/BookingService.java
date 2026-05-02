package com.riderental.myriderental.service;

import com.riderental.myriderental.dao.BookingDAO;
import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.model.Vehicle;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.riderental.myriderental.dao.PaymentDAO;

/**
 * Service class for handling booking business logic.
 */
public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final AvailabilityService availabilityService = new AvailabilityService();

    /**
     * Creates a new booking request.
     * @param vehicleId the vehicle ID
     * @param userId the renter's user ID
     * @param startDate the requested start date
     * @param endDate the requested end date
     * @return the created Booking object
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Approves a booking.
     * @param bookingId the booking ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean approveBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "APPROVED");
    }

    /**
     * Rejects a booking.
     * @param bookingId the booking ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean rejectBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "REJECTED");
    }

    /**
     * Completes a booking.
     * @param bookingId the booking ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean completeBooking(int bookingId) throws SQLException {
        return bookingDAO.updateStatus(bookingId, "COMPLETED");
    }

    /**
     * Retrieves all bookings for a renter.
     * @param userId the renter's user ID
     * @return a list of Bookings
     * @throws SQLException if a database error occurs
     */
    public List<Booking> getRenterBookings(int userId) throws SQLException {
        return bookingDAO.findByRenter(userId);
    }

    /**
     * Retrieves all bookings for an owner's vehicles.
     * @param ownerId the owner's user ID
     * @return a list of Bookings
     * @throws SQLException if a database error occurs
     */
    public List<Booking> getOwnerBookings(int ownerId) throws SQLException {
        return bookingDAO.findByOwner(ownerId);
    }

    /**
     * Retrieves all bookings (for Admin).
     * @return a list of all Bookings
     * @throws SQLException if a database error occurs
     */
    public List<Booking> getAllBookings() throws SQLException {
        return bookingDAO.findAll();
    }

    /**
     * Retrieves pending bookings for an owner.
     * @param ownerId the owner's user ID
     * @return a list of pending Bookings
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Gets the total earnings for an owner.
     * @param ownerId the owner's user ID
     * @return the total earnings
     * @throws SQLException if a database error occurs
     */
    public double getOwnerEarnings(int ownerId) throws SQLException {
        return bookingDAO.calculateOwnerEarnings(ownerId);
    }

    /**
     * Gets the platform total revenue (Admin).
     * @return the total revenue
     * @throws SQLException if a database error occurs
     */
    public double getTotalRevenue() throws SQLException {
        return bookingDAO.calculateTotalRevenue();
    }

    /**
     * Gets the total number of bookings for Admin dashboard.
     * @return the total booking count
     * @throws SQLException if a database error occurs
     */
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