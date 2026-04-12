-- Final safety check: ensure full_name is NOT NULL with default fallback.
ALTER TABLE users
    MODIFY COLUMN fullName VARCHAR(100) NOT NULL DEFAULT '';

