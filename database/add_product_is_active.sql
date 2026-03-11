-- Add is_active column to products table for soft delete
USE mobilestore_db;

-- Add is_active column
ALTER TABLE products 
ADD COLUMN is_active BOOLEAN DEFAULT TRUE AFTER image_url;

-- Set all existing products to active
UPDATE products SET is_active = TRUE WHERE is_active IS NULL;

-- Verify the change
DESCRIBE products;
