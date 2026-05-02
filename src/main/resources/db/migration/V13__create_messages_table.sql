-- MESSAGES TABLE
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(userId) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(userId) ON DELETE CASCADE,
    INDEX idx_sender_receiver (sender_id, receiver_id)
);
