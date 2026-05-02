package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // CREATE USER
    public User create(User user) throws SQLException {
        String sql = """
                INSERT INTO users
                (fullName, email, password, phoneNumber, address, profileImagePath, role, trustScore, accountStatus, is_verified)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getProfileImagePath());
            stmt.setString(7, user.getRole());
            stmt.setDouble(8, user.getTrustScore());
            stmt.setString(9, user.getAccountStatus());
            stmt.setBoolean(10, user.isVerified());

            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    user.setUserId(keys.getInt(1));
                }
            }

            return findById(user.getUserId());
        }
    }

    // FIND BY EMAIL
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    // FIND BY ID
    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    // FIND ALL USERS
    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM users ORDER BY createdAt DESC";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                users.add(map(rs));
            }
        }

        return users;
    }

    // COUNT ALL USERS
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // COUNT USERS BY STATUS
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE accountStatus = ?";

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

    // COUNT USERS BY ROLE
    public int countByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // UPDATE FULL USER
    public boolean update(User user) throws SQLException {
        String sql = """
                UPDATE users
                SET fullName = ?, email = ?, password = ?, phoneNumber = ?, address = ?,
                    profileImagePath = ?, role = ?, trustScore = ?, accountStatus = ?, is_verified = ?
                WHERE userId = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getProfileImagePath());
            stmt.setString(7, user.getRole());
            stmt.setDouble(8, user.getTrustScore());
            stmt.setString(9, user.getAccountStatus());
            stmt.setBoolean(10, user.isVerified());
            stmt.setInt(11, user.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    // UPDATE PROFILE ONLY
    public boolean updateProfile(User user) throws SQLException {
        String sql = """
                UPDATE users
                SET fullName = ?, phoneNumber = ?, address = ?, profileImagePath = ?
                WHERE userId = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getProfileImagePath());
            stmt.setInt(5, user.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    // DELETE USER
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    // MAP RESULT SET → USER OBJECT
    private User map(ResultSet rs) throws SQLException {
        User user = new User();

        user.setUserId(rs.getInt("userId"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phoneNumber"));
        user.setAddress(rs.getString("address"));
        user.setProfileImagePath(rs.getString("profileImagePath"));
        user.setRole(rs.getString("role"));
        user.setTrustScore(rs.getDouble("trustScore"));
        user.setAccountStatus(rs.getString("accountStatus"));
        user.setVerified(rs.getBoolean("is_verified"));

        Timestamp ts = rs.getTimestamp("createdAt");
        if (ts != null) {
            user.setCreatedAt(ts.toLocalDateTime());
        } else {
            user.setCreatedAt(LocalDateTime.now());
        }

        return user;
    }
}