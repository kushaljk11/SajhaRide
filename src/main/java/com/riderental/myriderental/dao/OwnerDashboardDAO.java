package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Booking;
import com.riderental.myriderental.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for aggregating dashboard statistics for vehicle owners.
 */
public class OwnerDashboardDAO {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Counts the total number of vehicles owned by a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the total number of vehicles
     * @throws SQLException if a database access error occurs
     */
    public int countTotalVehicles(int ownerId) throws SQLException {
        return vehicleDAO.findByOwner(ownerId).size();
    }

    /**
     * Counts the number of vehicles currently available for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of available vehicles
     * @throws SQLException if a database access error occurs
     */
    public int countAvailableVehicles(int ownerId) throws SQLException {
        return countVehiclesByStatus(ownerId, "AVAILABLE");
    }

    /**
     * Counts the number of vehicles currently booked (rented) for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of booked vehicles
     * @throws SQLException if a database access error occurs
     */
    public int countBookedVehicles(int ownerId) throws SQLException {
        return countVehiclesByStatus(ownerId, "RENTED");
    }

    /**
     * Counts the number of vehicles currently under maintenance for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of vehicles under maintenance
     * @throws SQLException if a database access error occurs
     */
    public int countMaintenanceVehicles(int ownerId) throws SQLException {
        return countVehiclesByStatus(ownerId, "MAINTENANCE");
    }

    /**
     * Counts the number of pending booking requests for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of pending bookings
     * @throws SQLException if a database access error occurs
     */
    public int countPendingBookings(int ownerId) throws SQLException {
        return countBookingsByStatuses(ownerId, "PENDING");
    }

    /**
     * Counts the number of approved booking requests for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of approved bookings
     * @throws SQLException if a database access error occurs
     */
    public int countApprovedBookings(int ownerId) throws SQLException {
        return countBookingsByStatuses(ownerId, "APPROVED");
    }

    /**
     * Counts the number of rejected or cancelled booking requests for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the number of rejected or cancelled bookings
     * @throws SQLException if a database access error occurs
     */
    public int countRejectedOrCancelledBookings(int ownerId) throws SQLException {
        return countBookingsByStatuses(ownerId, "REJECTED", "CANCELLED");
    }

    /**
     * Counts the total number of bookings across all statuses for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the total number of bookings
     * @throws SQLException if a database access error occurs
     */
    public int countTotalBookings(int ownerId) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Calculates the total earnings for a specific owner based on approved and completed bookings.
     *
     * @param ownerId the ID of the owner
     * @return the total earnings amount
     * @throws SQLException if a database access error occurs
     */
    public double calculateTotalEarnings(int ownerId) throws SQLException {
        return bookingDAO.calculateOwnerEarnings(ownerId);
    }

    /**
     * Retrieves a list of recent bookings for a specific owner, up to a specified limit.
     *
     * @param ownerId the ID of the owner
     * @param limit the maximum number of recent bookings to retrieve
     * @return a list of recent bookings
     * @throws SQLException if a database access error occurs
     */
    public List<Booking> findRecentBookings(int ownerId, int limit) throws SQLException {
        List<Booking> bookings = bookingDAO.findByOwner(ownerId);
        if (bookings == null || bookings.isEmpty()) {
            return new ArrayList<>();
        }
        return bookings.size() <= limit ? bookings : new ArrayList<>(bookings.subList(0, limit));
    }

