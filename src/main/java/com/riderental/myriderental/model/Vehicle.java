package com.riderental.myriderental.model;

import java.time.LocalDateTime;

public class Vehicle {

    private int vehicleId;
    private int ownerId;
    private String vehicleName;
    private String vehicleType;
    private String description;
    private double pricePerDay;
    private String location;
    private String availabilityStatus;
    private String imagePath;
    private LocalDateTime createdAt;

    public Vehicle() {
    }

    public Vehicle(int vehicleId, int ownerId, String vehicleName, String vehicleType,
                   String description, double pricePerDay, String location,
                   String availabilityStatus, String imagePath, LocalDateTime createdAt) {
        this.vehicleId = vehicleId;
        this.ownerId = ownerId;
        this.vehicleName = vehicleName;
        this.vehicleType = vehicleType;
        this.description = description;
        this.pricePerDay = pricePerDay;
        this.location = location;
        this.availabilityStatus = availabilityStatus;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
    }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getVehicleName() { return vehicleName; }
    public void setVehicleName(String vehicleName) { this.vehicleName = vehicleName; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(double pricePerDay) { this.pricePerDay = pricePerDay; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}