package com.mobilestore.controller;

import com.mobilestore.model.Order;
import com.mobilestore.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Admin Order Controller
 * Handles order management for admin
 */
@WebServlet("/admin/orders")
public class AdminOrderController extends HttpServlet {
    private OrderService orderService;
    
    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }
    
    /**
     * Handle GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("detail".equals(action)) {
            showOrderDetail(request, response);
        } else {
            listOrders(request, response);
        }
    }
    
    /**
     * Handle POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updateOrderStatus(request, response);
        } else if ("updatePayment".equals(action)) {
            updatePaymentStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * List all orders
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        
        List<Order> orders;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            orders = orderService.getOrdersByStatus(statusFilter);
        } else {
            orders = orderService.getAllOrders();
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("statusFilter", statusFilter);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/order/list.jsp")
               .forward(request, response);
    }
    
    /**
     * Show order detail
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderService.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng");
                listOrders(request, response);
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/WEB-INF/views/admin/order/detail.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid order ID");
            listOrders(request, response);
        }
    }
    
    /**
     * Update order status
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            
            boolean success = orderService.updateOrderStatus(orderId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                                    "/admin/orders?success=Đã cập nhật trạng thái đơn hàng");
            } else {
                response.sendRedirect(request.getContextPath() + 
                                    "/admin/orders?error=Không thể cập nhật trạng thái");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                "/admin/orders?error=" + e.getMessage());
        }
    }
    
    /**
     * Update payment status
     */
    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String paymentStatus = request.getParameter("paymentStatus");
            
            boolean success = orderService.updatePaymentStatus(orderId, paymentStatus);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                                    "/admin/orders?success=Đã cập nhật trạng thái thanh toán");
            } else {
                response.sendRedirect(request.getContextPath() + 
                                    "/admin/orders?error=Không thể cập nhật trạng thái thanh toán");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                "/admin/orders?error=" + e.getMessage());
        }
    }
}
