-- Migrate legacy USER role to canonical RENTER role.
-- 1) Temporarily allow both USER and RENTER values.
ALTER TABLE users
    MODIFY COLUMN role ENUM('USER', 'RENTER', 'ADMIN', 'OWNER') NOT NULL DEFAULT 'RENTER';

-- 2) Convert legacy rows.
UPDATE users
SET role = 'RENTER'
WHERE role = 'USER';

-- 3) Enforce final role set.
ALTER TABLE users
    MODIFY COLUMN role ENUM('RENTER', 'ADMIN', 'OWNER') NOT NULL DEFAULT 'RENTER';

