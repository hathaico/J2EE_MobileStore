package com.mobilestore.service;

import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.CartItem;
import com.mobilestore.model.Product;

import jakarta.servlet.http.HttpSession;

/**
 * Cart Service
 * Business logic for shopping cart operations
 */
public class CartService {
        // Hàm tiện ích cho kiểm thử tự động (không phụ thuộc HttpSession)
        public Cart createCart() {
            return new Cart();
        }

        public void addProductToCart(Cart cart, Product product, int quantity) {
            if (cart == null || product == null || quantity <= 0) return;
            cart.addItem(product, quantity);
        }
    private static final String CART_SESSION_KEY = "cart";
    
    private final ProductDAO productDAO;
    
    public CartService() {
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get cart from session
     * @param session HTTP session
     * @return Cart object
     */
    public Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute(CART_SESSION_KEY);
        
        if (cart == null) {
            cart = new Cart();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        
        return cart;
    }
    
    /**
     * Add product to cart
     * @param session HTTP session
     * @param productId Product ID to add
     * @param quantity Quantity to add
     * @return true if successful, false otherwise
     */
    public boolean addToCart(HttpSession session, int productId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }
        
        // Get product from database
        Product product = productDAO.getProductById(productId);
        
        if (product == null) {
            throw new IllegalArgumentException("Product not found");
        }
        
        // Check if product is in stock
        if (product.getStockQuantity() == null || product.getStockQuantity() <= 0) {
            throw new IllegalArgumentException("Product is out of stock");
        }
        
        // Get cart and check current quantity
        Cart cart = getCart(session);
        CartItem existingItem = cart.getItem(productId);
        int currentQuantity = existingItem != null ? existingItem.getQuantity() : 0;
        int newQuantity = currentQuantity + quantity;
        
        // Check if new quantity exceeds stock
        if (newQuantity > product.getStockQuantity()) {
            throw new IllegalArgumentException("Quantity exceeds available stock. Available: " + 
                                             product.getStockQuantity());
        }
        
        // Add to cart
        cart.addItem(product, quantity);
        
        return true;
    }
    
    /**
     * Update cart item quantity
     * @param session HTTP session
     * @param productId Product ID
     * @param quantity New quantity
     * @return true if successful, false otherwise
     */
    public boolean updateCartItem(HttpSession session, int productId, int quantity) {
        Cart cart = getCart(session);
        if (quantity <= 0) {
            cart.removeItem(productId);
            return true;
        }
        // Get product from database to check stock
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found");
        }
        // Check if quantity exceeds stock
        if (quantity > product.getStockQuantity()) {
            throw new IllegalArgumentException("Quantity exceeds available stock. Available: " + product.getStockQuantity());
        }
        // Nếu item chưa có trong cart thì thêm mới, nếu đã có thì update số lượng
        if (cart.getItem(productId) == null) {
            cart.addItem(product, quantity);
        } else {
            cart.updateItem(productId, quantity);
        }
        return true;
    }
    
    /**
     * Remove item from cart
     * @param session HTTP session
     * @param productId Product ID to remove
     * @return true if successful, false otherwise
     */
    public boolean removeFromCart(HttpSession session, int productId) {
        Cart cart = getCart(session);
        cart.removeItem(productId);
        return true;
    }
    
    /**
     * Clear cart
     * @param session HTTP session
     */
    public void clearCart(HttpSession session) {
        Cart cart = getCart(session);
        cart.clear();
    }
    
    /**
     * Refresh cart with updated product information
     * This should be called before checkout to ensure prices and stock are current
     * @param session HTTP session
     * @return true if cart is still valid, false if some items were removed
     */
    public boolean refreshCart(HttpSession session) {
        Cart cart = getCart(session);
        boolean cartChanged = false;
        
        // Update each item with latest product information
        for (CartItem item : cart.getItems()) {
            Product currentProduct = productDAO.getProductById(item.getProduct().getProductId());
            
            if (currentProduct == null) {
                // Product no longer exists, remove from cart
                cart.removeItem(item.getProduct().getProductId());
                cartChanged = true;
            } else {
                // Update product information
                item.setProduct(currentProduct);
                
                // Check if quantity is still valid
                if (item.getQuantity() > currentProduct.getStockQuantity()) {
                    if (currentProduct.getStockQuantity() > 0) {
                        // Reduce quantity to available stock
                        item.setQuantity(currentProduct.getStockQuantity());
                    } else {
                        // Out of stock, remove from cart
                        cart.removeItem(currentProduct.getProductId());
                    }
                    cartChanged = true;
                }
            }
        }
        
        return !cartChanged;
    }
    
    /**
     * Get cart item count
     * @param session HTTP session
     * @return Number of items in cart
     */
    public int getCartItemCount(HttpSession session) {
        Cart cart = getCart(session);
        return cart.getItemCount();
    }
}
