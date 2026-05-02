package com.riderental.myriderental.dao;

import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling payment transactions.
 */
public class PaymentDAO {

    /**
     * Saves a new payment record with a PENDING status.
     *
     * @param bookingId the associated booking ID
     * @param gateway the payment gateway used (e.g., ESEWA, KHALTI)
     * @param amount the payment amount
     * @param transactionUuid the unique transaction UUID (for eSewa)
     * @param pidx the payment index (for Khalti)
     * @return the generated payment ID, or -1 if the insertion failed
     * @throws SQLException if a database access error occurs
     */
    public int savePayment(int bookingId, String gateway, double amount,
                          String transactionUuid, String pidx) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, gateway, amount, transaction_uuid, pidx, status) " +
                     "VALUES (?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, bookingId);
            stmt.setString(2, gateway);
            stmt.setDouble(3, amount);
            stmt.setString(4, transactionUuid);
            stmt.setString(5, pidx);

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return -1;
    }

    /**
     * Updates the status of an existing payment after gateway verification.
     *
     * @param gateway the payment gateway used
     * @param transactionId the transaction ID (transaction UUID or pidx)
     * @param status the new payment status (e.g., SUCCESS, FAILED)
     * @param referenceId the reference ID provided by the payment gateway
     * @throws SQLException if a database access error occurs
     */
    public void updatePaymentStatus(String gateway, String transactionId,
                                   String status, String referenceId) throws SQLException {
        String sql = "UPDATE payments SET status = ?, reference_id = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE gateway = ? AND (transaction_uuid = ? OR pidx = ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, referenceId);
            stmt.setString(3, gateway);
            stmt.setString(4, transactionId);
            stmt.setString(5, transactionId);

            stmt.executeUpdate();
        }
    }

    /**
     * Retrieves a payment record by its associated booking ID.
     *
     * @param bookingId the booking ID
     * @return the Payment record, or null if not found
     * @throws SQLException if a database access error occurs
     */
    public Payment getPaymentByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT payment_id, booking_id, gateway, amount, transaction_uuid, pidx, " +
                     "status, reference_id, created_at FROM payments WHERE booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }

        return null;
    }

    /**
     * Retrieves a payment record by its transaction UUID (typically for eSewa).
     *
     * @param uuid the transaction UUID
     * @return the Payment record, or null if not found
     * @throws SQLException if a database access error occurs
     */
    public Payment getPaymentByTransactionUuid(String uuid) throws SQLException {
        String sql = "SELECT payment_id, booking_id, gateway, amount, transaction_uuid, pidx, " +
                     "status, reference_id, created_at FROM payments WHERE transaction_uuid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, uuid);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }

        return null;
    }

    /**
     * Retrieves a payment record by its payment index (typically for Khalti).
     *
     * @param pidx the payment index
     * @return the Payment record, or null if not found
     * @throws SQLException if a database access error occurs
     */
    public Payment getPaymentByPidx(String pidx) throws SQLException {
        String sql = "SELECT payment_id, booking_id, gateway, amount, transaction_uuid, pidx, " +
                     "status, reference_id, created_at FROM payments WHERE pidx = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, pidx);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }

        return null;
    }

    /**
     * Retrieves a list of payments made by a specific renter.
     *
     * @param renterId the ID of the renter
     * @return a list of Payment records associated with the renter
     * @throws SQLException if a database access error occurs
     */
    public List<Payment> findByRenterId(int renterId) throws SQLException {
        String sql = """
                SELECT p.payment_id, p.booking_id, p.gateway, p.amount, p.transaction_uuid, p.pidx,
                       p.status, p.reference_id, p.created_at
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                WHERE b.user_id = ?
                ORDER BY p.created_at DESC
                """;

        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, renterId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        }

        return payments;
    }

    /**
     * Retrieves a list of payments received by a specific vehicle owner.
     *
     * @param ownerId the ID of the vehicle owner
     * @return a list of Payment records associated with the owner's vehicles
     * @throws SQLException if a database access error occurs
     */
    public List<Payment> findByOwnerId(int ownerId) throws SQLException {
        String sql = """
                SELECT p.payment_id, p.booking_id, p.gateway, p.amount, p.transaction_uuid, p.pidx,
                       p.status, p.reference_id, p.created_at,
                       b.status AS booking_status,
                       u.fullName AS renter_name,
                       v.vehicle_name AS vehicle_name
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                JOIN users u ON b.user_id = u.userId
                WHERE v.owner_id = ?
                ORDER BY p.created_at DESC
                """;

        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        }

        return payments;
    }

    /**
     * Calculates the total amount of payments for a specific renter with a given status.
     *
     * @param renterId the ID of the renter
     * @param status the payment status to filter by (e.g., "SUCCESS")
     * @return the sum of the payment amounts
     * @throws SQLException if a database access error occurs
     */
    public double sumAmountByRenterAndStatus(int renterId, String status) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(p.amount), 0)
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                WHERE b.user_id = ? AND p.status = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, renterId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }

    /**
     * Calculates the total amount of payments for a specific owner with a given status.
     *
     * @param ownerId the ID of the owner
     * @param status the payment status to filter by
     * @return the sum of the payment amounts
     * @throws SQLException if a database access error occurs
     */
    public double sumAmountByOwnerAndStatus(int ownerId, String status) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(p.amount), 0)
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ? AND p.status = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }

    /**
     * Calculates the total amount of payments received by an owner today with a given status.
     *
     * @param ownerId the ID of the owner
     * @param status the payment status to filter by
     * @return the sum of today's payment amounts
     * @throws SQLException if a database access error occurs
     */
    public double sumAmountByOwnerAndToday(int ownerId, String status) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(p.amount), 0)
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                  AND p.status = ?
                  AND DATE(p.created_at) = CURRENT_DATE()
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }

    /**
     * Calculates the total amount of payments received by an owner in the current week with a given status.
     *
     * @param ownerId the ID of the owner
     * @param status the payment status to filter by
     * @return the sum of the current week's payment amounts
     * @throws SQLException if a database access error occurs
     */
    public double sumAmountByOwnerAndCurrentWeek(int ownerId, String status) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(p.amount), 0)
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                  AND p.status = ?
                  AND YEARWEEK(p.created_at, 1) = YEARWEEK(CURDATE(), 1)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }

        return 0;
    }

    /**
     * Calculates the total pending payout amount for a specific owner.
     *
     * @param ownerId the ID of the owner
     * @return the total sum of pending payouts
     * @throws SQLException if a database access error occurs
     */
    public double sumPendingOwnerPayout(int ownerId) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(p.amount), 0)
                FROM payments p
                JOIN bookings b ON p.booking_id = b.booking_id
                JOIN vehicles v ON b.vehicle_id = v.vehicle_id
                WHERE v.owner_id = ?
                  AND p.status = 'PENDING'
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

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setBookingId(rs.getInt("booking_id"));
        payment.setGateway(rs.getString("gateway"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setTransactionUuid(rs.getString("transaction_uuid"));
        payment.setPidx(rs.getString("pidx"));
        payment.setStatus(rs.getString("status"));
        payment.setReferenceId(rs.getString("reference_id"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        try { payment.setBookingStatus(rs.getString("booking_status")); } catch (SQLException ignored) {}
        try { payment.setRenterName(rs.getString("renter_name")); } catch (SQLException ignored) {}
        try { payment.setVehicleName(rs.getString("vehicle_name")); } catch (SQLException ignored) {}
        return payment;
    }

    /**
     * Simple Payment model class
     */
    public static class Payment {
        private int paymentId;
        private int bookingId;
        private String gateway;
        private double amount;
        private String transactionUuid;
        private String pidx;
        private String status;
        private String referenceId;
        private Timestamp createdAt;
        private String bookingStatus;
        private String renterName;
        private String vehicleName;

        // Getters and Setters
        public int getPaymentId() { return paymentId; }
        public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }

        public String getGateway() { return gateway; }
        public void setGateway(String gateway) { this.gateway = gateway; }

        public double getAmount() { return amount; }
        public void setAmount(double amount) { this.amount = amount; }

        public String getTransactionUuid() { return transactionUuid; }
        public void setTransactionUuid(String transactionUuid) { this.transactionUuid = transactionUuid; }

        public String getPidx() { return pidx; }
        public void setPidx(String pidx) { this.pidx = pidx; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getReferenceId() { return referenceId; }
        public void setReferenceId(String referenceId) { this.referenceId = referenceId; }

        public Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

        public String getBookingStatus() { return bookingStatus; }
        public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

        public String getRenterName() { return renterName; }
        public void setRenterName(String renterName) { this.renterName = renterName; }

        public String getVehicleName() { return vehicleName; }
        public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }
    }
}

