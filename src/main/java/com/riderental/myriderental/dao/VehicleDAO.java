package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Vehicle;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // CREATE VEHICLE
    public Vehicle create(Vehicle vehicle) throws SQLException {
        String sql = """
                INSERT INTO vehicles
                (owner_id, vehicle_name, vehicle_type, description, price_per_day,
                 location, availability_status, image_path)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, vehicle.getOwnerId());
            stmt.setString(2, vehicle.getVehicleName());
            stmt.setString(3, vehicle.getVehicleType());
            stmt.setString(4, vehicle.getDescription());
            stmt.setDouble(5, vehicle.getPricePerDay());
            stmt.setString(6, vehicle.getLocation());
            stmt.setString(7, vehicle.getAvailabilityStatus());
            stmt.setString(8, vehicle.getImagePath());

            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    vehicle.setVehicleId(keys.getInt(1));
                }
            }

            return findById(vehicle.getVehicleId());
        }
    }

    // FIND BY ID
    public Vehicle findById(int vehicleId) throws SQLException {
        return getVehicleById(vehicleId);
    }

    // GET VEHICLE BY ID WITH OWNER DETAILS
    public Vehicle getVehicleById(int vehicleId) throws SQLException {
        String sql = """
                SELECT v.*, u.fullName AS owner_name, u.email AS owner_email,
                       u.phoneNumber AS owner_phone_number, u.address AS owner_address,
                       u.profileImagePath AS owner_profile_image_path
                FROM vehicles v
                JOIN users u ON v.owner_id = u.userId
                WHERE v.vehicle_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vehicleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    // FIND ALL VEHICLES
    public List<Vehicle> findAll() throws SQLException {
        String sql = "SELECT * FROM vehicles ORDER BY created_at DESC";
        List<Vehicle> vehicles = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                vehicles.add(map(rs));
            }
        }
        return vehicles;
    }

    // FIND ALL VEHICLES BY OWNER
    public List<Vehicle> findByOwner(int ownerId) throws SQLException {
        String sql = "SELECT * FROM vehicles WHERE owner_id = ? ORDER BY created_at DESC";
        List<Vehicle> vehicles = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(map(rs));
                }
            }
        }
        return vehicles;
    }

    // FIND AVAILABLE VEHICLES ONLY
    public List<Vehicle> findAvailable() throws SQLException {
        String sql = "SELECT * FROM vehicles WHERE availability_status = 'AVAILABLE' ORDER BY created_at DESC";
        List<Vehicle> vehicles = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                vehicles.add(map(rs));
            }
        }
        return vehicles;
    }

    // SEARCH BY KEYWORD AND TYPE
    public List<Vehicle> search(String keyword, String type) throws SQLException {
        String sql = """
                SELECT * FROM vehicles
                WHERE availability_status = 'AVAILABLE'
                AND (vehicle_name LIKE ? OR location LIKE ? OR description LIKE ?)
                AND (? = '' OR vehicle_type = ?)
                ORDER BY created_at DESC
                """;
        List<Vehicle> vehicles = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            String tp = type == null ? "" : type.trim().toUpperCase();

            stmt.setString(1, kw);
            stmt.setString(2, kw);
            stmt.setString(3, kw);
            stmt.setString(4, tp);
            stmt.setString(5, tp);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(map(rs));
                }
            }
        }
        return vehicles;
    }

    // UPDATE VEHICLE
    public boolean update(Vehicle vehicle) throws SQLException {
        String sql = """
                UPDATE vehicles
                SET vehicle_name = ?, vehicle_type = ?, description = ?,
                    price_per_day = ?, location = ?, availability_status = ?, image_path = ?
                WHERE vehicle_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, vehicle.getVehicleName());
            stmt.setString(2, vehicle.getVehicleType());
            stmt.setString(3, vehicle.getDescription());
            stmt.setDouble(4, vehicle.getPricePerDay());
            stmt.setString(5, vehicle.getLocation());
            stmt.setString(6, vehicle.getAvailabilityStatus());
            stmt.setString(7, vehicle.getImagePath());
            stmt.setInt(8, vehicle.getVehicleId());

            return stmt.executeUpdate() > 0;
        }
    }

    // UPDATE AVAILABILITY STATUS ONLY
    public boolean updateStatus(int vehicleId, String status) throws SQLException {
        String sql = "UPDATE vehicles SET availability_status = ? WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, vehicleId);

            return stmt.executeUpdate() > 0;
        }
    }

    // DELETE VEHICLE
    public boolean delete(int vehicleId) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vehicleId);
            return stmt.executeUpdate() > 0;
        }
    }

    // COUNT ALL VEHICLES
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // ALIAS for admin naming
    public int getTotalVehicles() throws SQLException {
        return countAll();
    }

    // COUNT VEHICLES BY AVAILABILITY STATUS
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles WHERE availability_status = ?";

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

    // COUNT VEHICLES BY MULTIPLE STATUSES (for blocked = blocked + maintenance)
    public int countByStatusIn(String... statuses) throws SQLException {
        if (statuses == null || statuses.length == 0) {
            return 0;
        }

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM vehicles WHERE availability_status IN (");
        for (int i = 0; i < statuses.length; i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
        }
        sql.append(")");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < statuses.length; i++) {
                stmt.setString(i + 1, statuses[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // MAP RESULT SET TO VEHICLE OBJECT
    private Vehicle map(ResultSet rs) throws SQLException {
        Vehicle vehicle = new Vehicle();

        vehicle.setVehicleId(rs.getInt("vehicle_id"));
        vehicle.setOwnerId(rs.getInt("owner_id"));
        vehicle.setVehicleName(rs.getString("vehicle_name"));
        vehicle.setVehicleType(rs.getString("vehicle_type"));
        vehicle.setDescription(rs.getString("description"));
        vehicle.setPricePerDay(rs.getDouble("price_per_day"));
        vehicle.setLocation(rs.getString("location"));
        vehicle.setAvailabilityStatus(rs.getString("availability_status"));
        vehicle.setImagePath(rs.getString("image_path"));

        // Extract owner details if available (from JOIN queries)
        try {
            vehicle.setOwnerName(rs.getString("owner_name"));
            vehicle.setOwnerEmail(rs.getString("owner_email"));
            vehicle.setOwnerPhoneNumber(rs.getString("owner_phone_number"));
            vehicle.setOwnerAddress(rs.getString("owner_address"));
            vehicle.setOwnerProfileImagePath(rs.getString("owner_profile_image_path"));
        } catch (SQLException e) {
            // Owner fields not available in this query result
        }

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            vehicle.setCreatedAt(ts.toLocalDateTime());
        } else {
            vehicle.setCreatedAt(LocalDateTime.now());
        }

        return vehicle;
    }
}