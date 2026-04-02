-- Create persistent cart table for logged-in customers

CREATE TABLE IF NOT EXISTS customer_cart_items (
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