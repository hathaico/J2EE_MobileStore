-- Create database
CREATE DATABASE IF NOT EXISTS mobilestore_db;
USE mobilestore_db;

-- Table: categories

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: vouchers

CREATE TABLE vouchers (
    voucher_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_type ENUM('PERCENT', 'AMOUNT') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(12,2) DEFAULT 0,
    max_discount DECIMAL(10,2),
    quantity INT DEFAULT 1,
    used_count INT DEFAULT 0,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: product_reviews

CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: products

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    color VARCHAR(50),
    capacity VARCHAR(50),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
    category_id INT,
    description TEXT,
    image_url VARCHAR(255),
    image_urls TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_product_name (product_name),
    INDEX idx_brand (brand),
    INDEX idx_category (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: users (Admin & Staff)

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    role ENUM('ADMIN', 'STAFF', 'CUSTOMER') DEFAULT 'CUSTOMER',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: customers

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: customer_cart_items

CREATE TABLE customer_cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    selected_color VARCHAR(50) NOT NULL DEFAULT '',
    selected_capacity VARCHAR(50) NOT NULL DEFAULT '',
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uk_customer_product_variant (customer_id, product_id, selected_color, selected_capacity),
    INDEX idx_customer_cart_customer (customer_id),
    INDEX idx_customer_cart_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: orders

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    voucher_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('PENDING', 'CONFIRMED', 'SHIPPING', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    payment_method ENUM('CASH', 'CREDIT_CARD', 'BANK_TRANSFER') DEFAULT 'CASH',
    shipping_address TEXT,
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (voucher_id) REFERENCES vouchers(voucher_id) ON DELETE SET NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status),
    INDEX idx_voucher (voucher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: order_items

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Sample Data

-- Categories
INSERT INTO categories (category_name, description) VALUES
('Smartphone', 'Điện thoại thông minh các loại'),
('Tablet', 'Máy tính bảng'),
('Accessories', 'Phụ kiện điện thoại: ốp lưng, sạc, tai nghe'),
('Smartwatch', 'Đồng hồ thông minh');

-- Users (password: admin123)
INSERT INTO users (username, password, full_name, email, role) VALUES
('admin', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIR.ZU5NH.', 'Administrator', 'admin@mobilestore.com', 'ADMIN'),
('staff', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIR.ZU5NH.', 'Nhân Viên 1', 'staff@mobilestore.com', 'STAFF');

-- ============================================
-- Views for reporting
-- ============================================

-- View: Product inventory
CREATE VIEW v_product_inventory AS
SELECT 
    p.product_id,
    p.product_name,
    p.brand,
    p.price,
    p.stock_quantity,
    c.category_name,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Hết hàng'
        WHEN p.stock_quantity < 10 THEN 'Sắp hết'
        ELSE 'Còn hàng'
    END AS stock_status
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

-- View: Order summary
CREATE VIEW v_order_summary AS
SELECT 
    o.order_id,
    o.order_date,
    c.full_name AS customer_name,
    c.phone AS customer_phone,
    o.total_amount,
    o.status,
    o.payment_method,
    COUNT(oi.order_item_id) AS total_items
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- ============================================
-- Stored Procedures
-- ============================================

DELIMITER //

-- Procedure: Get sales report
CREATE PROCEDURE sp_sales_report(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        DATE(o.order_date) AS order_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE DATE(o.order_date) BETWEEN start_date AND end_date
        AND o.status != 'CANCELLED'
    GROUP BY DATE(o.order_date)
    ORDER BY order_date DESC;
END //

-- Procedure: Update product stock
CREATE PROCEDURE sp_update_stock(
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity + p_quantity
    WHERE product_id = p_product_id;
END //

DELIMITER ;


-- Additional indexes if needed
CREATE INDEX idx_product_price ON products(price);
CREATE INDEX idx_order_total ON orders(total_amount);

-- Delete sample data
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM customers WHERE user_id IS NULL;
DELETE FROM products;

