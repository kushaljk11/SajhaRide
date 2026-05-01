package com.riderental.myriderental.dao;

import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /**
     * Save a new payment record with PENDING status
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
     * Update payment status after verification
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
     * Get payment by booking ID
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
     * Get payment by transaction UUID (eSewa)
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
     * Get payment by pidx (Khalti)
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

    // LIST PAYMENTS FOR ONE RENTER (based on booking user_id)
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

    // SUM PAYMENT AMOUNT FOR A RENTER BY STATUS
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
    }
}

