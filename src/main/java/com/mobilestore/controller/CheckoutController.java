package com.mobilestore.controller;

import com.mobilestore.model.Cart;
import com.mobilestore.model.Customer;
import com.mobilestore.model.User;
import com.mobilestore.dao.CustomerDAO;
import com.mobilestore.service.CartService;
import com.mobilestore.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.InetAddress;

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

        String errorCode = request.getParameter("error");
        if ("vnpay_not_configured".equals(errorCode)) {
            request.setAttribute("error", "Chưa cấu hình VNPay. Vui lòng thiết lập VNPAY_TMN_CODE và VNPAY_HASH_SECRET.");
        } else if ("momo_not_configured".equals(errorCode)) {
            request.setAttribute("error", "Chưa cấu hình MoMo. Vui lòng thiết lập MOMO_PARTNER_CODE, MOMO_ACCESS_KEY và MOMO_SECRET_KEY.");
        } else if ("missing_order".equals(errorCode)) {
            request.setAttribute("error", "Không tìm thấy thông tin đơn hàng để thanh toán.");
        } else if ("invalid_order".equals(errorCode) || "order_not_found".equals(errorCode)) {
            request.setAttribute("error", "Đơn hàng không hợp lệ hoặc không tồn tại.");
        } else if ("invalid_vnpay_response".equals(errorCode)) {
            request.setAttribute("error", "Phản hồi VNPay không hợp lệ. Vui lòng thử lại.");
        } else if ("invalid_momo_response".equals(errorCode)) {
            request.setAttribute("error", "Phản hồi MoMo không hợp lệ. Vui lòng thử lại.");
        }
        
        // Refresh cart with latest product information
        cartService.refreshCart(session);
        
        // Get cart
        Cart cart = cartService.getCart(session);
        
        // Check if cart is empty
        if (cart.isEmpty()) {
            if (request.getAttribute("error") == null) {
                request.setAttribute("error", "Giỏ hàng trống. Vui lòng thêm sản phẩm trước khi thanh toán.");
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Validate cart items
        if (!cart.isValid()) {
            if (request.getAttribute("error") == null) {
                request.setAttribute("error", "Một số sản phẩm trong giỏ hàng không còn đủ số lượng. Vui lòng kiểm tra lại.");
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Set cart in request
        request.setAttribute("cart", cart);
        request.setAttribute("vnpayDevModeActive", isSafeDevModeRequest(request));
        
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
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            String customerEmail = request.getParameter("customerEmail");
            String shippingAddress = request.getParameter("shippingAddress");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            if (customerName == null || customerName.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng nhập họ và tên.");
            }
            if (customerPhone == null || !customerPhone.trim().matches("^[0-9]{10,11}$")) {
                throw new IllegalArgumentException("Số điện thoại phải có 10-11 chữ số.");
            }

            Integer customerId = resolveOrCreateCustomerId(
                    session,
                    customerName.trim(),
                    customerPhone.trim(),
                    customerEmail,
                    shippingAddress
            );
            if (customerId == null) {
                throw new IllegalArgumentException("Không thể tạo thông tin khách hàng cho đơn hàng.");
            }

            // Redirect-based payment flow: card data is entered on VNPay, not on our website.

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
                customerId,
                voucherId,
                discount
            );

            if (orderId > 0) {
                if ("CREDIT_CARD".equals(paymentMethod)) {
                    // Keep cart until VNPay callback confirms success.
                    response.sendRedirect(request.getContextPath() + "/payment/vnpay/create?orderId=" + orderId);
                    return;
                }

                if ("MOMO".equals(paymentMethod)) {
                    // Keep cart until MoMo callback confirms success.
                    response.sendRedirect(request.getContextPath() + "/payment/momo/create?orderId=" + orderId);
                    return;
                }

                // Clear cart và voucher cho các phương thức không qua cổng thẻ
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
            request.setAttribute("vnpayDevModeActive", isSafeDevModeRequest(request));
            
            request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.setAttribute("vnpayDevModeActive", isSafeDevModeRequest(request));
            request.getRequestDispatcher("/WEB-INF/views/checkout/checkout.jsp")
                   .forward(request, response);
        }
    }

    private boolean isSafeDevModeRequest(HttpServletRequest request) {
        if (!com.mobilestore.util.VnPayUtil.isDevMode() || com.mobilestore.util.VnPayUtil.isConfigured()) {
            return false;
        }
        String remoteAddr = request.getRemoteAddr();
        if (remoteAddr == null || remoteAddr.trim().isEmpty()) {
            return false;
        }
        try {
            InetAddress address = InetAddress.getByName(remoteAddr);
            return address.isLoopbackAddress() || address.isSiteLocalAddress();
        } catch (Exception ex) {
            return false;
        }
    }

    private Integer resolveOrCreateCustomerId(HttpSession session,
                                              String customerName,
                                              String customerPhone,
                                              String customerEmail,
                                              String shippingAddress) {
        CustomerDAO customerDAO = new CustomerDAO();

        String normalizedEmail = customerEmail == null ? null : customerEmail.trim();
        if (normalizedEmail != null && normalizedEmail.isEmpty()) {
            normalizedEmail = null;
        }

        Object userObj = session.getAttribute("user");
        if (userObj instanceof User) {
            User user = (User) userObj;
            if (user.getUserId() != null) {
                Customer byUser = customerDAO.getCustomerByUserId(user.getUserId());
                if (byUser != null) {
                    return byUser.getCustomerId();
                }

                String userEmail = (normalizedEmail != null) ? normalizedEmail : user.getEmail();
                if (userEmail != null && !userEmail.trim().isEmpty()) {
                    Customer byEmail = customerDAO.getCustomerByEmail(userEmail.trim());
                    if (byEmail != null) {
                        if (byEmail.getUserId() == null || !byEmail.getUserId().equals(user.getUserId())) {
                            customerDAO.updateCustomerUserId(byEmail.getCustomerId(), user.getUserId());
                        }
                        return byEmail.getCustomerId();
                    }
                    normalizedEmail = userEmail.trim();
                }

                Customer newCustomer = new Customer();
                newCustomer.setFullName(customerName);
                newCustomer.setPhone(customerPhone);
                newCustomer.setEmail(normalizedEmail);
                newCustomer.setAddress(shippingAddress);
                newCustomer.setUserId(user.getUserId());
                int createdId = customerDAO.createCustomer(newCustomer);
                return createdId > 0 ? createdId : null;
            }
        }

        if (normalizedEmail != null) {
            Customer byEmail = customerDAO.getCustomerByEmail(normalizedEmail);
            if (byEmail != null) {
                return byEmail.getCustomerId();
            }
        }

        Customer guestCustomer = new Customer();
        guestCustomer.setFullName(customerName);
        guestCustomer.setPhone(customerPhone);
        guestCustomer.setEmail(normalizedEmail);
        guestCustomer.setAddress(shippingAddress);
        int guestId = customerDAO.createCustomer(guestCustomer);
        return guestId > 0 ? guestId : null;
    }
}
