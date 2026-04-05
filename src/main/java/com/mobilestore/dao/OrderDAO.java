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
        String sql = "SELECT o.*, c.full_name, c.phone, c.email FROM orders o " +
                     "LEFT JOIN customers c ON o.customer_id = c.customer_id " +
                     "WHERE o.order_id = ?";
        
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
        
        // Default SQL includes voucher_id; if DB lacks column, fallback to SQL without it
        String orderSqlWithVoucher = "INSERT INTO orders (customer_id, voucher_id, shipping_address, total_amount, status, payment_method, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String orderSqlNoVoucher = "INSERT INTO orders (customer_id, shipping_address, total_amount, status, payment_method, notes) VALUES (?, ?, ?, ?, ?, ?)";
        
        String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, " +
                "price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        String itemSqlWithVariants = "INSERT INTO order_items (order_id, product_id, product_name, " +
                "price, quantity, subtotal, selected_color, selected_capacity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        boolean hasVoucherColumn = false;
        boolean hasSelectedColorColumn = false;
        boolean hasSelectedCapacityColumn = false;
        try (Connection tmp = getConnection()){
            // check schema for voucher_id column
            ResultSet cols = tmp.getMetaData().getColumns(tmp.getCatalog(), null, "orders", "voucher_id");
            if (cols != null && cols.next()) hasVoucherColumn = true;
            if (cols != null) cols.close();

            ResultSet colorCols = tmp.getMetaData().getColumns(tmp.getCatalog(), null, "order_items", "selected_color");
            if (colorCols != null && colorCols.next()) hasSelectedColorColumn = true;
            if (colorCols != null) colorCols.close();

            ResultSet capacityCols = tmp.getMetaData().getColumns(tmp.getCatalog(), null, "order_items", "selected_capacity");
            if (capacityCols != null && capacityCols.next()) hasSelectedCapacityColumn = true;
            if (capacityCols != null) capacityCols.close();
        } catch (Exception ex) {
            // ignore - we'll try both
        }
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Choose SQL based on schema
            String chosenOrderSql = hasVoucherColumn ? orderSqlWithVoucher : orderSqlNoVoucher;
            orderStmt = conn.prepareStatement(chosenOrderSql, Statement.RETURN_GENERATED_KEYS);
            if (hasVoucherColumn) {
                orderStmt.setObject(1, order.getCustomerId());
                orderStmt.setObject(2, order.getVoucherId());
                orderStmt.setString(3, order.getShippingAddress());
                orderStmt.setBigDecimal(4, order.getTotalAmount());
                orderStmt.setString(5, order.getStatus());
                orderStmt.setString(6, order.getPaymentMethod());
                orderStmt.setString(7, order.getNotes());
            } else {
                orderStmt.setObject(1, order.getCustomerId());
                orderStmt.setString(2, order.getShippingAddress());
                orderStmt.setBigDecimal(3, order.getTotalAmount());
                orderStmt.setString(4, order.getStatus());
                orderStmt.setString(5, order.getPaymentMethod());
                orderStmt.setString(6, order.getNotes());
            }
            
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
            String chosenItemSql = (hasSelectedColorColumn && hasSelectedCapacityColumn) ? itemSqlWithVariants : itemSql;
            itemStmt = conn.prepareStatement(chosenItemSql);
            for (OrderItem item : order.getOrderItems()) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getProductId());
                itemStmt.setString(3, item.getProductName());
                itemStmt.setBigDecimal(4, item.getPrice());
                itemStmt.setInt(5, item.getQuantity());
                itemStmt.setBigDecimal(6, item.getSubtotal());
                if (hasSelectedColorColumn && hasSelectedCapacityColumn) {
                    itemStmt.setString(7, item.getSelectedColor());
                    itemStmt.setString(8, item.getSelectedCapacity());
                }
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
        
        // Set customer information from joined customers table
        if (hasColumn(rs, "full_name")) {
            order.setCustomerName(rs.getString("full_name"));
        }
        if (hasColumn(rs, "phone")) {
            order.setCustomerPhone(rs.getString("phone"));
        }
        if (hasColumn(rs, "email")) {
            order.setCustomerEmail(rs.getString("email"));
        }
        
        // Bỏ các trường không có trong bảng
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        // Bỏ các trường không có trong bảng
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
        item.setPrice(rs.getBigDecimal("unit_price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        if (hasColumn(rs, "selected_color")) {
            item.setSelectedColor(rs.getString("selected_color"));
        }
        if (hasColumn(rs, "selected_capacity")) {
            item.setSelectedCapacity(rs.getString("selected_capacity"));
        }
        
        return item;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        for (int i = 1; i <= columnCount; i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }
}
