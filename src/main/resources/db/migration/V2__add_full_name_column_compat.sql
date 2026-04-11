-- Ensures compatibility: adds full_name column if missing and backfills from existing data.
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS fullName VARCHAR(100) NULL;

-- Backfill from legacy name column if it exists, otherwise use email
UPDATE users
SET fullName = COALESCE(
    NULLIF(TRIM(fullName), ''),
    NULLIF(TRIM(COALESCE(name, '')), ''),
    SUBSTR(email, 1, 100)
)
WHERE fullName IS NULL OR TRIM(fullName) = '';

-- Ensure NOT NULL constraint
ALTER TABLE users
    MODIFY COLUMN fullName VARCHAR(100) NOT NULL;

