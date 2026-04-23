-- Creates bookings table used by BookingDAO/BookingService flows.
CREATE TABLE IF NOT EXISTS bookings
(
    booking_id  INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id  INT NOT NULL,
    user_id     INT NOT NULL,
    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status      ENUM('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_bookings_date_range CHECK (end_date > start_date),
    CONSTRAINT fk_bookings_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id) ON DELETE CASCADE,
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES users (userId) ON DELETE CASCADE
);

-- Supports overlap checks and history/dashboard queries.
CREATE INDEX idx_bookings_vehicle_dates_status
    ON bookings (vehicle_id, start_date, end_date, status);

CREATE INDEX idx_bookings_user_created_at
    ON bookings (user_id, created_at);

CREATE INDEX idx_bookings_status
    ON bookings (status);


