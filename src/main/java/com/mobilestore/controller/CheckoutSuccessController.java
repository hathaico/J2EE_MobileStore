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
            request.setAttribute("error", "Không tìm thấy mã đơn hàng");
            request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp").forward(request, response);
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderService.getOrderById(orderId);
            
            if (order == null) {
                request.setAttribute("error", "Đơn hàng không tồn tại hoặc đã bị xóa");
                request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp").forward(request, response);
                return;
            }
            
            // Set order in request
            request.setAttribute("order", order);
            
            // Forward to success page
            request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã đơn hàng không hợp lệ");
            try {
                request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            try {
                request.getRequestDispatcher("/WEB-INF/views/checkout/success.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
}
