package com.mobilestore.model;

import java.math.BigDecimal;

/**
 * Cart Item Model
 * Represents an item in the shopping cart
 */
public class CartItem {
    private Product product;
    private Integer quantity;
    private String selectedColor;
    private String selectedCapacity;
    private String itemKey;
    
    public CartItem() {
    }
    
    public CartItem(Product product, Integer quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public CartItem(Product product, Integer quantity, String selectedColor, String selectedCapacity) {
        this.product = product;
        this.quantity = quantity;
        this.selectedColor = normalize(selectedColor);
        this.selectedCapacity = normalize(selectedCapacity);
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

    public String getSelectedColor() {
        return selectedColor;
    }

    public void setSelectedColor(String selectedColor) {
        this.selectedColor = normalize(selectedColor);
    }

    public String getSelectedCapacity() {
        return selectedCapacity;
    }

    public void setSelectedCapacity(String selectedCapacity) {
        this.selectedCapacity = normalize(selectedCapacity);
    }

    public String getItemKey() {
        return itemKey;
    }

    public void setItemKey(String itemKey) {
        this.itemKey = itemKey;
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

    public boolean hasVariantSelection() {
        return (selectedColor != null && !selectedColor.isEmpty()) ||
               (selectedCapacity != null && !selectedCapacity.isEmpty());
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "product=" + (product != null ? product.getProductName() : "null") +
                ", quantity=" + quantity +
            ", selectedColor='" + selectedColor + '\'' +
            ", selectedCapacity='" + selectedCapacity + '\'' +
                ", total=" + getFormattedTotal() +
                '}';
    }
}
