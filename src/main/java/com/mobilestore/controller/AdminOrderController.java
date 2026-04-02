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
        
        if ("confirm".equals(action)) {
            confirmOrder(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    /**
     * Confirm order
     */
    private void confirmOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = orderService.confirmOrder(orderId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?success=Đã xác nhận đơn hàng thành công!");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=Không thể xác nhận đơn hàng này!");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=ID đơn hàng không hợp lệ!");
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
        // Đã loại bỏ hàm updateOrderStatus khỏi OrderService. Nếu cần cập nhật trạng thái, hãy bổ sung lại logic phù hợp.
    }
    
    /**
     * Update payment status
     */
    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        // Đã loại bỏ hàm updatePaymentStatus khỏi OrderService. Nếu cần cập nhật trạng thái thanh toán, hãy bổ sung lại logic phù hợp.
    }
}
