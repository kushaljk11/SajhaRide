package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.Vehicle;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Vehicle database operations.
 */
public class VehicleDAO {

    /**
     * Creates a new vehicle in the database.
     * @param vehicle the Vehicle object
     * @return the created Vehicle with its new ID
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Finds a vehicle by its ID.
     * @param vehicleId the vehicle ID
     * @return the Vehicle object or null if not found
     * @throws SQLException if a database error occurs
     */
    public Vehicle findById(int vehicleId) throws SQLException {
        return getVehicleById(vehicleId);
    }

    /**
     * Gets a vehicle by its ID, including its owner's details.
     * @param vehicleId the vehicle ID
     * @return the Vehicle object with owner info, or null if not found
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Retrieves all vehicles in the system.
     * @return a list of all Vehicles
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Finds all vehicles owned by a specific user.
     * @param ownerId the owner's user ID
     * @return a list of Vehicles
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Finds all currently available vehicles.
     * @return a list of available Vehicles
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Searches for available vehicles by keyword and/or type.
     * @param keyword a search keyword (matches name, location, or description)
     * @param type the vehicle type filter
     * @return a list of matching Vehicles
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Updates a vehicle's information.
     * @param vehicle the Vehicle object to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Updates a vehicle's availability status.
     * @param vehicleId the vehicle ID
     * @param status the new status
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateStatus(int vehicleId, String status) throws SQLException {
        String sql = "UPDATE vehicles SET availability_status = ? WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, vehicleId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Deletes a vehicle by its ID.
     * @param vehicleId the vehicle ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean delete(int vehicleId) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE vehicle_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vehicleId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Counts the total number of vehicles.
     * @return the total vehicle count
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Gets the count of vehicles posted in the last 7 days.
     * @return a list of integers representing counts for each day
     * @throws SQLException if a database error occurs
     */
    public List<Integer> getLast7DaysPosts() throws SQLException {
        List<Integer> counts = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM vehicles WHERE DATE(created_at) = CURDATE() - INTERVAL ? DAY";
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
     * Gets the total number of vehicles (alias for countAll).
     * @return the total vehicle count
     * @throws SQLException if a database error occurs
     */
    public int getTotalVehicles() throws SQLException {
        return countAll();
    }

    /**
     * Counts vehicles by a specific status.
     * @param status the availability status
     * @return the count of vehicles
     * @throws SQLException if a database error occurs
     */
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

    /**
     * Counts vehicles that match any of the provided statuses.
     * @param statuses an array of statuses
     * @return the combined count
     * @throws SQLException if a database error occurs
     */
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