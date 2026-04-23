-- USERS TABLE
CREATE TABLE users
(
    userId           INT AUTO_INCREMENT PRIMARY KEY,
    fullName         VARCHAR(255) NOT NULL,
    email            VARCHAR(255) NOT NULL UNIQUE,
    password         VARCHAR(255) NOT NULL,
    phoneNumber      VARCHAR(20),
    address          VARCHAR(255),
    profileImagePath VARCHAR(255),

    role             ENUM('RENTER', 'ADMIN', 'OWNER') DEFAULT 'RENTER',

    trustScore DOUBLE DEFAULT 0,

    accountStatus    ENUM('ACTIVE', 'PENDING', 'BLOCKED') DEFAULT 'ACTIVE',

    createdAt        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VEHICLES TABLE
CREATE TABLE vehicles
(
    vehicle_id          INT AUTO_INCREMENT PRIMARY KEY,
    owner_id            INT            NOT NULL,

    vehicle_name        VARCHAR(100)   NOT NULL,
    vehicle_type        ENUM('CAR', 'BIKE', 'SCOOTER', 'VAN', 'TRUCK') NOT NULL,

    description         TEXT,

    price_per_day       DECIMAL(10, 2) NOT NULL,
    location            VARCHAR(100)   NOT NULL,

    availability_status ENUM('AVAILABLE', 'RENTED', 'MAINTENANCE') DEFAULT 'AVAILABLE',

    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (owner_id) REFERENCES users (userId)
        ON DELETE CASCADE
);

-- BOOKINGS TABLE
CREATE TABLE bookings
(
    booking_id  INT AUTO_INCREMENT PRIMARY KEY,

    vehicle_id  INT  NOT NULL,
    user_id     INT  NOT NULL,

    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,

    total_price DECIMAL(10, 2),

    status      ENUM('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',

    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users (userId)
        ON DELETE CASCADE
);

-- REVIEWS TABLE
CREATE TABLE reviews
(
    review_id   INT AUTO_INCREMENT PRIMARY KEY,

    booking_id  INT NOT NULL,
    reviewer_id INT NOT NULL,
    reviewee_id INT NOT NULL,
    vehicle_id  INT NOT NULL,

    rating      INT NOT NULL,
    comment     TEXT,

    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_rating CHECK (rating >= 1 AND rating <= 5),

    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id)
        ON DELETE CASCADE,

    FOREIGN KEY (reviewer_id) REFERENCES users (userId)
        ON DELETE CASCADE,

    FOREIGN KEY (reviewee_id) REFERENCES users (userId)
        ON DELETE CASCADE,

    FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id)
        ON DELETE CASCADE
);

-- REPORT STATS TABLE
CREATE TABLE report_stats
(
    id                INT AUTO_INCREMENT PRIMARY KEY,

    total_users       INT            DEFAULT 0,
    total_vehicles    INT            DEFAULT 0,
    total_bookings    INT            DEFAULT 0,

    pending_bookings  INT            DEFAULT 0,
    approved_bookings INT            DEFAULT 0,
    rejected_bookings INT            DEFAULT 0,

    total_revenue     DECIMAL(12, 2) DEFAULT 0,

    total_reviews     INT            DEFAULT 0,
    average_rating    DECIMAL(3, 2)  DEFAULT 0,

    updated_at        TIMESTAMP      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);