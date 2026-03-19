package com.mobilestore.service;

import com.mobilestore.dao.UserDAO;
import com.mobilestore.model.User;
import com.mobilestore.util.PasswordUtil;
import com.mobilestore.util.ValidationUtil;

import java.util.List;

/**
 * User Service
 * Business logic for User operations and authentication
 */
public class UserService {
    private final UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Authenticate user with username and password
     * @param username Username
     * @param password Plain text password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticate(String usernameOrEmail, String password) {
        System.out.println("=== Authentication Attempt ===");
        System.out.println("Username/Email: " + usernameOrEmail);

        // Validation
        if (ValidationUtil.isEmpty(usernameOrEmail) || ValidationUtil.isEmpty(password)) {
            System.out.println("⚠ Empty username/email or password");
            return null;
        }

        // Try get user by email first
        User user = userDAO.getUserByEmail(usernameOrEmail.trim());
        if (user == null) {
            // Try get user by username
            user = userDAO.getUserByUsername(usernameOrEmail.trim());
        }

        // Check if user exists and is active
        if (user == null) {
            System.out.println("⚠ User not found in database");
            return null;
        }

        System.out.println("✓ User found: " + user.getFullName() + " (Role: " + user.getRole() + ")");
        System.out.println("User active: " + user.getIsActive());

        if (!user.getIsActive()) {
            System.out.println("⚠ User is not active");
            return null;
        }

        // Verify password
        System.out.println("Verifying password...");
        boolean passwordMatch = PasswordUtil.verifyPassword(password, user.getPassword());
        System.out.println("Password match: " + passwordMatch);

        if (passwordMatch) {
            System.out.println("✓ Authentication successful!");
            // Don't return password to the session
            user.setPassword(null);
            return user;
        }
        
        System.out.println("⚠ Password verification failed");
        return null;
    }
    
    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    
    /**
     * Get user by ID
     * @param userId User ID
     * @return User object or null if not found
     */
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }
    
    /**
     * Get user by username
     * @param username Username
     * @return User object or null if not found
     */
    public User getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }
    
    /**
     * Get user by email
     * @param email Email address
     * @return User object or null if not found
     */
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
    
    /**
     * Register a new customer
     * @param user User object with customer data (password in plain text)
     * @return true if successful, false otherwise
     */
    public boolean registerUser(User user) {
        try {
            // Validation

            if (ValidationUtil.isEmpty(user.getUsername()) || 
                ValidationUtil.isEmpty(user.getPassword()) ||
                ValidationUtil.isEmpty(user.getFullName()) ||
                ValidationUtil.isEmpty(user.getEmail())) {
                return false;
            }

            // Kiểm tra độ dài username
            if (!ValidationUtil.isValidLength(user.getUsername(), 3, 50)) {
                return false;
            }

            // Kiểm tra email hợp lệ
            if (!ValidationUtil.isValidEmail(user.getEmail())) {
                return false;
            }

            if (!ValidationUtil.isValidPassword(user.getPassword())) {
                return false;
            }
            
            // Check if username already exists
            if (userDAO.getUserByUsername(user.getUsername()) != null) {
                return false;
            }
            
            // Check if email already exists
            if (userDAO.getUserByEmail(user.getEmail()) != null) {
                return false;
            }
            
            // Hash password
            String plainPassword = user.getPassword();
            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            user.setPassword(hashedPassword);
            
            // Thiết lập vai trò mặc định là 'USER' nếu chưa có
            if (user.getRole() == null || user.getRole().isEmpty()) {
                user.setRole("USER");
            }
            
            // Create user
            int userId = userDAO.createUser(user);
            if (userId > 0) {
                user.setUserId(userId);
                // Tạo customer nếu chưa tồn tại theo email
                com.mobilestore.dao.CustomerDAO customerDAO = new com.mobilestore.dao.CustomerDAO();
                com.mobilestore.model.Customer existing = customerDAO.getCustomerByEmail(user.getEmail());
                if (existing == null) {
                    com.mobilestore.model.Customer customer = new com.mobilestore.model.Customer();
                    customer.setFullName(user.getFullName());
                    customer.setEmail(user.getEmail());
                    customer.setUserId(userId);
                    int custId = customerDAO.createCustomer(customer);
                    System.out.println("[DEBUG] Created customer for userId=" + userId + ", email=" + user.getEmail() + ", customerId=" + custId);
                } else {
                    // Nếu customer đã có email nhưng userId=null hoặc khác userId mới, cập nhật lại userId
                    if (existing.getUserId() == null || !existing.getUserId().equals(userId)) {
                        boolean updated = customerDAO.updateCustomerUserId(existing.getCustomerId(), userId);
                        if (updated) {
                            System.out.println("[DEBUG] Updated customer userId for email=" + user.getEmail());
                        } else {
                            System.err.println("[DEBUG] Failed to update customer userId for email=" + user.getEmail());
                        }
                    } else {
                        System.out.println("[DEBUG] Customer already exists for email=" + user.getEmail());
                    }
                }
                return true;
            }
            return false;
            
        } catch (Exception e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Register a new user (for test compatibility)
     */
    public boolean register(User user) {
        return registerUser(user);
    }
    
    /**
     * Create a new user
     * @param user User object
     * @param plainPassword Plain text password
     * @return User ID if successful, -1 if failed
     */
    public int createUser(User user, String plainPassword) {
        System.out.println("[DEBUG][SERVICE] Bắt đầu createUser với username=" + user.getUsername() + ", email=" + user.getEmail() + ", role=" + user.getRole());
        // Cho phép tạo user admin (userId==1) nếu cần, chỉ chặn sửa ở updateUser
        try {
            // Validation
            validateUser(user);
            System.out.println("[DEBUG][SERVICE] Qua validateUser");
            validatePassword(plainPassword);
            System.out.println("[DEBUG][SERVICE] Qua validatePassword");
            // Check if username already exists
            if (userDAO.usernameExists(user.getUsername())) {
                System.out.println("[DEBUG][SERVICE] Username đã tồn tại");
                throw new IllegalArgumentException("Username already exists");
            }
            // Check if email already exists
            if (user.getEmail() != null && userDAO.emailExists(user.getEmail())) {
                System.out.println("[DEBUG][SERVICE] Email đã tồn tại");
                throw new IllegalArgumentException("Email already exists");
            }
            // Hash password
            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            user.setPassword(hashedPassword);
            System.out.println("[DEBUG][SERVICE] Đã hash password, chuẩn bị insert DB");
            int result = userDAO.createUser(user);
            System.out.println("[DEBUG][SERVICE] Kết quả insert user: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("[DEBUG][SERVICE][ERROR] " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * Update a user
     * @param user User object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateUser(User user) {
        // Validation
        if (user.getUserId() == null) throw new IllegalArgumentException("User ID cannot be null");
        // Chỉ chặn sửa user admin (userId==1) khi update
        if (user.getUserId() == 1) throw new IllegalArgumentException("Không thể sửa user admin!");
        
        // Check if user exists
        User existing = userDAO.getUserById(user.getUserId());
        if (existing == null) {
            throw new IllegalArgumentException("User not found");
        }
        
        validateUser(user);
        
        // Check if new username conflicts with another user
        User usernameCheck = userDAO.getUserByUsername(user.getUsername());
        if (usernameCheck != null && !usernameCheck.getUserId().equals(user.getUserId())) {
            throw new IllegalArgumentException("Username already exists");
        }
        
        // Check if new email conflicts with another user
        if (user.getEmail() != null) {
            User emailCheck = userDAO.getUserByEmail(user.getEmail());
            if (emailCheck != null && !emailCheck.getUserId().equals(user.getUserId())) {
                throw new IllegalArgumentException("Email already exists");
            }
        }
        
        return userDAO.updateUser(user);
    }
    
    /**
     * Update user password
     * @param userId User ID
     * @param oldPassword Old plain text password
     * @param newPassword New plain text password
     * @return true if successful, false otherwise
     */
    public boolean updatePassword(int userId, String oldPassword, String newPassword) {
        // Get user
        User user = userDAO.getUserById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }
        
        // Verify old password
        if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Old password is incorrect");
        }
        
        // Validate new password
        validatePassword(newPassword);
        
        // Hash new password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        
        return userDAO.updatePassword(userId, hashedPassword);
    }
    
    /**
     * Reset user password (Admin function)
     * @param userId User ID
     * @param newPassword New plain text password
     * @return true if successful, false otherwise
     */
    public boolean resetPassword(int userId, String newPassword) {
        // Validate new password
        validatePassword(newPassword);
        
        // Hash new password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        
        return userDAO.updatePassword(userId, hashedPassword);
    }
    
    /**
     * Delete a user
     * @param userId User ID
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(int userId) {
    if (userId == 1) throw new IllegalArgumentException("Không thể xoá user admin!");
    User user = userDAO.getUserById(userId);
    if (user == null) throw new IllegalArgumentException("User not found");
    if ("ADMIN".equals(user.getRole())) {
        List<User> admins = userDAO.getUsersByRole("ADMIN");
        if (admins.size() <= 1) throw new IllegalArgumentException("Không thể xoá admin cuối cùng!");
    }
    return userDAO.deleteUser(userId);
}
    
    /**
     * Activate or deactivate a user
     * @param userId User ID
     * @param isActive Active status
     * @return true if successful, false otherwise
     */
    public boolean setUserActive(int userId, boolean isActive) {
        return userDAO.setUserActive(userId, isActive);
    }
    
    /**
     * Get users by role
     * @param role User role (ADMIN, STAFF)
     * @return List of users with the specified role
     */
    public List<User> getUsersByRole(String role) {
        return userDAO.getUsersByRole(role);
    }
    
    /**
     * Get users with filter
     * @param q Search query
     * @param role User role
     * @param active Active status
     * @return List of users with the specified filter
     */
    public List<User> getUsersWithFilter(String q, String role, String active) {
        return userDAO.getUsersWithFilter(q, role, active);
    }
    
    /**
     * Validate user data
     * @param user User to validate
     * @throws IllegalArgumentException if validation fails
     */
    private void validateUser(User user) {
        // Username
        if (ValidationUtil.isEmpty(user.getUsername())) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        
        if (!ValidationUtil.isValidLength(user.getUsername(), 3, 50)) {
            throw new IllegalArgumentException("Username must be between 3 and 50 characters");
        }
        
        // Full name
        if (ValidationUtil.isEmpty(user.getFullName())) {
            throw new IllegalArgumentException("Full name cannot be empty");
        }
        
        if (!ValidationUtil.isValidLength(user.getFullName(), 2, 100)) {
            throw new IllegalArgumentException("Full name must be between 2 and 100 characters");
        }
        
        // Email
        if (user.getEmail() != null && !ValidationUtil.isValidEmail(user.getEmail())) {
            throw new IllegalArgumentException("Invalid email format");
        }
        
        // Role
        if (ValidationUtil.isEmpty(user.getRole())) {
            throw new IllegalArgumentException("Role cannot be empty");
        }
        
        if (!"ADMIN".equals(user.getRole()) && !"STAFF".equals(user.getRole())) {
            if (!"USER".equals(user.getRole())) {
                throw new IllegalArgumentException("Invalid role. Must be ADMIN, STAFF, or USER");
            }
        }
    }
    
    /**
     * Validate password
     * @param password Password to validate
     * @throws IllegalArgumentException if validation fails
     */
    private void validatePassword(String password) {
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
    }
}
