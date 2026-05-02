package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Vehicle;
import com.riderental.myriderental.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SavedVehicleDAO {

    public boolean isSaved(int userId, int vehicleId) throws SQLException {
        String sql = "SELECT 1 FROM saved_vehicles WHERE user_id = ? AND vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, vehicleId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void addSavedVehicle(int userId, int vehicleId) throws SQLException {
        if (!isSaved(userId, vehicleId)) {
            String sql = "INSERT INTO saved_vehicles (user_id, vehicle_id) VALUES (?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, vehicleId);
                stmt.executeUpdate();
            }
        }
    }

    public void removeSavedVehicle(int userId, int vehicleId) throws SQLException {
        String sql = "DELETE FROM saved_vehicles WHERE user_id = ? AND vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, vehicleId);
            stmt.executeUpdate();
        }
    }

    public List<Vehicle> getSavedVehicles(int userId) throws SQLException {
        String sql = "SELECT v.* FROM vehicles v " +
                     "JOIN saved_vehicles sv ON v.vehicle_id = sv.vehicle_id " +
                     "WHERE sv.user_id = ? " +
                     "ORDER BY sv.created_at DESC";
        
        List<Vehicle> vehicles = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setVehicleId(rs.getInt("vehicle_id"));
                    v.setOwnerId(rs.getInt("owner_id"));
                    v.setVehicleName(rs.getString("vehicle_name"));
                    v.setVehicleType(rs.getString("vehicle_type"));
                    v.setDescription(rs.getString("description"));
                    v.setPricePerDay(rs.getDouble("price_per_day"));
                    v.setLocation(rs.getString("location"));
                    v.setAvailabilityStatus(rs.getString("availability_status"));
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        v.setCreatedAt(ts.toLocalDateTime());
                    }
                    
                    try {
                        v.setImagePath(rs.getString("image_path"));
                    } catch(SQLException ignored) {}
                    
                    vehicles.add(v);
                }
            }
        }
        return vehicles;
    }
}
