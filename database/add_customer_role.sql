-- Add CUSTOMER role to users table
USE mobilestore_db;

ALTER TABLE users 
MODIFY COLUMN role ENUM('ADMIN', 'STAFF', 'CUSTOMER') DEFAULT 'CUSTOMER';

-- Verify the change
DESCRIBE users;
