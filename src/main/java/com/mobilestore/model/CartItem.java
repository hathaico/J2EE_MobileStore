package com.mobilestore.model;

import java.math.BigDecimal;

/**
 * Cart Item Model
 * Represents an item in the shopping cart
 */
public class CartItem {
    private Product product;
    private Integer quantity;
    
    public CartItem() {
    }
    
    public CartItem(Product product, Integer quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    /**
     * Calculate total price for this cart item
     * @return Total price (price * quantity)
     */
    public BigDecimal getTotal() {
        if (product == null || product.getPrice() == null || quantity == null) {
            return BigDecimal.ZERO;
        }
        return product.getPrice().multiply(new BigDecimal(quantity));
    }
    
    /**
     * Check if quantity is valid based on stock
     * @return true if quantity is valid, false otherwise
     */
    public boolean isValidQuantity() {
        if (product == null || quantity == null || quantity <= 0) {
            return false;
        }
        
        return product.getStockQuantity() != null && quantity <= product.getStockQuantity();
    }
    
    /**
     * Get formatted total price
     * @return Formatted total price in VND
     */
    public String getFormattedTotal() {
        return String.format("%,d ₫", getTotal().longValue());
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "product=" + (product != null ? product.getProductName() : "null") +
                ", quantity=" + quantity +
                ", total=" + getFormattedTotal() +
                '}';
    }
}
