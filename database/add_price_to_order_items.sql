-- Add price column to order_items if not exists
ALTER TABLE order_items ADD COLUMN price DECIMAL(10,2) NOT NULL DEFAULT 0 AFTER product_name;