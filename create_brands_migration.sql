-- Create brands table and seed sample data
-- Save this file and run it in your DB client, or move it to your migration folder.

-- PostgreSQL example:
-- CREATE TABLE IF NOT EXISTS brands (
--   brand_id SERIAL PRIMARY KEY,
--   name VARCHAR(150) NOT NULL UNIQUE,
--   logo_url VARCHAR(255)
-- );

-- MySQL example:
-- CREATE TABLE IF NOT EXISTS brands (
--   brand_id INT AUTO_INCREMENT PRIMARY KEY,
--   name VARCHAR(150) NOT NULL UNIQUE,
--   logo_url VARCHAR(255)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample seed data (edit logo paths if needed):
INSERT INTO brands (name, logo_url) VALUES
('Samsung', '/assets/images/brands/samsung.svg'),
('Apple', '/assets/images/brands/apple.svg'),
('Xiaomi', '/assets/images/brands/xiaomi.svg'),
('OPPO', '/assets/images/brands/oppo.svg'),
('Vivo', '/assets/images/brands/vivo.svg'),
('Realme', '/assets/images/brands/realme.svg'),
('OnePlus', '/assets/images/brands/oneplus.svg'),
('Motorola', '/assets/images/brands/motorola.svg'),
('Huawei', '/assets/images/brands/huawei.svg'),
('Google', '/assets/images/brands/google.svg');

-- Notes:
-- 1) If you use Flyway, move this into src/main/resources/db/migration and rename like V2__create_brands.sql.
-- 2) Place brand logos under src/main/webapp/assets/images/brands/ so the admin UI can display them.
-- 3) After running migration, restart the app and reload the add-product page.