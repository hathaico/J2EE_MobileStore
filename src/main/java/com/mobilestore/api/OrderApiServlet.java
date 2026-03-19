package com.mobilestore.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mobilestore.model.Order;
import com.mobilestore.model.Cart;
import com.mobilestore.service.OrderService;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/api/orders")
public class OrderApiServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
            new com.google.gson.JsonPrimitive(src.toString())
        )
        .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Order> orders = orderService.getAllOrders();
            resp.getWriter().write(gson.toJson(orders));
        } else {
            try {
                int orderId = Integer.parseInt(pathInfo.substring(1));
                Order order = orderService.getOrderById(orderId);
                if (order != null) {
                    resp.getWriter().write(gson.toJson(order));
                } else {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\":\"Order not found\"}");
                }
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Invalid order ID\"}");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Cart is empty\"}");
            return;
        }
        try {
            com.google.gson.JsonObject json = gson.fromJson(req.getReader(), com.google.gson.JsonObject.class);
            String shippingAddress = json.has("shippingAddress") ? json.get("shippingAddress").getAsString() : "";
            String paymentMethod = json.has("paymentMethod") ? json.get("paymentMethod").getAsString() : "";
            String notes = json.has("notes") ? json.get("notes").getAsString() : "";
            Integer customerId = null;
            if (session.getAttribute("user") != null) {
                customerId = ((com.mobilestore.model.User) session.getAttribute("user")).getUserId();
            }
            // Lấy voucherId và discount từ session nếu có
            Integer voucherId = (Integer) session.getAttribute("appliedVoucherId");
            java.math.BigDecimal discount = java.math.BigDecimal.ZERO;
            if (voucherId != null) {
                com.mobilestore.model.Voucher voucher = new com.mobilestore.dao.VoucherDAO().getVoucherById(voucherId);
                if (voucher != null) {
                    java.math.BigDecimal subtotal = cart.getTotal();
                    if ("percent".equalsIgnoreCase(voucher.getDiscountType())) {
                        discount = subtotal.multiply(voucher.getDiscountValue().divide(new java.math.BigDecimal(100)));
                        if (voucher.getMaxDiscount() != null && discount.compareTo(voucher.getMaxDiscount()) > 0) {
                            discount = voucher.getMaxDiscount();
                        }
                    } else if ("amount".equalsIgnoreCase(voucher.getDiscountType())) {
                        discount = voucher.getDiscountValue();
                    }
                    if (discount.compareTo(subtotal) > 0) discount = subtotal;
                }
            }
            int createdId = orderService.createOrder(cart, shippingAddress, paymentMethod, notes, customerId, voucherId, discount);
            if (createdId > 0) {
                resp.getWriter().write("{\"orderId\":" + createdId + "}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Failed to create order\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid request\"}");
        }
    }
}
