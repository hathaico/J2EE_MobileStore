package com.mobilestore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.mobilestore.service.CartService;

/**
 * Logout Controller
 * Handles user logout and session invalidation
 */
@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    private final CartService cartService = new CartService();
    
    /**
     * Handle logout
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            cartService.saveCustomerCart(session);
            session.invalidate();
        }

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("logoutSuccess", Boolean.TRUE);
        
        // Redirect to home page with logout message
        response.sendRedirect(request.getContextPath() + "/");
    }
    
    /**
     * Also support POST method for logout
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
