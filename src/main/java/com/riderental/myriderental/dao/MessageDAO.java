package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Message;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public Message saveMessage(Message msg) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, msg.getSenderId());
            stmt.setInt(2, msg.getReceiverId());
            stmt.setString(3, msg.getContent());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    msg.setMessageId(rs.getInt(1));
                }
            }
        }
        return msg;
    }

    public List<Message> getConversation(int user1Id, int user2Id) throws SQLException {
        String sql = "SELECT m.*, u1.fullName as sender_name, u2.fullName as receiver_name " +
                     "FROM messages m " +
                     "JOIN users u1 ON m.sender_id = u1.userId " +
                     "JOIN users u2 ON m.receiver_id = u2.userId " +
                     "WHERE (m.sender_id = ? AND m.receiver_id = ?) " +
                     "   OR (m.sender_id = ? AND m.receiver_id = ?) " +
                     "ORDER BY m.created_at ASC";
        
        List<Message> messages = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, user1Id);
            stmt.setInt(2, user2Id);
            stmt.setInt(3, user2Id);
            stmt.setInt(4, user1Id);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setMessageId(rs.getInt("message_id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setReceiverId(rs.getInt("receiver_id"));
                    m.setContent(rs.getString("content"));
                    m.setRead(rs.getBoolean("is_read"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setSenderName(rs.getString("sender_name"));
                    m.setReceiverName(rs.getString("receiver_name"));
                    messages.add(m);
                }
            }
        }
        return messages;
    }

    public List<Integer> getContactedUserIds(int userId) throws SQLException {
        String sql = "SELECT DISTINCT sender_id AS contact_id FROM messages WHERE receiver_id = ? " +
                     "UNION " +
                     "SELECT DISTINCT receiver_id AS contact_id FROM messages WHERE sender_id = ?";
        List<Integer> contactIds = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contactIds.add(rs.getInt("contact_id"));
                }
            }
        }
        return contactIds;
    }
}
