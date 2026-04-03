package com.mobilestore.dao;

import com.mobilestore.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Product DAO
 * Data Access Object for Product operations
 */
public class ProductDAO extends BaseDAO {
    
    /**
     * Get all products with category names
     * @return List of all products
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.is_active = TRUE " +
                    "ORDER BY p.created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all products: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Get all products including inactive (for admin)
     * @return List of all products
     */
    public List<Product> getAllProductsIncludingInactive() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "ORDER BY p.is_active DESC, p.created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all products including inactive: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Get product by ID
     * @param productId Product ID
     * @return Product object or null if not found
     */
    public Product getProductById(int productId) {
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.product_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return null;
    }
    
    /**
     * Get products by category
     * @param categoryId Category ID
     * @return List of products in the category
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.category_id = ? AND p.is_active = TRUE " +
                    "ORDER BY p.product_name";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting products by category: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Search products by keyword (name or brand)
     * @param keyword Search keyword
     * @return List of matching products
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.is_active = TRUE AND (p.product_name LIKE ? OR p.brand LIKE ?) " +
                    "ORDER BY p.product_name";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Get products with pagination
     * @param offset Starting position
     * @param limit Number of records
     * @return List of products
     */
    public List<Product> getProductsWithPagination(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.is_active = TRUE " +
                    "ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting products with pagination: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Get total product count
     * @return Total number of products
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = TRUE";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting product count: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return 0;
    }
    
    /**
     * Create a new product
     * @param product Product object
     * @return Generated product ID, or -1 if failed
     */
    public int createProduct(Product product) {
        String sql = "INSERT INTO products (product_name, brand, model, color, capacity, price, stock_quantity, " +
                "category_id, description, image_url, image_urls) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getBrand());
            stmt.setString(3, product.getModel());
            stmt.setString(4, product.getColor());
            stmt.setString(5, product.getCapacity());
            stmt.setBigDecimal(6, product.getPrice());
            stmt.setInt(7, product.getStockQuantity());
            stmt.setObject(8, product.getCategoryId());
            stmt.setString(9, product.getDescription());
            stmt.setString(10, product.getImageUrl());
            stmt.setString(11, product.getImageUrls());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return -1;
    }
    
    /**
     * Update a product
     * @param product Product object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET product_name = ?, brand = ?, model = ?, color = ?, capacity = ?, price = ?, " +
                    "stock_quantity = ?, category_id = ?, description = ?, image_url = ?, image_urls = ? " +
                    "WHERE product_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql,
                product.getProductName(),
                product.getBrand(),
                product.getModel(),
                product.getColor(),
                product.getCapacity(),
                product.getPrice(),
                product.getStockQuantity(),
                product.getCategoryId(),
                product.getDescription(),
                product.getImageUrl(),
                product.getImageUrls(),
                product.getProductId()
            );
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a product
     * @param productId Product ID
     * @return true if successful, false otherwise
     */
    public boolean deleteProduct(int productId) {
        // Soft delete: set is_active = FALSE instead of deleting
        String sql = "UPDATE products SET is_active = FALSE WHERE product_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, productId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Restore a deleted product
     * @param productId Product ID
     * @return true if successful, false otherwise
     */
    public boolean restoreProduct(int productId) {
        String sql = "UPDATE products SET is_active = TRUE WHERE product_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, productId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error restoring product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update product stock
     * @param productId Product ID
     * @param quantity Quantity to add (negative to subtract)
     * @return true if successful, false otherwise
     */
    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, quantity, productId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating stock: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get low stock products (stock < 10)
     * @return List of low stock products
     */
    public List<Product> getLowStockProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name FROM products p " +
                    "LEFT JOIN categories c ON p.category_id = c.category_id " +
                    "WHERE p.stock_quantity < 10 AND p.stock_quantity > 0 " +
                    "ORDER BY p.stock_quantity ASC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting low stock products: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    /**
     * Map ResultSet to Product object
     * @param rs ResultSet
     * @return Product object
     * @throws SQLException if mapping fails
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setBrand(rs.getString("brand"));
        product.setModel(rs.getString("model"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategoryId((Integer) rs.getObject("category_id"));
        product.setCategoryName(rs.getString("category_name"));
        product.setDescription(rs.getString("description"));
        product.setColor(rs.getString("color"));
        product.setCapacity(rs.getString("capacity"));
        product.setImageUrl(rs.getString("image_url"));
        product.setImageUrls(rs.getString("image_urls"));
        product.setIsActive(rs.getBoolean("is_active"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return product;
    }

    /**
     * Get distinct brand names from products table
     * @return List of brand name strings
     */
    public java.util.List<String> getDistinctBrands() {
        java.util.List<String> brands = new java.util.ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM products WHERE brand IS NOT NULL AND TRIM(brand) <> '' ORDER BY brand";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                brands.add(rs.getString(1));
            }
        } catch (SQLException e) {
            System.err.println("Error getting distinct brands: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return brands;
    }
}

