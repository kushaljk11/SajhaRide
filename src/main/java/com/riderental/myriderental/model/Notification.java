package com.riderental.myriderental.model;

import java.time.LocalDateTime;

/**
 * Represents a system notification for a user.
 */
public class Notification {
    private int id;
    private int userId;
    private String message;
    private boolean isRead;
    private LocalDateTime createdAt;

    public Notification() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
