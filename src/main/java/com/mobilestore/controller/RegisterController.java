package com.mobilestore.controller;

import com.mobilestore.model.User;
import com.mobilestore.service.UserService;
import com.mobilestore.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Register Controller
 * Handles customer registration
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    /**
     * Show registration page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    /**
     * Process registration
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        
        // Validate input
        if (ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(password) || 
            ValidationUtil.isEmpty(fullName) || ValidationUtil.isEmpty(email)) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Validate username (alphanumeric, 3-20 characters)
        if (!username.matches("^[a-zA-Z0-9]{3,20}$")) {
            request.setAttribute("error", "Username phải từ 3-20 ký tự và chỉ chứa chữ cái, số");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password phải có ít nhất 6 ký tự");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check password confirmation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận password không khớp");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists
        if (userService.getUserByUsername(username) != null) {
            request.setAttribute("error", "Username đã tồn tại");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userService.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email đã được sử dụng");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password); // Will be hashed in UserService
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setRole("CUSTOMER"); // Default role for registration
        newUser.setIsActive(true);
        
        // Register user
        boolean success = userService.registerUser(newUser);
        
        if (success) {
            // Registration successful - redirect to login with success message
            request.getSession().setAttribute("successMessage", 
                "Đăng ký thành công! Vui lòng đăng nhập với tài khoản của bạn.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Registration failed
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            setFormAttributes(request, username, fullName, email);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Helper method to set form attributes
     */
    private void setFormAttributes(HttpServletRequest request, String username, 
                                  String fullName, String email) {
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
    }
}
