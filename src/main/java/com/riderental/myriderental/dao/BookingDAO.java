package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // CREATE BOOKING
    public Booking create(Booking booking) throws SQLException {
        String sql = """
                INSERT INTO bookings
                (vehicle_id, user_id, start_date, end_date, total_price, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, booking.getVehicleId());
            stmt.setInt(2, booking.getUserId());
            stmt.setDate(3, Date.valueOf(booking.getStartDate()));
            stmt.setDate(4, Date.valueOf(booking.getEndDate()));
            stmt.setDouble(5, booking.getTotalPrice());
            stmt.setString(6, "PENDING");

            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    booking.setBookingId(keys.getInt(1));
                }
            }

            return findById(booking.getBookingId());
        }
    }

    // FIND BY ID
    public Booking findById(int bookingId) throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                WHERE b.booking_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    // FIND ALL BOOKINGS BY RENTER (user_id)
    public List<Booking> findByRenter(int userId) throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                WHERE b.user_id = ?
                ORDER BY b.created_at DESC
                """;

        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(map(rs));
                }
            }
        }
        return bookings;
    }

    // FIND ALL BOOKINGS FOR OWNER'S VEHICLES
    public List<Booking> findByOwner(int ownerId) throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                WHERE v.owner_id = ?
                ORDER BY b.created_at DESC
                """;

        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(map(rs));
                }
            }
        }
        return bookings;
    }

    // FIND ALL BOOKINGS (ADMIN)
    public List<Booking> findAll() throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                ORDER BY b.created_at DESC
                """;

        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                bookings.add(map(rs));
            }
        }
        return bookings;
    }

    // UPDATE BOOKING STATUS
    public boolean updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, bookingId);

            return stmt.executeUpdate() > 0;
        }
    }

    // CHECK IF BOOKING BELONGS TO AN OWNER'S VEHICLE
    public boolean isOwnedBy(int bookingId, int ownerId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE b.booking_id = ? AND v.owner_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);
            stmt.setInt(2, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    // COUNT ALL BOOKINGS
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // COUNT BOOKINGS BY STATUS
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // CALCULATE TOTAL REVENUE (sum of approved + completed bookings)
    public double calculateTotalRevenue() throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(total_price), 0)
                FROM bookings
                WHERE status IN ('APPROVED', 'COMPLETED')
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }

    // CALCULATE EARNINGS FOR ONE OWNER
    public double calculateOwnerEarnings(int ownerId) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(b.total_price), 0)
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                AND b.status IN ('APPROVED', 'COMPLETED')
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }
        return 0;
    }

    // CHECK IF DATES OVERLAP FOR A VEHICLE (used by AvailabilityService)
    public boolean hasOverlappingBooking(int vehicleId, LocalDate startDate,
                                         LocalDate endDate) throws SQLException {
        String sql = """
                SELECT COUNT(*) FROM bookings
                WHERE vehicle_id = ?
                AND status IN ('PENDING', 'APPROVED')
                AND start_date <= ?
                AND end_date >= ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vehicleId);
            stmt.setDate(2, Date.valueOf(endDate));
            stmt.setDate(3, Date.valueOf(startDate));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // MAP RESULT SET TO BOOKING OBJECT
    private Booking map(ResultSet rs) throws SQLException {
        Booking booking = new Booking();

        booking.setBookingId(rs.getInt("booking_id"));
        booking.setVehicleId(rs.getInt("vehicle_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setStartDate(rs.getDate("start_date").toLocalDate());
        booking.setEndDate(rs.getDate("end_date").toLocalDate());
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setStatus(rs.getString("status"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            booking.setCreatedAt(ts.toLocalDateTime());
        } else {
            booking.setCreatedAt(LocalDateTime.now());
        }

        // Extra fields from JOIN
        try { booking.setVehicleName(rs.getString("vehicle_name")); } catch (SQLException ignored) {}
        try { booking.setVehicleType(rs.getString("vehicle_type")); } catch (SQLException ignored) {}
        try { booking.setImagePath(rs.getString("image_path")); } catch (SQLException ignored) {}
        try { booking.setRenterName(rs.getString("renter_name")); } catch (SQLException ignored) {}

        return booking;
    }
}