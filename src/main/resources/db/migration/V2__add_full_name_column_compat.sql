-- Ensures compatibility across MySQL variants: add column only when missing.
SET @full_name_exists := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'users'
      AND COLUMN_NAME = 'fullName'
);

SET @add_full_name_sql := IF(
    @full_name_exists = 0,
    'ALTER TABLE users ADD COLUMN fullName VARCHAR(100) NULL',
    'SELECT 1'
);

PREPARE add_full_name_stmt FROM @add_full_name_sql;
EXECUTE add_full_name_stmt;
DEALLOCATE PREPARE add_full_name_stmt;

-- Backfill from available fullName/email values.
UPDATE users
SET fullName = COALESCE(
    NULLIF(TRIM(fullName), ''),
    SUBSTR(email, 1, 100)
)
WHERE fullName IS NULL OR TRIM(fullName) = '';

-- Ensure NOT NULL constraint
ALTER TABLE users
    MODIFY COLUMN fullName VARCHAR(100) NOT NULL;

