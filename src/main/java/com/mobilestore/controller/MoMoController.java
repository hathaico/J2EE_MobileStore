package com.mobilestore.controller;

import com.mobilestore.model.Order;
import com.mobilestore.service.CartService;
import com.mobilestore.service.OrderService;
import com.mobilestore.util.MoMoUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.Map;

/**
 * MoMo controller.
 * /payment/momo/create: redirect user to mock/sandbox flow
 * /payment/momo/return: handle callback
 */
@WebServlet("/payment/momo/*")
public class MoMoController extends HttpServlet {
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

        if ("/mock-gateway".equals(pathInfo)) {
            renderMockGateway(request, response);
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

        if (!MoMoUtil.isConfigured() && !isLocalRequest(request)) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=momo_not_configured");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/payment/momo/mock-gateway?orderId=" + orderId);
    }

    private void renderMockGateway(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdParam = request.getParameter("orderId");
        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=invalid_order");
            return;
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=order_not_found");
            return;
        }

        Map<String, String> links = MoMoUtil.buildMockLinks(request.getContextPath(), orderId);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>MoMo Mock Gateway</title>");
        out.println("<style>body{font-family:Arial,sans-serif;background:#f5f7fb;padding:24px;} .box{max-width:640px;margin:0 auto;background:#fff;border-radius:12px;padding:24px;border:1px solid #e5e7eb;} .btn{display:inline-block;padding:10px 16px;margin-right:8px;border-radius:8px;text-decoration:none;color:#fff;} .ok{background:#16a34a;} .fail{background:#dc2626;} .hint{color:#6b7280;font-size:14px;} </style></head><body>");
        out.println("<div class='box'>");
        out.println("<h2>Vi MoMo (Mock Gateway)</h2>");
        out.println("<p>Don hang #" + orderId + " - Tong tien: " + order.getFormattedTotal() + "</p>");
        out.println("<p class='hint'>Day la cong thanh toan mo phong de test redirect flow trong local/dev.</p>");
        out.println("<p><a class='btn ok' href='" + links.get("success") + "'>Thanh toan thanh cong</a>");
        out.println("<a class='btn fail' href='" + links.get("failed") + "'>Thanh toan that bai</a></p>");
        out.println("</div></body></html>");
    }

    private void handleReturn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdParam = request.getParameter("orderId");
        String resultCode = request.getParameter("resultCode");
        String signature = request.getParameter("signature");

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/checkout?error=invalid_momo_response");
            return;
        }

        boolean signatureOk = MoMoUtil.verifyReturn(orderIdParam, resultCode, signature);
        boolean paid = signatureOk && "0".equals(resultCode);

        if (paid) {
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

            response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId + "&payment=momo_success");
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderId + "&payment=momo_failed");
        }
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
