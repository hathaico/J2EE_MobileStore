package com.mobilestore.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Shopping Cart Model
 * Session-based shopping cart
 */
public class Cart {
    private Map<Integer, CartItem> items; // Key: productId, Value: CartItem
    
    public Cart() {
        this.items = new HashMap<>();
    }
    
    /**
     * Add product to cart
     * @param product Product to add
     * @param quantity Quantity to add
     */
    public void addItem(Product product, int quantity) {
        if (product == null || quantity <= 0) {
            return;
        }
        
        Integer productId = product.getProductId();
        
        if (items.containsKey(productId)) {
            // Update quantity if product already exists
            CartItem existingItem = items.get(productId);
            int newQuantity = existingItem.getQuantity() + quantity;
            
            // Check stock availability
            if (newQuantity <= product.getStockQuantity()) {
                existingItem.setQuantity(newQuantity);
            }
        } else {
            // Add new cart item
            CartItem newItem = new CartItem(product, quantity);
            items.put(productId, newItem);
        }
    }
    
    /**
     * Update item quantity
     * @param productId Product ID
     * @param quantity New quantity
     */
    public void updateItem(int productId, int quantity) {
        if (quantity <= 0) {
            removeItem(productId);
            return;
        }
        
        CartItem item = items.get(productId);
        if (item != null) {
            // Check stock availability
            if (quantity <= item.getProduct().getStockQuantity()) {
                item.setQuantity(quantity);
            }
        }
    }
    
    /**
     * Remove item from cart
     * @param productId Product ID to remove
     */
    public void removeItem(int productId) {
        items.remove(productId);
    }
    
    /**
     * Clear all items from cart
     */
    public void clear() {
        items.clear();
    }
    
    /**
     * Get all cart items
     * @return List of cart items
     */
    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }
    
    /**
     * Get cart item by product ID
     * @param productId Product ID
     * @return CartItem or null if not found
     */
    public CartItem getItem(int productId) {
        return items.get(productId);
    }
    
    /**
     * Get total number of items in cart
     * @return Total item count
     */
    public int getItemCount() {
        return items.values().stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }
    
    /**
     * Get total number of unique products
     * @return Number of unique products
     */
    public int getUniqueItemCount() {
        return items.size();
    }
    
    /**
     * Calculate total price of all items
     * @return Total price
     */
    public BigDecimal getTotal() {
        return items.values().stream()
                .map(CartItem::getTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    /**
     * Get formatted total price
     * @return Formatted total price in VND
     */
    public String getFormattedTotal() {
        return String.format("%,d ₫", getTotal().longValue());
    }
    
    /**
     * Check if cart is empty
     * @return true if cart is empty, false otherwise
     */
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    /**
     * Validate all items in cart
     * Check if quantities are available in stock
     * @return true if all items are valid, false otherwise
     */
    public boolean isValid() {
        return items.values().stream()
                .allMatch(CartItem::isValidQuantity);
    }
    
    /**
     * Get list of invalid items (quantity exceeds stock)
     * @return List of invalid cart items
     */
    public List<CartItem> getInvalidItems() {
        return items.values().stream()
                .filter(item -> !item.isValidQuantity())
                .collect(Collectors.toList());
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "items=" + items.size() +
                ", total=" + getFormattedTotal() +
                '}';
    }
}
