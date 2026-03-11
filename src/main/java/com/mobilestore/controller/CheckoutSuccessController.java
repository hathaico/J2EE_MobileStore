package com.mobilestore.controller;

import com.mobilestore.model.Order;
import com.mobilestore.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Checkout Success Controller
 * Displays order confirmation
 */
@WebServlet("/checkout/success")
public class CheckoutSuccessController extends HttpServlet {
    private OrderService orderService;
    
    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }
    
    /**
     * Show order confirmation page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderService.getOrderById(orderId);
            
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            
            // Set order in request
            request.setAttribute("order", order);
            
            // Forward to success page
            request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
