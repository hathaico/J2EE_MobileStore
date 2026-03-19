package com.mobilestore.controller;

import com.mobilestore.model.Cart;
import com.mobilestore.service.CartService;
import com.mobilestore.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Checkout Controller
 * Handles checkout process
 */
@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private CartService cartService;
    private OrderService orderService;
    private com.mobilestore.service.VoucherService voucherService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        orderService = new OrderService();
        voucherService = new com.mobilestore.service.VoucherService();
    }
    
    /**
     * Show checkout page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Refresh cart with latest product information
        cartService.refreshCart(session);
        
        // Get cart
        Cart cart = cartService.getCart(session);
        
        // Check if cart is empty
        if (cart.isEmpty()) {
            request.setAttribute("error", "Giỏ hàng trống. Vui lòng thêm sản phẩm trước khi thanh toán.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Validate cart items
        if (!cart.isValid()) {
            request.setAttribute("error", "Một số sản phẩm trong giỏ hàng không còn đủ số lượng. Vui lòng kiểm tra lại.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Set cart in request
        request.setAttribute("cart", cart);
        
        // Forward to checkout page
        request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp").forward(request, response);
    }
    
    /**
     * Process checkout
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get cart
        Cart cart = cartService.getCart(session);
        
        // Check if cart is empty
        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        try {
            // Get form parameters
            String shippingAddress = request.getParameter("shippingAddress");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            // Lấy voucherCode và discount từ form nếu có
            String voucherCode = request.getParameter("voucherCode");
            String voucherDiscountStr = request.getParameter("voucherDiscount");
            java.math.BigDecimal discount = java.math.BigDecimal.ZERO;
            if (voucherDiscountStr != null && !voucherDiscountStr.isEmpty()) {
                try {
                    discount = new java.math.BigDecimal(voucherDiscountStr);
                } catch (NumberFormatException e) {
                    discount = java.math.BigDecimal.ZERO;
                }
            }

            // Nếu có voucherCode thì lấy voucherId từ DB, nếu không thì lấy từ session (giữ tương thích)
            Integer voucherId = null;
            if (voucherCode != null && !voucherCode.isEmpty()) {
                try {
                    com.mobilestore.model.Voucher voucher = voucherService.getVoucherByCode(voucherCode);
                    if (voucher != null) voucherId = voucher.getVoucherId();
                } catch (Exception ex) {
                    voucherId = null;
                }
            } else {
                voucherId = (Integer) session.getAttribute("appliedVoucherId");
            }

            // Create order (truyền thêm voucherId và tổng tiền đã giảm)
            int orderId = orderService.createOrder(
                cart,
                shippingAddress,
                paymentMethod,
                notes,
                null, // Guest checkout, no customer ID
                voucherId,
                discount
            );

            if (orderId > 0) {
                // Clear cart và voucher
                cartService.clearCart(session);
                session.removeAttribute("appliedVoucherId");

                // Redirect to order success page
                response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại.");
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp")
                       .forward(request, response);
            }

        } catch (IllegalArgumentException e) {
            // Validation error
            request.setAttribute("error", e.getMessage());
            request.setAttribute("cart", cart);
            
            // Preserve form data
            request.setAttribute("customerName", request.getParameter("customerName"));
            request.setAttribute("customerPhone", request.getParameter("customerPhone"));
            request.setAttribute("customerEmail", request.getParameter("customerEmail"));
            request.setAttribute("shippingAddress", request.getParameter("shippingAddress"));
            request.setAttribute("paymentMethod", request.getParameter("paymentMethod"));
            request.setAttribute("notes", request.getParameter("notes"));
            
            request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp")
                   .forward(request, response);
        }
    }
}
