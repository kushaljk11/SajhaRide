package com.riderental.myriderental.service;

import com.riderental.myriderental.dao.BookingDAO;

import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Service class for handling vehicle availability logic.
 */
public class AvailabilityService {

    private final BookingDAO bookingDAO = new BookingDAO();

    /**
     * Checks if a vehicle is available for the given date range.
     * @param vehicleId the vehicle ID
     * @param startDate the requested start date
     * @param endDate the requested end date
     * @return true if available, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isAvailable(int vehicleId, LocalDate startDate, LocalDate endDate) throws SQLException {

        // Start date must be before end date
        if (startDate == null || endDate == null) {
            return false;
        }

        if (!startDate.isBefore(endDate) && !startDate.isEqual(endDate)) {
            return false;
        }

        // Start date cannot be in the past
        if (startDate.isBefore(LocalDate.now())) {
            return false;
        }

        // Check database for any overlapping bookings
        return !bookingDAO.hasOverlappingBooking(vehicleId, startDate, endDate);
    }

    /**
     * Validates date inputs from a form.
     * @param startDateStr the start date as string
     * @param endDateStr the end date as string
     * @return an error message if invalid, or null if valid
     */
    public String validate(String startDateStr, String endDateStr) {

        if (startDateStr == null || startDateStr.isBlank()) {
            return "Start date is required.";
        }

        if (endDateStr == null || endDateStr.isBlank()) {
            return "End date is required.";
        }

        LocalDate startDate;
        LocalDate endDate;

        try {
            startDate = LocalDate.parse(startDateStr.trim());
        } catch (Exception e) {
            return "Start date is not valid.";
        }

        try {
            endDate = LocalDate.parse(endDateStr.trim());
        } catch (Exception e) {
            return "End date is not valid.";
        }

        if (startDate.isBefore(LocalDate.now())) {
            return "Start date cannot be in the past.";
        }

        if (endDate.isBefore(startDate)) {
            return "End date cannot be before start date.";
        }

        if (startDate.isEqual(endDate)) {
            return "End date must be after start date.";
        }

        return null; // null means no error
    }

    /**
     * Calculates the total price based on rental days and price per day.
     * @param startDate the start date
     * @param endDate the end date
     * @param pricePerDay the vehicle's price per day
     * @return the total calculated price
     */
    public double calculateTotalPrice(LocalDate startDate, LocalDate endDate, double pricePerDay) {
        long days = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);
        return days * pricePerDay;
    }
}