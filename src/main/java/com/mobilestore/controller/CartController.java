package com.mobilestore.controller;

import com.google.gson.Gson;
import com.mobilestore.model.Cart;
import com.mobilestore.service.CartService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Cart Controller
 * Handles shopping cart operations
 */
@WebServlet("/cart")
public class CartController extends HttpServlet {
    private CartService cartService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        gson = new Gson();
    }
    
    /**
     * Show cart page or handle AJAX requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("count".equals(action)) {
            // AJAX request for cart count
            handleGetCartCount(request, response);
        } else if ("data".equals(action)) {
            // AJAX request for cart data
            handleGetCartData(request, response);
        } else {
            // Show cart page
            showCartPage(request, response);
        }
    }
    
    /**
     * Process cart operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            handleAddToCart(request, response);
        } else if ("update".equals(action)) {
            handleUpdateCart(request, response);
        } else if ("remove".equals(action)) {
            handleRemoveFromCart(request, response);
        } else if ("clear".equals(action)) {
            handleClearCart(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * Show cart page
     */
    private void showCartPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Refresh cart with latest product information
        cartService.refreshCart(session);
        
        // Get cart
        Cart cart = cartService.getCart(session);
        request.setAttribute("cart", cart);
        
        // Forward to cart view
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }
    
    /**
     * Handle add to cart
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get parameters
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Add to cart
            HttpSession session = request.getSession();
            cartService.addToCart(session, productId, quantity);
            
            // Get updated cart count
            int cartCount = cartService.getCartItemCount(session);
            
            result.put("success", true);
            result.put("message", "Đã thêm sản phẩm vào giỏ hàng");
            result.put("cartCount", cartCount);
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid input");
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Handle update cart item
     */
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get parameters
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Update cart
            HttpSession session = request.getSession();
            cartService.updateCartItem(session, productId, quantity);
            
            // Get updated cart
            Cart cart = cartService.getCart(session);
            
            result.put("success", true);
            result.put("message", "Đã cập nhật giỏ hàng");
            result.put("cartCount", cart.getItemCount());
            result.put("total", cart.getTotal());
            result.put("formattedTotal", cart.getFormattedTotal());
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid input");
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Handle remove from cart
     */
    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get parameters
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            // Remove from cart
            HttpSession session = request.getSession();
            cartService.removeFromCart(session, productId);
            
            // Get updated cart
            Cart cart = cartService.getCart(session);
            
            result.put("success", true);
            result.put("message", "Đã xóa sản phẩm khỏi giỏ hàng");
            result.put("cartCount", cart.getItemCount());
            result.put("total", cart.getTotal());
            result.put("formattedTotal", cart.getFormattedTotal());
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid input");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Handle clear cart
     */
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            HttpSession session = request.getSession();
            cartService.clearCart(session);
            
            result.put("success", true);
            result.put("message", "Đã xóa tất cả sản phẩm khỏi giỏ hàng");
            result.put("cartCount", 0);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Handle get cart count (AJAX)
     */
    private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            HttpSession session = request.getSession();
            int cartCount = cartService.getCartItemCount(session);
            
            result.put("success", true);
            result.put("cartCount", cartCount);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Handle get cart data (AJAX)
     */
    private void handleGetCartData(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            HttpSession session = request.getSession();
            Cart cart = cartService.getCart(session);
            
            result.put("success", true);
            result.put("cart", cart);
            result.put("items", cart.getItems());
            result.put("total", cart.getTotal());
            result.put("formattedTotal", cart.getFormattedTotal());
            result.put("itemCount", cart.getItemCount());
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Send JSON response
        sendJsonResponse(response, result);
    }
    
    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
}
