package com.mobilestore.dao;

import com.mobilestore.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * User DAO
 * Data Access Object for User operations
 */
public class UserDAO extends BaseDAO {
        /**
         * Xóa user theo username
         * @param username
         * @return true nếu xóa thành công
         */
        public boolean deleteUserByUsername(String username) {
            // Xóa customer liên kết trước
            try (Connection conn = getConnection()) {
                Integer userId = null;
                String getUserIdSql = "SELECT user_id FROM users WHERE username = ?";
                try (PreparedStatement getStmt = conn.prepareStatement(getUserIdSql)) {
                    getStmt.setString(1, username);
                    try (ResultSet rs = getStmt.executeQuery()) {
                        if (rs.next()) userId = rs.getInt("user_id");
                    }
                }
                if (userId != null) {
                    String delCustSql = "DELETE FROM customers WHERE user_id = ?";
                    try (PreparedStatement delCustStmt = conn.prepareStatement(delCustSql)) {
                        delCustStmt.setInt(1, userId);
                        delCustStmt.executeUpdate();
                    }
                }
                String sql = "DELETE FROM users WHERE username = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    int affected = stmt.executeUpdate();
                    return affected > 0;
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi xóa user theo username: " + e.getMessage());
                return false;
            }
        }

        /**
         * Xóa user theo email
         * @param email
         * @return true nếu xóa thành công
         */
        public boolean deleteUserByEmail(String email) {
            // Xóa customer liên kết trước
            try (Connection conn = getConnection()) {
                Integer userId = null;
                String getUserIdSql = "SELECT user_id FROM users WHERE email = ?";
                try (PreparedStatement getStmt = conn.prepareStatement(getUserIdSql)) {
                    getStmt.setString(1, email);
                    try (ResultSet rs = getStmt.executeQuery()) {
                        if (rs.next()) userId = rs.getInt("user_id");
                    }
                }
                if (userId != null) {
                    String delCustSql = "DELETE FROM customers WHERE user_id = ?";
                    try (PreparedStatement delCustStmt = conn.prepareStatement(delCustSql)) {
                        delCustStmt.setInt(1, userId);
                        delCustStmt.executeUpdate();
                    }
                }
                String sql = "DELETE FROM users WHERE email = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    int affected = stmt.executeUpdate();
                    return affected > 0;
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi xóa user theo email: " + e.getMessage());
                return false;
            }
        }
    
    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return users;
    }
    
    /**
     * Get user by ID
     * @param userId User ID
     * @return User object or null if not found
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return null;
    }
    
    /**
     * Get user by username
     * @param username Username
     * @return User object or null if not found
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by username: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return null;
    }
    
    /**
     * Get user by email
     * @param email Email address
     * @return User object or null if not found
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return null;
    }
    
    /**
     * Create a new user
     * @param user User object
     * @return Generated user ID, or -1 if failed
     */
    public int createUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, role, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            // Log chi tiết thông tin DB đang kết nối
            System.out.println("[DEBUG][DAO] DB URL: " + conn.getMetaData().getURL());
            System.out.println("[DEBUG][DAO] DB Catalog: " + conn.getCatalog());
            System.out.println("[DEBUG][DAO] Insert user: username=" + user.getUsername() + ", email=" + user.getEmail() + ", role=" + user.getRole());
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.getIsActive() != null ? user.getIsActive() : true);

            int affectedRows = stmt.executeUpdate();
            System.out.println("[DEBUG][DAO] affectedRows=" + affectedRows);

            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    System.out.println("[DEBUG][DAO] Generated userId=" + newId);
                    return newId;
                } else {
                    System.out.println("[DEBUG][DAO] Không lấy được generatedKeys sau insert!");
                }
            } else {
                System.out.println("[DEBUG][DAO] Không insert được user mới!");
            }
        } catch (SQLException e) {
            System.err.println("[DEBUG][DAO] Error creating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return -1;
    }
    
    /**
     * Update a user
     * @param user User object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateUser(User user) {
        if (user.getUserId() != null && user.getUserId() == 1) {
            System.err.println("[DAO] Không cho phép update user admin!");
            return false;
        }
        String sql = "UPDATE users SET username = ?, full_name = ?, email = ?, " +
                    "role = ?, is_active = ? WHERE user_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql,
                user.getUsername(),
                user.getFullName(),
                user.getEmail(),
                user.getRole(),
                user.getIsActive(),
                user.getUserId()
            );
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user password
     * @param userId User ID
     * @param hashedPassword Hashed password
     * @return true if successful, false otherwise
     */
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, hashedPassword, userId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a user
     * @param userId User ID
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        if (userId == 1) {
            System.err.println("[DAO] Không cho phép xoá user admin!");
            return false;
        }
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, userId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Activate or deactivate a user
     * @param userId User ID
     * @param isActive Active status
     * @return true if successful, false otherwise
     */
    public boolean setUserActive(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        
        try {
            int affectedRows = executeUpdate(sql, isActive, userId);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error setting user active status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if username exists
     * @param username Username to check
     * @return true if exists, false otherwise
     */
    public boolean usernameExists(String username) {
        return getUserByUsername(username) != null;
    }
    
    /**
     * Check if email exists
     * @param email Email to check
     * @return true if exists, false otherwise
     */
    public boolean emailExists(String email) {
        return getUserByEmail(email) != null;
    }
    
    /**
     * Get users by role
     * @param role User role (ADMIN, STAFF)
     * @return List of users with the specified role
     */
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY full_name";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, role);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting users by role: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return users;
    }
    
    /**
     * Lấy danh sách user theo filter (tìm kiếm, quyền, trạng thái)
     */
    public List<User> getUsersWithFilter(String q, String role, String active) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(username) LIKE ?)");
            String qLike = "%" + q.trim().toLowerCase() + "%";
            params.add(qLike);
            params.add(qLike);
            params.add(qLike);
        }
        if (role != null && !role.isEmpty()) {
            sql.append(" AND role = ?");
            params.add(role);
        }
        if (active != null && !active.isEmpty()) {
            sql.append(" AND is_active = ?");
            params.add(Boolean.parseBoolean(active));
        }
        sql.append(" ORDER BY created_at DESC");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error filtering users: " + e.getMessage());
            e.printStackTrace();
            // Nếu có lỗi, trả về danh sách rỗng thay vì null
            return new ArrayList<>();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return users != null ? users : new ArrayList<>();
    }
    
    /**
     * Map ResultSet to User object
     * @param rs ResultSet
     * @return User object
     * @throws SQLException if mapping fails
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getBoolean("is_active"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return user;
    }
}
