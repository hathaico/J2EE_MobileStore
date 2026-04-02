-- Add color and capacity columns to products table
USE mobilestore_db;

ALTER TABLE products
    ADD COLUMN color VARCHAR(50) AFTER model,
    ADD COLUMN capacity VARCHAR(50) AFTER color;

-- Verify the table structure
DESCRIBE products;
