package com.riderental.myriderental.service;

import com.riderental.myriderental.dao.BookingDAO;

import java.sql.SQLException;
import java.time.LocalDate;

public class AvailabilityService {

    private final BookingDAO bookingDAO = new BookingDAO();

    // CHECK IF A VEHICLE IS AVAILABLE FOR THE GIVEN DATE RANGE
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

    // VALIDATE DATE INPUTS FROM FORM
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

    // CALCULATE TOTAL PRICE BASED ON DAYS AND PRICE PER DAY
    public double calculateTotalPrice(LocalDate startDate, LocalDate endDate, double pricePerDay) {
        long days = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);
        return days * pricePerDay;
    }
}