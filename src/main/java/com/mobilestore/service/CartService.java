package com.mobilestore.service;

import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dao.CustomerCartDAO;
import com.mobilestore.dao.CustomerDAO;
import com.mobilestore.model.Cart;
import com.mobilestore.model.CartItem;
import com.mobilestore.model.Customer;
import com.mobilestore.model.Product;
import com.mobilestore.model.User;

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
    private final CustomerDAO customerDAO;
    private final CustomerCartDAO customerCartDAO;
    
    public CartService() {
        this.productDAO = new ProductDAO();
        this.customerDAO = new CustomerDAO();
        this.customerCartDAO = new CustomerCartDAO();
    }
    
    /**
     * Get cart from session
     * @param session HTTP session
     * @return Cart object
     */
    public Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute(CART_SESSION_KEY);
        
        if (cart == null) {
            cart = loadCustomerCartIfAvailable(session);
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
        return addToCart(session, productId, quantity, null, null);
    }

    /**
     * Add product variant to cart
     */
    public boolean addToCart(HttpSession session, int productId, int quantity, String selectedColor, String selectedCapacity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }

        selectedColor = normalizeVariant(selectedColor);
        selectedCapacity = normalizeVariant(selectedCapacity);
        
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
        CartItem existingVariantItem = cart.getItem(productId, selectedColor, selectedCapacity);
        CartItem unselectedItem = cart.getUnselectedItemByProductId(productId);

        CartItem existingItem = existingVariantItem != null ? existingVariantItem : unselectedItem;
        int currentQuantity = existingItem != null ? existingItem.getQuantity() : 0;
        int newQuantity = currentQuantity + quantity;
        
        // Check if new quantity exceeds stock
        if (newQuantity > product.getStockQuantity()) {
            throw new IllegalArgumentException("Quantity exceeds available stock. Available: " + 
                                             product.getStockQuantity());
        }
        
        // Add to cart or retag an existing unselected item to the chosen variant
        if (existingVariantItem != null) {
            cart.addItem(product, quantity, selectedColor, selectedCapacity);
        } else if (existingItem != null && existingItem == unselectedItem && (selectedColor != null || selectedCapacity != null)) {
            existingItem.setProduct(product);
            existingItem.setQuantity(newQuantity);
            cart.retagItemVariant(existingItem, selectedColor, selectedCapacity);
        } else {
            cart.addItem(product, quantity, selectedColor, selectedCapacity);
        }

        persistCustomerCartIfAvailable(session, cart);
        
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
        CartItem firstItem = cart.getItem(productId);
        if (firstItem == null) {
            throw new IllegalArgumentException("Item not found in cart");
        }
        return updateCartItem(session, firstItem.getItemKey(), quantity);
    }

    /**
     * Update cart item quantity by item key
     */
    public boolean updateCartItem(HttpSession session, String itemKey, int quantity) {
        Cart cart = getCart(session);
        CartItem existingItem = cart.getItemByKey(itemKey);
        if (existingItem == null) {
            throw new IllegalArgumentException("Item not found in cart");
        }

        if (quantity <= 0) {
            cart.removeItemByKey(itemKey);
            return true;
        }

        int productId = existingItem.getProduct().getProductId();
        // Get product from database to check stock
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found");
        }
        // Check if quantity exceeds stock
        if (quantity > product.getStockQuantity()) {
            throw new IllegalArgumentException("Quantity exceeds available stock. Available: " + product.getStockQuantity());
        }

        existingItem.setProduct(product);
        cart.updateItemByKey(itemKey, quantity);
        persistCustomerCartIfAvailable(session, cart);
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
        persistCustomerCartIfAvailable(session, cart);
        return true;
    }

    /**
     * Remove item from cart by item key
     */
    public boolean removeFromCart(HttpSession session, String itemKey) {
        Cart cart = getCart(session);
        cart.removeItemByKey(itemKey);
        persistCustomerCartIfAvailable(session, cart);
        return true;
    }
    
    /**
     * Clear cart
     * @param session HTTP session
     */
    public void clearCart(HttpSession session) {
        Cart cart = getCart(session);
        cart.clear();
        persistCustomerCartIfAvailable(session, cart);
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
                cart.removeItemByKey(item.getItemKey());
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
                        cart.removeItemByKey(item.getItemKey());
                    }
                    cartChanged = true;
                }
            }
        }

        if (cartChanged) {
            persistCustomerCartIfAvailable(session, cart);
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

    /**
     * Load persistent customer cart into session and merge with any existing session cart.
     */
    public Cart attachCustomerCart(HttpSession session) {
        Cart sessionCart = (Cart) session.getAttribute(CART_SESSION_KEY);
        Cart customerCart = loadCustomerCartIfAvailable(session);

        if (sessionCart == null || sessionCart.isEmpty()) {
            session.setAttribute(CART_SESSION_KEY, customerCart);
            return customerCart;
        }

        if (customerCart != null && !customerCart.isEmpty()) {
            for (CartItem item : customerCart.getItems()) {
                if (item != null && item.getProduct() != null) {
                    sessionCart.addItem(item.getProduct(), item.getQuantity(), item.getSelectedColor(), item.getSelectedCapacity());
                }
            }
        }

        session.setAttribute(CART_SESSION_KEY, sessionCart);
        persistCustomerCartIfAvailable(session, sessionCart);
        return sessionCart;
    }

    public void saveCustomerCart(HttpSession session) {
        Cart cart = getCart(session);
        persistCustomerCartIfAvailable(session, cart);
    }

    private Cart loadCustomerCartIfAvailable(HttpSession session) {
        Integer customerId = resolveCustomerId(session);
        if (customerId == null) {
            return new Cart();
        }
        return customerCartDAO.loadCustomerCart(customerId);
    }

    private void persistCustomerCartIfAvailable(HttpSession session, Cart cart) {
        Integer customerId = resolveCustomerId(session);
        if (customerId == null) {
            return;
        }
        customerCartDAO.saveCustomerCart(customerId, cart);
    }

    private Integer resolveCustomerId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof User)) {
            return null;
        }

        User user = (User) userObj;
        if (user.getUserId() == null) {
            return null;
        }

        Customer customer = customerDAO.getCustomerByUserId(user.getUserId());
        return customer != null ? customer.getCustomerId() : null;
    }

    private String normalizeVariant(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
