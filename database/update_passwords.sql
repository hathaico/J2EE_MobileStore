USE mobilestore_db;

-- Update correct password hashes for users
-- Password: admin123 for both accounts

UPDATE users SET password = '$2a$12$jBaFfKjzvXsMaXpV7M9Gw.p4KNZCMdh7rAFZk/h/c7757.3/yGqM2' WHERE username = 'admin';
UPDATE users SET password = '$2a$12$IMcbRyX6V8LkxzQRj7gu1eal3jA0.m0l6B3UUxe3RkIIJioW/AAKy' WHERE username = 'staff';

-- Verify update
SELECT username, LEFT(password, 20) as password_prefix, LENGTH(password) as password_length FROM users;
