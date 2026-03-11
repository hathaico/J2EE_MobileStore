package com.mobilestore.controller;

import com.mobilestore.model.User;
import com.mobilestore.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Login Controller
 * Handles user authentication
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    /**
     * Show login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Already logged in, redirect to home or admin
            User user = (User) session.getAttribute("user");
            if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }
        
        // Show login page
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    /**
     * Process login
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập username và password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        User user = userService.authenticate(username.trim(), password);
        
        if (user != null) {
            // Login successful
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            // Remember me functionality
            if ("on".equals(remember)) {
                // Extend session to 7 days if remember me is checked
                session.setMaxInactiveInterval(7 * 24 * 60 * 60);
            }
            
            // Redirect based on role
            if ("ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                // Check if there's a redirect URL
                String redirectUrl = request.getParameter("redirect");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            }
        } else {
            // Login failed
            request.setAttribute("error", "Username hoặc password không đúng");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
