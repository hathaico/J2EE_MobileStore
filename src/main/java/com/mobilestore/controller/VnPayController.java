package com.mobilestore.controller;

import com.mobilestore.model.Order;
import com.mobilestore.service.CartService;
import com.mobilestore.service.OrderService;
import com.mobilestore.util.VnPayUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.InetAddress;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * VNPay controller.
 * /payment/vnpay/create: build payment URL and redirect to VNPay
 * /payment/vnpay/return: handle payment callback
 */
@WebServlet("/payment/vnpay/*")
public class VnPayController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || "/create".equals(pathInfo)) {
            handleCreatePayment(request, response);
            return;
        }

        if ("/return".equals(pathInfo)) {
            handleReturn(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void handleCreatePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=missing_order");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=invalid_order");
            return;
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=order_not_found");
            return;
        }

        if (!VnPayUtil.isConfigured()) {
            if (VnPayUtil.isDevMode() && isLocalRequest(request)) {
                completeMockSuccess(orderId, request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/checkout?error=vnpay_not_configured");
            return;
        }

        String returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                + request.getContextPath() + "/payment/vnpay/return";

        String paymentUrl = VnPayUtil.buildPaymentUrl(
                returnUrl,
                order.getTotalAmount().longValue(),
                "Thanh toan don hang #" + orderId,
                String.valueOf(orderId),
                request.getRemoteAddr()
        );

        response.sendRedirect(paymentUrl);
    }

    private void handleReturn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String param = parameterNames.nextElement();
            params.put(param, request.getParameter(param));
        }

        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        String transactionStatus = request.getParameter("vnp_TransactionStatus");

        int orderId;
        try {
            orderId = Integer.parseInt(txnRef);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=invalid_vnpay_response");
            return;
        }

        boolean signatureOk = VnPayUtil.verifySignature(params);
        boolean paid = signatureOk && "00".equals(responseCode) && "00".equals(transactionStatus);

        if (paid) {
            orderService.updatePaymentStatus(orderId, "PAID");
            if ("PENDING".equals(orderService.getOrderById(orderId).getStatus())) {
                orderService.updateOrderStatus(orderId, "CONFIRMED");
            }

            HttpSession session = request.getSession(false);
            if (session != null) {
                cartService.clearCart(session);
                session.removeAttribute("appliedVoucherId");
            }

            response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId + "&payment=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId + "&payment=failed");
        }
    }

    private void completeMockSuccess(int orderId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        orderService.updatePaymentStatus(orderId, "PAID");
        Order updated = orderService.getOrderById(orderId);
        if (updated != null && "PENDING".equals(updated.getStatus())) {
            orderService.updateOrderStatus(orderId, "CONFIRMED");
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            cartService.clearCart(session);
            session.removeAttribute("appliedVoucherId");
        }

        response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId + "&payment=mock_success");
    }

    private boolean isLocalRequest(HttpServletRequest request) {
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
}