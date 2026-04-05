package com.mobilestore.service;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.model.*;

import java.util.List;

/**
 * Order Service
 * Business logic for Order operations
 */
public class OrderService {
            public OrderService() {
                this.orderDAO = new OrderDAO();
            }
            /**
             * Create order from cart
             * @param cart Shopping cart
             * @param shippingAddress Shipping address
             * @param paymentMethod Payment method
             * @param notes Order notes (optional)
             * @param customerId Customer ID (optional, null for guest)
             * @return Order ID if successful, -1 if failed
             */
    public int createOrder(Cart cart, String shippingAddress, String paymentMethod, String notes, Integer customerId, Integer voucherId, java.math.BigDecimal discount) {
        if (cart == null) {
            throw new IllegalArgumentException("Giỏ hàng không được null");
        }
        if (cart.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }
        if (!cart.isValid()) {
            throw new IllegalArgumentException("Giỏ hàng có sản phẩm vượt quá số lượng tồn kho");
        }
        if (!isValidPaymentMethod(paymentMethod)) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }

        // Chuẩn bị đối tượng Order
        com.mobilestore.model.Order order = new com.mobilestore.model.Order();
        order.setCustomerId(customerId);
        order.setShippingAddress(shippingAddress);
        // Áp dụng giảm giá nếu có
        java.math.BigDecimal total = cart.getTotal();
        if (discount != null && discount.compareTo(java.math.BigDecimal.ZERO) > 0) {
            total = total.subtract(discount);
            if (total.compareTo(java.math.BigDecimal.ZERO) < 0) total = java.math.BigDecimal.ZERO;
        }
        order.setTotalAmount(total);
        order.setVoucherId(voucherId);
        order.setStatus("PENDING");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("UNPAID");
        order.setNotes(notes);

        // Chuyển CartItem thành OrderItem
        java.util.List<com.mobilestore.model.OrderItem> orderItems = new java.util.ArrayList<>();
        for (com.mobilestore.model.CartItem cartItem : cart.getItems()) {
            com.mobilestore.model.Product product = cartItem.getProduct();
            com.mobilestore.model.OrderItem orderItem = new com.mobilestore.model.OrderItem();
            orderItem.setProductId(product.getProductId());
            orderItem.setProductName(product.getProductName());
            orderItem.setPrice(product.getPrice());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setSubtotal(product.getPrice().multiply(new java.math.BigDecimal(cartItem.getQuantity())));
            orderItem.setSelectedColor(cartItem.getSelectedColor());
            orderItem.setSelectedCapacity(cartItem.getSelectedCapacity());
            orderItems.add(orderItem);
        }
        order.setOrderItems(orderItems);

        // Lưu đơn hàng vào DB
        int orderId = orderDAO.createOrder(order);
        return orderId;
    }
        /**
         * Get all orders
         * @return List of all orders
         */
        public List<Order> getAllOrders() {
            return orderDAO.getAllOrders();
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
         * Get order by ID
         * @param orderId Order ID
         * @return Order object or null if not found
         */
        public Order getOrderById(int orderId) {
            return orderDAO.getOrderById(orderId);
        }
    private final OrderDAO orderDAO;
    
        
    
    /**
     * Update order status
     * @param orderId Order ID
     * @param status New status
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String status) {
        if (!isValidStatus(status)) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ: " + status);
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
        if (!isValidPaymentStatus(paymentStatus)) {
            throw new IllegalArgumentException("Trạng thái thanh toán không hợp lệ: " + paymentStatus);
        }
        return orderDAO.updatePaymentStatus(orderId, paymentStatus);
    }

    /**
     * Confirm order (change status from PENDING to CONFIRMED)
     * @param orderId Order ID
     * @return true if successful, false otherwise
     */
    public boolean confirmOrder(int orderId) {
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            return false;
        }
        if (!"PENDING".equals(order.getStatus())) {
            return false; // Chỉ có thể xác nhận đơn hàng ở trạng thái PENDING
        }
        return updateOrderStatus(orderId, "CONFIRMED");
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
         return "CASH".equals(paymentMethod) ||
             "BANK_TRANSFER".equals(paymentMethod) || 
             "MOMO".equals(paymentMethod) ||
             "CREDIT_CARD".equals(paymentMethod);
    }
}
