package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Notification;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling user notifications in the database.
 */
public class NotificationDAO {

    /**
     * Creates a new notification.
     * @param notification the Notification object
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean create(Notification notification) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getMessage());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Finds recent notifications for a user.
     * @param userId the user ID
     * @return a list of up to 20 recent Notifications
     * @throws SQLException if a database error occurs
     */
    public List<Notification> findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 20";
        List<Notification> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    /**
     * Gets the count of unread notifications for a user.
     * @param userId the user ID
     * @return the number of unread notifications
     * @throws SQLException if a database error occurs
     */
    public int getUnreadCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Marks a specific notification as read.
     * @param notificationId the notification ID
     * @param userId the user ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean markAsRead(int notificationId, int userId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Marks all notifications for a user as read.
     * @param userId the user ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Retrieves a list of user IDs for all admin users.
     * @return a list of admin user IDs
     * @throws SQLException if a database error occurs
     */
    public List<Integer> getAllAdminIds() throws SQLException {
        String sql = "SELECT userId FROM users WHERE role = 'ADMIN'";
        List<Integer> ids = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ids.add(rs.getInt(1));
            }
        }
        return ids;
    }

    private Notification map(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            n.setCreatedAt(ts.toLocalDateTime());
        }
        return n;
    }
}
