CREATE DATABASE vehicle_rental;

USE vehicle_rental;

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       full_name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       phone_number VARCHAR(20),
                       role VARCHAR(20) DEFAULT 'USER',
                       address VARCHAR(255),
                       trust_score DOUBLE DEFAULT 0,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
