-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    profile_image_path VARCHAR(255),

    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    trust_score DOUBLE DEFAULT 0,

    account_status ENUM('ACTIVE', 'SUSPENDED', 'DEACTIVATED') DEFAULT 'ACTIVE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VEHICLES TABLE
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,

    vehicle_name VARCHAR(100) NOT NULL,
    vehicle_type ENUM('CAR', 'BIKE', 'SCOOTER', 'VAN', 'TRUCK') NOT NULL,

    description TEXT,

    price_per_day DECIMAL(10,2) NOT NULL,
    location VARCHAR(100) NOT NULL,

    availability_status ENUM('AVAILABLE', 'RENTED', 'MAINTENANCE') DEFAULT 'AVAILABLE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (owner_id) REFERENCES users(user_id)
    ON DELETE CASCADE
);

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,

    vehicle_id INT NOT NULL,
    user_id INT NOT NULL,

    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    total_price DECIMAL(10,2),

    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
);

-- REVIEWS TABLE
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    reviewee_id INT NOT NULL,
    vehicle_id INT NOT NULL,

    rating INT NOT NULL,
    comment TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_rating CHECK (rating >= 1 AND rating <= 5),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
    ON DELETE CASCADE,

    FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY (reviewee_id) REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE
);

-- REPORT STATS TABLE
CREATE TABLE report_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,

    total_users INT DEFAULT 0,
    total_vehicles INT DEFAULT 0,
    total_bookings INT DEFAULT 0,

    pending_bookings INT DEFAULT 0,
    approved_bookings INT DEFAULT 0,
    rejected_bookings INT DEFAULT 0,

    total_revenue DECIMAL(12,2) DEFAULT 0,

    total_reviews INT DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
);