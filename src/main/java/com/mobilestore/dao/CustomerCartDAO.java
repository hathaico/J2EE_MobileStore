package com.mobilestore.dao;

import com.mobilestore.model.Cart;
import com.mobilestore.model.CartItem;
import com.mobilestore.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Customer Cart DAO
 * Persists shopping carts for logged-in customers.
 */
public class CustomerCartDAO extends BaseDAO {
    private final ProductDAO productDAO = new ProductDAO();

    public Cart loadCustomerCart(int customerId) {
        Cart cart = new Cart();
        String sql = "SELECT product_id, selected_color, selected_capacity, quantity " +
                     "FROM customer_cart_items WHERE customer_id = ? ORDER BY cart_item_id ASC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                Product product = productDAO.getProductById(productId);
                if (product == null || product.getStockQuantity() == null || product.getStockQuantity() <= 0) {
                    continue;
                }

                String selectedColor = rs.getString("selected_color");
                String selectedCapacity = rs.getString("selected_capacity");
                int quantity = rs.getInt("quantity");

                cart.addItem(product, quantity, selectedColor, selectedCapacity);
            }
        } catch (SQLException e) {
            System.err.println("Error loading customer cart: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return cart;
    }

    public boolean saveCustomerCart(int customerId, Cart cart) {
        String deleteSql = "DELETE FROM customer_cart_items WHERE customer_id = ?";
        String insertSql = "INSERT INTO customer_cart_items (customer_id, product_id, selected_color, selected_capacity, quantity) " +
                           "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, customerId);
            deleteStmt.executeUpdate();

            insertStmt = conn.prepareStatement(insertSql);
            for (CartItem item : cart.getItems()) {
                if (item == null || item.getProduct() == null || item.getQuantity() == null || item.getQuantity() <= 0) {
                    continue;
                }

                insertStmt.setInt(1, customerId);
                insertStmt.setInt(2, item.getProduct().getProductId());
                insertStmt.setString(3, safeValue(item.getSelectedColor()));
                insertStmt.setString(4, safeValue(item.getSelectedCapacity()));
                insertStmt.setInt(5, item.getQuantity());
                insertStmt.addBatch();
            }

            insertStmt.executeBatch();
            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("Error saving customer cart: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            return false;
        } finally {
            closeResources(conn, deleteStmt);
            closeResources(null, insertStmt, null);
        }
    }

    public boolean clearCustomerCart(int customerId) {
        String sql = "DELETE FROM customer_cart_items WHERE customer_id = ?";
        try {
            return executeUpdate(sql, customerId) >= 0;
        } catch (SQLException e) {
            System.err.println("Error clearing customer cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private String safeValue(String value) {
        return value == null ? "" : value.trim();
    }
}