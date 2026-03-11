package com.mobilestore.model;

import java.math.BigDecimal;

/**
 * Order Item Model
 * Represents an item in an order
 */
public class OrderItem {
    private Integer orderItemId;
    private Integer orderId;
    private Integer productId;
    private String productName;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal subtotal;
    
    // Product reference (optional, for display)
    private Product product;
    
    public OrderItem() {
    }
    
    public OrderItem(Integer productId, String productName, BigDecimal price, Integer quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = price.multiply(new BigDecimal(quantity));
    }
    
    // Getters and Setters
    public Integer getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(Integer orderItemId) {
        this.orderItemId = orderItemId;
    }
    
    public Integer getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }
    
    public Integer getProductId() {
        return productId;
    }
    
    public void setProductId(Integer productId) {
        this.productId = productId;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
        calculateSubtotal();
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
        calculateSubtotal();
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
    }
    
    /**
     * Calculate subtotal
     */
    private void calculateSubtotal() {
        if (price != null && quantity != null) {
            this.subtotal = price.multiply(new BigDecimal(quantity));
        }
    }
    
    /**
     * Get formatted price
     * @return Formatted price in VND
     */
    public String getFormattedPrice() {
        return price != null ? String.format("%,d ₫", price.longValue()) : "0 ₫";
    }
    
    /**
     * Get formatted subtotal
     * @return Formatted subtotal in VND
     */
    public String getFormattedSubtotal() {
        return subtotal != null ? String.format("%,d ₫", subtotal.longValue()) : "0 ₫";
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "orderItemId=" + orderItemId +
                ", orderId=" + orderId +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}
