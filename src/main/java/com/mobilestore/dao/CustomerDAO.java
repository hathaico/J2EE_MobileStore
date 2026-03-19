package com.mobilestore.dao;

import com.mobilestore.model.Customer;
import java.sql.*;

/**
 * Customer DAO
 * Data Access Object for Customer operations
 */
public class CustomerDAO extends BaseDAO {
                /**
                 * Update userId for a customer
                 * @param customerId customer_id
                 * @param userId user_id mới
                 * @return true nếu thành công
                 */
                public boolean updateCustomerUserId(int customerId, int userId) {
                    String sql = "UPDATE customers SET user_id = ? WHERE customer_id = ?";
                    try (java.sql.Connection conn = getConnection();
                         java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, customerId);
                        int affected = stmt.executeUpdate();
                        return affected > 0;
                    } catch (Exception e) {
                        System.err.println("[DEBUG] Failed to update customer userId: " + e.getMessage());
                        return false;
                    }
                }
            /**
             * Get customer by email
             * @param email email in customers table
             * @return Customer object or null if not found
             */
            public com.mobilestore.model.Customer getCustomerByEmail(String email) {
                String sql = "SELECT * FROM customers WHERE email = ?";
                try (Connection conn = getConnection();
                     PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            com.mobilestore.model.Customer customer = new com.mobilestore.model.Customer();
                            customer.setCustomerId(rs.getInt("customer_id"));
                            customer.setFullName(rs.getString("full_name"));
                            customer.setEmail(rs.getString("email"));
                            customer.setPhone(rs.getString("phone"));
                            customer.setAddress(rs.getString("address"));
                            customer.setUserId(rs.getInt("user_id"));
                            customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                            return customer;
                        }
                    }
                } catch (SQLException e) {
                    System.err.println("Error getting customer by email: " + e.getMessage());
                    e.printStackTrace();
                }
                return null;
            }
        /**
         * Get customer by userId
         * @param userId user_id in users table
         * @return Customer object or null if not found
         */
        public com.mobilestore.model.Customer getCustomerByUserId(int userId) {
            String sql = "SELECT * FROM customers WHERE user_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        com.mobilestore.model.Customer customer = new com.mobilestore.model.Customer();
                        customer.setCustomerId(rs.getInt("customer_id"));
                        customer.setFullName(rs.getString("full_name"));
                        customer.setEmail(rs.getString("email"));
                        customer.setPhone(rs.getString("phone"));
                        customer.setAddress(rs.getString("address"));
                        customer.setUserId(rs.getInt("user_id"));
                        customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                        return customer;
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error getting customer by userId: " + e.getMessage());
                e.printStackTrace();
            }
            return null;
        }
    /**
     * Create a new customer
     * @param customer Customer object
     * @return Generated customer ID, or -1 if failed
     */
    public int createCustomer(Customer customer) {
        String sql = "INSERT INTO customers (full_name, email, phone, address, user_id) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, customer.getFullName());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getAddress());
            stmt.setObject(5, customer.getUserId());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;
        } catch (SQLException e) {
            System.err.println("Error creating customer: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
}