    /**
     * Aggregates booking statistics by status for charting purposes.
     *
     * @param ownerId the ID of the owner
     * @return a list of chart points representing booking status counts
     * @throws SQLException if a database access error occurs
     */
    public List<ChartPoint> findBookingStatusSeries(int ownerId) throws SQLException {
        Map<String, Integer> counts = new LinkedHashMap<>();
        for (String status : Arrays.asList("PENDING", "APPROVED", "COMPLETED", "CANCELLED", "REJECTED")) {
            counts.put(status, 0);
        }

        String sql = """
                SELECT b.status, COUNT(*) AS total
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                GROUP BY b.status
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int total = rs.getInt("total");
                    if (status != null) {
                        counts.put(status.toUpperCase(), total);
                    }
                }
            }
        }

        List<ChartPoint> points = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            points.add(new ChartPoint(labelize(entry.getKey()), entry.getValue()));
        }
        return points;
    }

    /**
     * Aggregates vehicle availability statistics for charting purposes.
     *
     * @param ownerId the ID of the owner
     * @return a list of chart points representing vehicle availability counts
     * @throws SQLException if a database access error occurs
     */
    public List<ChartPoint> findVehicleAvailabilitySeries(int ownerId) throws SQLException {
        Map<String, Integer> counts = new LinkedHashMap<>();
        for (String status : Arrays.asList("AVAILABLE", "RENTED", "MAINTENANCE")) {
            counts.put(status, 0);
        }

        String sql = """
                SELECT availability_status, COUNT(*) AS total
                FROM vehicles
                WHERE owner_id = ?
                GROUP BY availability_status
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("availability_status");
                    int total = rs.getInt("total");
                    if (status != null) {
                        counts.put(status.toUpperCase(), total);
                    }
                }
            }
        }

        List<ChartPoint> points = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            points.add(new ChartPoint(labelize(entry.getKey()), entry.getValue()));
        }
        return points;
    }

    /**
     * Aggregates monthly earnings statistics for a specific year for charting purposes.
     *
     * @param ownerId the ID of the owner
     * @param year the year to aggregate data for
     * @return a list of chart points representing monthly earnings
     * @throws SQLException if a database access error occurs
     */
    public List<ChartPoint> findMonthlyEarningsSeries(int ownerId, int year) throws SQLException {
        double[] months = new double[12];

        String sql = """
                SELECT MONTH(b.created_at) AS month_num, COALESCE(SUM(b.total_price), 0) AS total
                FROM bookings b
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                  AND YEAR(b.created_at) = ?
                  AND b.status IN ('APPROVED', 'COMPLETED')
                GROUP BY MONTH(b.created_at)
                ORDER BY MONTH(b.created_at)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            stmt.setInt(2, year);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int monthNum = rs.getInt("month_num");
                    double total = rs.getDouble("total");
                    if (monthNum >= 1 && monthNum <= 12) {
                        months[monthNum - 1] = total;
                    }
                }
            }
        }

        List<ChartPoint> points = new ArrayList<>();
        String[] labels = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        for (int i = 0; i < labels.length; i++) {
            points.add(new ChartPoint(labels[i], months[i]));
        }
        return points;
    }

    /**
     * Aggregates vehicle counts by type for charting purposes.
     *
     * @param ownerId the ID of the owner
     * @return a list of chart points representing vehicle type counts
     * @throws SQLException if a database access error occurs
     */
    public List<ChartPoint> findVehicleTypeSeries(int ownerId) throws SQLException {
        String sql = """
                SELECT vehicle_type, COUNT(*) AS total
                FROM vehicles
                WHERE owner_id = ?
                GROUP BY vehicle_type
                ORDER BY vehicle_type
                """;

        List<ChartPoint> points = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String label = rs.getString("vehicle_type");
                    points.add(new ChartPoint(label == null ? "Unknown" : label, rs.getInt("total")));
                }
            }
        }
        return points;
    }

    private int countVehiclesByStatus(int ownerId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles WHERE owner_id = ? AND availability_status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            stmt.setString(2, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private int countBookingsByStatuses(int ownerId, String... statuses) throws SQLException {
        if (statuses == null || statuses.length == 0) {
            return 0;
        }

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings b JOIN vehicles v ON b.vehicle_id = v.vehicle_id WHERE v.owner_id = ? AND b.status IN (");
        for (int i = 0; i < statuses.length; i++) {
            if (i > 0) {
                sql.append(",");
            }
            sql.append("?");
        }
        sql.append(")");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            stmt.setInt(1, ownerId);
            for (int i = 0; i < statuses.length; i++) {
                stmt.setString(i + 2, statuses[i]);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private String labelize(String raw) {
        if (raw == null || raw.isBlank()) {
            return "Unknown";
        }
        String lower = raw.trim().toLowerCase();
        return Character.toUpperCase(lower.charAt(0)) + lower.substring(1);
    }

    public static class ChartPoint {
        private final String label;
        private final double value;

        public ChartPoint(String label, double value) {
            this.label = label;
            this.value = value;
        }

        public String getLabel() {
            return label;
        }

        public double getValue() {
            return value;
        }
    }
}


