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
    private Map<String, CartItem> items; // Key: variant key, Value: CartItem
    
    public Cart() {
        this.items = new HashMap<>();
    }
    
    /**
     * Add product to cart
     * @param product Product to add
     * @param quantity Quantity to add
     */
    public void addItem(Product product, int quantity) {
        addItem(product, quantity, null, null);
    }

    /**
     * Add product variant to cart
     * @param product Product to add
     * @param quantity Quantity to add
     * @param selectedColor Selected color (optional)
     * @param selectedCapacity Selected capacity (optional)
     */
    public void addItem(Product product, int quantity, String selectedColor, String selectedCapacity) {
        if (product == null || quantity <= 0) {
            return;
        }

        String itemKey = generateItemKey(product.getProductId(), selectedColor, selectedCapacity);

        if (items.containsKey(itemKey)) {
            // Update quantity if product already exists
            CartItem existingItem = items.get(itemKey);
            int newQuantity = existingItem.getQuantity() + quantity;

            // Check stock availability
            if (newQuantity <= product.getStockQuantity()) {
                existingItem.setQuantity(newQuantity);
            }
        } else {
            // Add new cart item
            CartItem newItem = new CartItem(product, quantity, selectedColor, selectedCapacity);
            newItem.setItemKey(itemKey);
            items.put(itemKey, newItem);
        }
    }
    
    /**
     * Update item quantity
     * @param productId Product ID
     * @param quantity New quantity
     */
    public void updateItem(int productId, int quantity) {
        CartItem item = getItem(productId);
        if (item != null) {
            updateItemByKey(item.getItemKey(), quantity);
        }
    }

    /**
     * Update item quantity by item key
     * @param itemKey Variant item key
     * @param quantity New quantity
     */
    public void updateItemByKey(String itemKey, int quantity) {
        if (itemKey == null || itemKey.trim().isEmpty()) {
            return;
        }

        if (quantity <= 0) {
            removeItemByKey(itemKey);
            return;
        }

        CartItem item = items.get(itemKey);
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
        List<String> keysToRemove = new ArrayList<>();
        for (Map.Entry<String, CartItem> entry : items.entrySet()) {
            CartItem item = entry.getValue();
            if (item != null && item.getProduct() != null && item.getProduct().getProductId() == productId) {
                keysToRemove.add(entry.getKey());
            }
        }
        for (String key : keysToRemove) {
            items.remove(key);
        }
    }

    /**
     * Remove item from cart by key
     * @param itemKey Item key to remove
     */
    public void removeItemByKey(String itemKey) {
        if (itemKey == null || itemKey.trim().isEmpty()) {
            return;
        }
        items.remove(itemKey);
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
        for (CartItem item : items.values()) {
            if (item != null && item.getProduct() != null && item.getProduct().getProductId() == productId) {
                return item;
            }
        }
        return null;
    }

    /**
     * Get cart item by product and variant
     * @param productId Product ID
     * @param selectedColor Selected color
     * @param selectedCapacity Selected capacity
     * @return CartItem or null if not found
     */
    public CartItem getItem(int productId, String selectedColor, String selectedCapacity) {
        String itemKey = generateItemKey(productId, selectedColor, selectedCapacity);
        return items.get(itemKey);
    }

    /**
     * Get cart item by item key
     * @param itemKey Item key
     * @return CartItem or null if not found
     */
    public CartItem getItemByKey(String itemKey) {
        if (itemKey == null || itemKey.trim().isEmpty()) {
            return null;
        }
        return items.get(itemKey);
    }

    /**
     * Get the first cart item for a product that does not yet have a variant selection.
     * @param productId Product ID
     * @return Unselected cart item or null
     */
    public CartItem getUnselectedItemByProductId(int productId) {
        for (CartItem item : items.values()) {
            if (item != null
                    && item.getProduct() != null
                    && item.getProduct().getProductId() == productId
                    && !item.hasVariantSelection()) {
                return item;
            }
        }
        return null;
    }

    /**
     * Update an existing item to a selected variant while preserving the cart entry.
     * @param item Item to retag
     * @param selectedColor Selected color
     * @param selectedCapacity Selected capacity
     */
    public void retagItemVariant(CartItem item, String selectedColor, String selectedCapacity) {
        if (item == null) {
            return;
        }

        String currentKey = findItemKey(item);
        if (currentKey == null) {
            currentKey = item.getItemKey();
        }

        if (currentKey != null) {
            items.remove(currentKey);
        }

        item.setSelectedColor(selectedColor);
        item.setSelectedCapacity(selectedCapacity);

        String newKey = generateItemKey(
                item.getProduct() != null ? item.getProduct().getProductId() : 0,
                selectedColor,
                selectedCapacity
        );
        item.setItemKey(newKey);
        items.put(newKey, item);
    }

    private String findItemKey(CartItem target) {
        if (target == null) {
            return null;
        }

        for (Map.Entry<String, CartItem> entry : items.entrySet()) {
            if (entry.getValue() == target) {
                return entry.getKey();
            }
        }
        return null;
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

    public static String generateItemKey(int productId, String selectedColor, String selectedCapacity) {
        return productId + "|" + normalizeVariantValue(selectedColor) + "|" + normalizeVariantValue(selectedCapacity);
    }

    private static String normalizeVariantValue(String value) {
        if (value == null) {
            return "";
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? "" : trimmed.toLowerCase();
    }
}
