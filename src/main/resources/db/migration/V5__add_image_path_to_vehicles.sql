SET @image_path_exists := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'vehicles'
      AND COLUMN_NAME = 'image_path'
);

SET @add_image_path_sql := IF(
    @image_path_exists = 0,
    'ALTER TABLE vehicles ADD COLUMN image_path VARCHAR(255) DEFAULT NULL',
    'SELECT 1'
);

PREPARE add_image_path_stmt FROM @add_image_path_sql;
EXECUTE add_image_path_stmt;
DEALLOCATE PREPARE add_image_path_stmt;