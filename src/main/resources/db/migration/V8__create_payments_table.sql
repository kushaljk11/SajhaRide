-- PAYMENTS TABLE
-- Tracks payment transactions for bookings
CREATE TABLE payments (
    payment_id          INT AUTO_INCREMENT PRIMARY KEY,
    booking_id          INT                                         NOT NULL,
    gateway             ENUM('ESEWA', 'KHALTI')                     NOT NULL,
    amount              DECIMAL(10, 2)                              NOT NULL,

    -- Transaction identifiers (vary by gateway)
    transaction_uuid    VARCHAR(255),  -- For eSewa
    pidx                VARCHAR(255),  -- For Khalti

    status              ENUM('PENDING', 'SUCCESS', 'FAILED')        DEFAULT 'PENDING',
    reference_id        VARCHAR(255),

    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY unique_esewa_txn (gateway, transaction_uuid),
    UNIQUE KEY unique_khalti_pidx (gateway, pidx),

    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id)
        ON DELETE CASCADE,
    INDEX idx_booking_payment (booking_id),
    INDEX idx_payment_status (status)
);


