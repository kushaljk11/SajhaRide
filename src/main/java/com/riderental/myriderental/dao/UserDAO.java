package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.User;
import com.riderental.myriderental.util.DBConnection;
import com.riderental.myriderental.util.DaoHelper;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Data Access Object for handling User database operations.
 */
public class UserDAO {

    /**
     * Creates a new user in the database.
     * @param user the User object
     * @return the created user with ID
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Finds a user by their email address.
     * @param email the user's email
     * @return the User object or null if not found
     * @throws SQLException if a database error occurs
     */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        return DaoHelper.queryOne(sql, stmt -> stmt.setString(1, email), this::map);
    }

    /**
     * Finds a user by their ID.
     * @param userId the user ID
     * @return the User object or null if not found
     * @throws SQLException if a database error occurs
     */
    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE userId = ?";
        return DaoHelper.queryOne(sql, stmt -> stmt.setInt(1, userId), this::map);
    }

    /**
     * Retrieves all users in the system.
     * @return a list of all Users
     * @throws SQLException if a database error occurs
     */
    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM users ORDER BY createdAt DESC";
        return DaoHelper.queryList(sql, this::map);
    }

    /**
     * Counts the total number of users.
     * @return the total user count
     * @throws SQLException if a database error occurs
     */
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        return DaoHelper.queryCount(sql);
    }

    /**
     * Counts users by their account status.
     * @param status the account status
     * @return the count of users
     * @throws SQLException if a database error occurs
     */
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE accountStatus = ?";
        return DaoHelper.queryCount(sql, stmt -> stmt.setString(1, status));
    }

    /**
     * Counts users by their role.
     * @param role the user role
     * @return the count of users
     * @throws SQLException if a database error occurs
     */
    public int countByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        return DaoHelper.queryCount(sql, stmt -> stmt.setString(1, role));
    }

    /**
     * Updates an existing user's full information.
     * @param user the User object with updated fields
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean update(User user) throws SQLException {
        String sql = """
                UPDATE users
                SET fullName = ?, email = ?, password = ?, phoneNumber = ?, address = ?,
                    profileImagePath = ?, role = ?, trustScore = ?, accountStatus = ?, is_verified = ?
                WHERE userId = ?
                """;
        return DaoHelper.executeUpdate(sql, stmt -> {
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
        }) > 0;
    }

    /**
     * Updates only a user's profile information.
     * @param user the User object with updated profile fields
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateProfile(User user) throws SQLException {
        String sql = """
                UPDATE users
                SET fullName = ?, phoneNumber = ?, address = ?, profileImagePath = ?
                WHERE userId = ?
                """;
        return DaoHelper.executeUpdate(sql, stmt -> {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getProfileImagePath());
            stmt.setInt(5, user.getUserId());
        }) > 0;
    }

    /**
     * Deletes a user by their ID.
     * @param userId the user ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE userId = ?";
        return DaoHelper.executeUpdate(sql, stmt -> stmt.setInt(1, userId)) > 0;
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