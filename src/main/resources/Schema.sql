CREATE DATABASE IF NOT EXISTS vehicle_rental;
USE vehicle_rental;

-- USERS TABLE
CREATE TABLE IF NOT EXISTS users (
     user_id INT AUTO_INCREMENT PRIMARY KEY,
     full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    profile_image_path VARCHAR(255),
    role VARCHAR(20) DEFAULT 'USER',
    trust_score DOUBLE DEFAULT 0,
    account_status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- VEHICLES TABLE
CREATE TABLE IF NOT EXISTS vehicles (
     vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
     owner_id INT NOT NULL,
    vehicle_name VARCHAR(100) NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    description TEXT,
    price_per_day DOUBLE NOT NULL,
    location VARCHAR(100),
    availability_status VARCHAR(20) DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (owner_id) REFERENCES users(user_id)
    ON DELETE CASCADE
    );

-- BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DOUBLE,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
    );


CREATE TABLE IF NOT EXISTS reviews (
     review_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT NOT NULL,
    reviewer_id INT NOT NULL,
     reviewee_id INT NOT NULL,
    vehicle_id INT NOT NULL,

    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
    ON DELETE CASCADE,

    FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY (reviewee_id) REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE
    );
