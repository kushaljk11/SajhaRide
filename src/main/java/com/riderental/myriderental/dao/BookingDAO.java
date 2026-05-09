package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.util.DBConnection;
import com.riderental.myriderental.util.DaoHelper;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Booking database operations.
 */
public class BookingDAO {

    /**
     * Creates a new booking in the database.
     * @param booking the booking details
     * @return the created booking with ID
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Finds a booking by its ID.
     * @param bookingId the booking ID
     * @return the Booking object or null if not found
     * @throws SQLException if a database error occurs
     */
    public Booking findById(int bookingId) throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                WHERE b.booking_id = ?
                """;
        return DaoHelper.queryOne(sql, stmt -> stmt.setInt(1, bookingId), this::map);
    }

    /**
     * Finds all bookings for a specific renter.
     * @param userId the renter's user ID
     * @return a list of Bookings
     * @throws SQLException if a database error occurs
     */
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
        return DaoHelper.queryList(sql, stmt -> stmt.setInt(1, userId), this::map);
    }

    /**
     * Finds all bookings for an owner's vehicles.
     * @param ownerId the owner's user ID
     * @return a list of Bookings
     * @throws SQLException if a database error occurs
     */
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
        return DaoHelper.queryList(sql, stmt -> stmt.setInt(1, ownerId), this::map);
    }

    /**
     * Retrieves all bookings across the system.
     * @return a list of all Bookings
     * @throws SQLException if a database error occurs
     */
    public List<Booking> findAll() throws SQLException {
        String sql = """
                SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,
                       u.fullName AS renter_name
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                ORDER BY b.created_at DESC
                """;
        return DaoHelper.queryList(sql, this::map);
    }

    /**
     * Finds recent bookings up to a specified limit.
     * @param limit the max number of bookings to retrieve
     * @return a list of recent Bookings
     * @throws SQLException if a database error occurs
     */
    public List<Booking> findRecent(int limit) throws SQLException {
        String sql = "SELECT b.*, v.vehicle_name, v.vehicle_type, v.image_path,\n" +
                "                       u.fullName AS renter_name\n" +
                "                FROM bookings b\n" +
                "                JOIN vehicles v ON b.vehicle_id = v.vehicle_id\n" +
                "                JOIN users u ON b.user_id = u.userId\n" +
                "                ORDER BY b.created_at DESC\n" +
                "                LIMIT ?";
        return DaoHelper.queryList(sql, stmt -> stmt.setInt(1, limit), this::map);
    }

    /**
     * Updates the status of a booking.
     * @param bookingId the booking ID
     * @param status the new status
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        return DaoHelper.executeUpdate(sql, stmt -> {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
        }) > 0;
    }

    /**
     * Checks if a booking belongs to a specific owner.
     * @param bookingId the booking ID
     * @param ownerId the owner's user ID
     * @return true if the booking is for the owner's vehicle, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isOwnedBy(int bookingId, int ownerId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE b.booking_id = ? AND v.owner_id = ?
                """;
        return DaoHelper.queryCount(sql, stmt -> {
            stmt.setInt(1, bookingId);
            stmt.setInt(2, ownerId);
        }) > 0;
    }

    /**
     * Counts the total number of bookings.
     * @return the total booking count
     * @throws SQLException if a database error occurs
     */
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings";
        return DaoHelper.queryCount(sql);
    }

    /**
     * Retrieves the number of bookings made in the last 7 days.
     * @return a list of integers representing counts for the past 7 days
     * @throws SQLException if a database error occurs
     */
    public List<Integer> getLast7DaysBookings() throws SQLException {
        List<Integer> counts = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM bookings WHERE DATE(created_at) = CURDATE() - INTERVAL ? DAY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 6; i >= 0; i--) {
                stmt.setInt(1, i);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) counts.add(rs.getInt(1));
                    else counts.add(0);
                }
            }
        }
        return counts;
    }

    /**
     * Counts the total number of bookings with a specific status.
     * @param status the booking status
     * @return the total count
     * @throws SQLException if a database error occurs
     */
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = ?";
        return DaoHelper.queryCount(sql, stmt -> stmt.setString(1, status));
    }

    /**
     * Calculates the total revenue across all approved/completed bookings.
     * @return the total revenue
     * @throws SQLException if a database error occurs
     */
    public double calculateTotalRevenue() throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(total_price), 0)
                FROM bookings
                WHERE status IN ('APPROVED', 'COMPLETED')
                """;
        return DaoHelper.queryDouble(sql);
    }

    /**
     * Calculates the earnings for a specific vehicle owner.
     * @param ownerId the owner's user ID
     * @return the total earnings
     * @throws SQLException if a database error occurs
     */
    public double calculateOwnerEarnings(int ownerId) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(b.total_price), 0)
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                AND b.status IN ('APPROVED', 'COMPLETED')
                """;
        return DaoHelper.queryDouble(sql, stmt -> stmt.setInt(1, ownerId));
    }

    /**
     * Checks if a vehicle has an overlapping booking for the requested dates.
     * @param vehicleId the vehicle ID
     * @param startDate the requested start date
     * @param endDate the requested end date
     * @return true if an overlap exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean hasOverlappingBooking(int vehicleId, LocalDate startDate,
                                         LocalDate endDate) throws SQLException {
        String sql = """
                SELECT COUNT(*) FROM bookings
                WHERE vehicle_id = ?
                AND status IN ('PENDING', 'APPROVED')
                AND start_date <= ?
                AND end_date >= ?
                """;
        return DaoHelper.queryCount(sql, stmt -> {
            stmt.setInt(1, vehicleId);
            stmt.setDate(2, Date.valueOf(endDate));
            stmt.setDate(3, Date.valueOf(startDate));
        }) > 0;
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