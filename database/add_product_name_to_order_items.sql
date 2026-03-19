-- Add product_name column to order_items if not exists
ALTER TABLE order_items ADD COLUMN product_name VARCHAR(200) NOT NULL AFTER product_id;