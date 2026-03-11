package com.mobilestore.dao;

import com.mobilestore.model.Order;
import com.mobilestore.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Order DAO
 * Data Access Object for Order operations
 */
public class OrderDAO extends BaseDAO {
    
    /**
     * Get all orders
     * @return List of all orders
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all orders: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }
    
    /**
     * Get order by ID with order items
     * @param orderId Order ID
     * @return Order object with items or null if not found
     */
    public Order getOrderById(int orderId) {
        Order order = getOrderBasicInfo(orderId);
        
        if (order != null) {
            // Load order items
            List<OrderItem> items = getOrderItems(orderId);
            order.setOrderItems(items);
        }
        
        return order;
    }
    
    /**
     * Get basic order info (without items)
     * @param orderId Order ID
     * @return Order object or null if not found
     */
    private Order getOrderBasicInfo(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting order by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return null;
    }
    
    /**
     * Get order items by order ID
     * @param orderId Order ID
     * @return List of order items
     */
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                items.add(mapResultSetToOrderItem(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting order items: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return items;
    }
    
    /**
     * Get orders by customer ID
     * @param customerId Customer ID
     * @return List of orders for the customer
     */
    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customer_id = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting orders by customer ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }
    
    /**
     * Get orders by status
     * @param status Order status
     * @return List of orders with the specified status
     */
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting orders by status: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }
    
    /**
     * Create a new order with items
     * @param order Order object with items
     * @return Generated order ID, or -1 if failed
     */
    public int createOrder(Order order) {
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;
        
        String orderSql = "INSERT INTO orders (customer_id, customer_name, customer_phone, " +
                         "customer_email, shipping_address, total_amount, status, " +
                         "payment_method, payment_status, notes) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, " +
                        "price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert order
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setObject(1, order.getCustomerId());
            orderStmt.setString(2, order.getCustomerName());
            orderStmt.setString(3, order.getCustomerPhone());
            orderStmt.setString(4, order.getCustomerEmail());
            orderStmt.setString(5, order.getShippingAddress());
            orderStmt.setBigDecimal(6, order.getTotalAmount());
            orderStmt.setString(7, order.getStatus());
            orderStmt.setString(8, order.getPaymentMethod());
            orderStmt.setString(9, order.getPaymentStatus());
            orderStmt.setString(10, order.getNotes());
            
            int affectedRows = orderStmt.executeUpdate();
            
            if (affectedRows == 0) {
                conn.rollback();
                return -1;
            }
            
            // Get generated order ID
            rs = orderStmt.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                conn.rollback();
                return -1;
            }
            
            // Insert order items
            itemStmt = conn.prepareStatement(itemSql);
            for (OrderItem item : order.getOrderItems()) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getProductId());
                itemStmt.setString(3, item.getProductName());
                itemStmt.setBigDecimal(4, item.getPrice());
                itemStmt.setInt(5, item.getQuantity());
                itemStmt.setBigDecimal(6, item.getSubtotal());
                itemStmt.addBatch();
            }
            
            itemStmt.executeBatch();
            
            conn.commit(); // Commit transaction
            return orderId;
            
        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
            e.printStackTrace();
            
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            
            return -1;
        } finally {
            closeResources(conn, orderStmt, rs);
            closeResources(null, itemStmt, null);
        }
    }
    
    /**
     * Update order status
     * @param orderId Order ID
     * @param status New status
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE order_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, status, orderId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update payment status
     * @param orderId Order ID
     * @param paymentStatus New payment status
     * @return true if successful, false otherwise
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE order_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, paymentStatus, orderId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete an order and its items
     * @param orderId Order ID
     * @return true if successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        // Order items will be deleted automatically due to CASCADE
        String sql = "DELETE FROM orders WHERE order_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, orderId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map ResultSet to Order object
     * @param rs ResultSet
     * @return Order object
     * @throws SQLException if mapping fails
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        
        int customerId = rs.getInt("customer_id");
        order.setCustomerId(rs.wasNull() ? null : customerId);
        
        order.setCustomerName(rs.getString("customer_name"));
        order.setCustomerPhone(rs.getString("customer_phone"));
        order.setCustomerEmail(rs.getString("customer_email"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setNotes(rs.getString("notes"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            order.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return order;
    }
    
    /**
     * Map ResultSet to OrderItem object
     * @param rs ResultSet
     * @return OrderItem object
     * @throws SQLException if mapping fails
     */
    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setProductName(rs.getString("product_name"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        
        return item;
    }
}
