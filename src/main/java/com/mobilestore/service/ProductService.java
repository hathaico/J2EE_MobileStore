package com.mobilestore.service;

import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.Product;

import java.math.BigDecimal;
import java.util.List;

/**
 * Product Service
 * Business logic for Product operations
 */
public class ProductService {
    private final ProductDAO productDAO;
    
    public ProductService() {
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get all products
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }
    
    /**
     * Get product by ID
     * @param productId Product ID
     * @return Product object or null if not found
     */
    public Product getProductById(int productId) {
        return productDAO.getProductById(productId);
    }
    
    /**
     * Get products by category
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.getProductsByCategory(categoryId);
    }
    
    /**
     * Search products by keyword
     * @param keyword Search keyword
     * @return List of matching products
     */
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllProducts();
        }
        return productDAO.searchProducts(keyword.trim());
    }
    
    /**
     * Get products with pagination
     * @param page Page number (1-based)
     * @param pageSize Number of items per page
     * @return List of products
     */
    public List<Product> getProductsWithPagination(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        
        int offset = (page - 1) * pageSize;
        return productDAO.getProductsWithPagination(offset, pageSize);
    }
    
    /**
     * Get total product count
     * @return Total number of products
     */
    public int getTotalProductCount() {
        return productDAO.getTotalProductCount();
    }
    
    /**
     * Calculate total pages for pagination
     * @param pageSize Number of items per page
     * @return Total number of pages
     */
    public int getTotalPages(int pageSize) {
        int totalCount = getTotalProductCount();
        return (int) Math.ceil((double) totalCount / pageSize);
    }
    
    /**
     * Create a new product
     * @param product Product object
     * @return Product ID if successful, -1 if failed
     */
    public int createProduct(Product product) {
        // Validation
        validateProduct(product);
        
        return productDAO.createProduct(product);
    }
    
    /**
     * Update a product
     * @param product Product object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateProduct(Product product) {
        // Validation
        if (product.getProductId() == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        
        // Check if product exists
        Product existing = productDAO.getProductById(product.getProductId());
        if (existing == null) {
            throw new IllegalArgumentException("Product not found");
        }
        
        validateProduct(product);
        
        return productDAO.updateProduct(product);
    }
    
    /**
     * Delete a product
     * @param productId Product ID
     * @return true if successful, false otherwise
     */
    public boolean deleteProduct(int productId) {
        // Check if product exists
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found");
        }
        
        // Note: If you want to check if the product is in any orders,
        // you would add that validation here
        
        return productDAO.deleteProduct(productId);
    }
    
    /**
     * Update product stock
     * @param productId Product ID
     * @param quantity Quantity to add (negative to subtract)
     * @return true if successful, false otherwise
     */
    public boolean updateStock(int productId, int quantity) {
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found");
        }
        
        // Check if resulting stock would be negative
        int newStock = product.getStockQuantity() + quantity;
        if (newStock < 0) {
            throw new IllegalArgumentException("Insufficient stock. Current stock: " + product.getStockQuantity());
        }
        
        return productDAO.updateStock(productId, quantity);
    }
    
    /**
     * Get low stock products
     * @return List of low stock products
     */
    public List<Product> getLowStockProducts() {
        return productDAO.getLowStockProducts();
    }
    
    /**
     * Check if product is available for purchase
     * @param productId Product ID
     * @param quantity Requested quantity
     * @return true if available, false otherwise
     */
    public boolean isAvailable(int productId, int quantity) {
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            return false;
        }
        return product.getStockQuantity() >= quantity;
    }
    
    /**
     * Validate product data
     * @param product Product to validate
     * @throws IllegalArgumentException if validation fails
     */
    private void validateProduct(Product product) {
        // Product name
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be empty");
        }
        
        if (product.getProductName().length() > 200) {
            throw new IllegalArgumentException("Product name is too long (max 200 characters)");
        }
        
        // Brand
        if (product.getBrand() != null && product.getBrand().length() > 100) {
            throw new IllegalArgumentException("Brand name is too long (max 100 characters)");
        }
        
        // Model
        if (product.getModel() != null && product.getModel().length() > 100) {
            throw new IllegalArgumentException("Model is too long (max 100 characters)");
        }
        
        // Price
        if (product.getPrice() == null) {
            throw new IllegalArgumentException("Price cannot be null");
        }
        
        if (product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        
        if (product.getPrice().compareTo(new BigDecimal("99999999.99")) > 0) {
            throw new IllegalArgumentException("Price is too large");
        }
        
        // Stock quantity
        if (product.getStockQuantity() == null) {
            throw new IllegalArgumentException("Stock quantity cannot be null");
        }
        
        if (product.getStockQuantity() < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative");
        }
        
        // Image URL
        if (product.getImageUrl() != null && product.getImageUrl().length() > 255) {
            throw new IllegalArgumentException("Image URL is too long (max 255 characters)");
        }
    }
}
