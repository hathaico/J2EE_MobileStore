package com.mobilestore.service;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.*;
import com.mobilestore.util.ValidationUtil;

import java.util.List;

/**
 * Order Service
 * Business logic for Order operations
 */
public class OrderService {
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    
    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get all orders
     * @return List of all orders
     */
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }
    
    /**
     * Get order by ID
     * @param orderId Order ID
     * @return Order object or null if not found
     */
    public Order getOrderById(int orderId) {
        return orderDAO.getOrderById(orderId);
    }
    
    /**
     * Get orders by customer ID
     * @param customerId Customer ID
     * @return List of customer's orders
     */
    public List<Order> getOrdersByCustomerId(int customerId) {
        return orderDAO.getOrdersByCustomerId(customerId);
    }
    
    /**
     * Get orders by status
     * @param status Order status
     * @return List of orders with the specified status
     */
    public List<Order> getOrdersByStatus(String status) {
        return orderDAO.getOrdersByStatus(status);
    }
    
    /**
     * Create order from cart
     * @param cart Shopping cart
     * @param customerName Customer name
     * @param customerPhone Customer phone
     * @param customerEmail Customer email (optional)
     * @param shippingAddress Shipping address
     * @param paymentMethod Payment method
     * @param notes Order notes (optional)
     * @param customerId Customer ID (optional, null for guest)
     * @return Order ID if successful, -1 if failed
     */
    public int createOrder(Cart cart, String customerName, String customerPhone,
                          String customerEmail, String shippingAddress,
                          String paymentMethod, String notes, Integer customerId) {
        
        // Validate input
        validateOrderInput(customerName, customerPhone, customerEmail, shippingAddress, paymentMethod);
        
        // Validate cart
        if (cart == null || cart.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }
        
        // Check stock availability for all items
        for (CartItem cartItem : cart.getItems()) {
            Product product = productDAO.getProductById(cartItem.getProduct().getProductId());
            
            if (product == null) {
                throw new IllegalArgumentException("Sản phẩm không tồn tại: " + 
                                                 cartItem.getProduct().getProductName());
            }
            
            if (product.getStockQuantity() < cartItem.getQuantity()) {
                throw new IllegalArgumentException("Sản phẩm '" + product.getProductName() + 
                                                 "' không đủ số lượng. Còn lại: " + 
                                                 product.getStockQuantity());
            }
        }
        
        // Create order object
        Order order = new Order();
        order.setCustomerId(customerId);
        order.setCustomerName(customerName);
        order.setCustomerPhone(customerPhone);
        order.setCustomerEmail(customerEmail);
        order.setShippingAddress(shippingAddress);
        order.setTotalAmount(cart.getTotal());
        order.setStatus("PENDING");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("UNPAID");
        order.setNotes(notes);
        
        // Add order items
        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(cartItem.getProduct().getProductId());
            orderItem.setProductName(cartItem.getProduct().getProductName());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setSubtotal(cartItem.getTotal());
            order.addOrderItem(orderItem);
        }
        
        // Create order in database
        int orderId = orderDAO.createOrder(order);
        
        if (orderId > 0) {
            // Update stock quantities
            for (CartItem cartItem : cart.getItems()) {
                Product product = productDAO.getProductById(cartItem.getProduct().getProductId());
                int newStock = product.getStockQuantity() - cartItem.getQuantity();
                productDAO.updateStock(product.getProductId(), newStock);
            }
        }
        
        return orderId;
    }
    
    /**
     * Update order status
     * @param orderId Order ID
     * @param status New status
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String status) {
        // Validate status
        if (!isValidStatus(status)) {
            throw new IllegalArgumentException("Invalid order status: " + status);
        }
        
        return orderDAO.updateOrderStatus(orderId, status);
    }
    
    /**
     * Update payment status
     * @param orderId Order ID
     * @param paymentStatus New payment status
     * @return true if successful, false otherwise
     */
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        // Validate payment status
        if (!isValidPaymentStatus(paymentStatus)) {
            throw new IllegalArgumentException("Invalid payment status: " + paymentStatus);
        }
        
        return orderDAO.updatePaymentStatus(orderId, paymentStatus);
    }
    
    /**
     * Cancel order
     * @param orderId Order ID
     * @return true if successful, false otherwise
     */
    public boolean cancelOrder(int orderId) {
        Order order = orderDAO.getOrderById(orderId);
        
        if (order == null) {
            throw new IllegalArgumentException("Order not found");
        }
        
        // Only allow cancellation for PENDING or CONFIRMED orders
        if (!"PENDING".equals(order.getStatus()) && !"CONFIRMED".equals(order.getStatus())) {
            throw new IllegalArgumentException("Cannot cancel order with status: " + 
                                             order.getStatus());
        }
        
        // Restore stock quantities
        for (OrderItem item : order.getOrderItems()) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                int newStock = product.getStockQuantity() + item.getQuantity();
                productDAO.updateStock(product.getProductId(), newStock);
            }
        }
        
        // Update order status to CANCELLED
        return orderDAO.updateOrderStatus(orderId, "CANCELLED");
    }
    
    /**
     * Delete order
     * @param orderId Order ID
     * @return true if successful, false otherwise
     */
    public boolean deleteOrder(int orderId) {
        return orderDAO.deleteOrder(orderId);
    }
    
    /**
     * Validate order input
     */
    private void validateOrderInput(String customerName, String customerPhone,
                                   String customerEmail, String shippingAddress,
                                   String paymentMethod) {
        // Customer name
        if (ValidationUtil.isEmpty(customerName)) {
            throw new IllegalArgumentException("Tên khách hàng không được để trống");
        }
        
        if (!ValidationUtil.isValidLength(customerName, 2, 100)) {
            throw new IllegalArgumentException("Tên khách hàng phải từ 2-100 ký tự");
        }
        
        // Customer phone
        if (ValidationUtil.isEmpty(customerPhone)) {
            throw new IllegalArgumentException("Số điện thoại không được để trống");
        }
        
        if (!ValidationUtil.isValidPhone(customerPhone)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ");
        }
        
        // Customer email (optional)
        if (!ValidationUtil.isEmpty(customerEmail) && !ValidationUtil.isValidEmail(customerEmail)) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }
        
        // Shipping address
        if (ValidationUtil.isEmpty(shippingAddress)) {
            throw new IllegalArgumentException("Địa chỉ giao hàng không được để trống");
        }
        
        if (!ValidationUtil.isValidLength(shippingAddress, 10, 500)) {
            throw new IllegalArgumentException("Địa chỉ giao hàng phải từ 10-500 ký tự");
        }
        
        // Payment method
        if (ValidationUtil.isEmpty(paymentMethod)) {
            throw new IllegalArgumentException("Phương thức thanh toán không được để trống");
        }
        
        if (!isValidPaymentMethod(paymentMethod)) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }
    }
    
    /**
     * Check if status is valid
     */
    private boolean isValidStatus(String status) {
        return "PENDING".equals(status) || 
               "CONFIRMED".equals(status) || 
               "SHIPPING".equals(status) || 
               "DELIVERED".equals(status) || 
               "CANCELLED".equals(status);
    }
    
    /**
     * Check if payment status is valid
     */
    private boolean isValidPaymentStatus(String paymentStatus) {
        return "UNPAID".equals(paymentStatus) || "PAID".equals(paymentStatus);
    }
    
    /**
     * Check if payment method is valid
     */
    private boolean isValidPaymentMethod(String paymentMethod) {
        return "COD".equals(paymentMethod) || 
               "BANK_TRANSFER".equals(paymentMethod) || 
               "CREDIT_CARD".equals(paymentMethod);
    }
}
