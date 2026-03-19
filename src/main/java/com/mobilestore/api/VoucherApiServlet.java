package com.mobilestore.api;

import com.mobilestore.model.Voucher;
import com.mobilestore.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;


public class VoucherApiServlet extends HttpServlet {
    private VoucherService voucherService = new VoucherService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        String orderTotalStr = req.getParameter("orderTotal");
        BigDecimal orderTotal = null;
        if (orderTotalStr != null) {
            try {
                orderTotal = new BigDecimal(orderTotalStr);
            } catch (NumberFormatException e) {
                orderTotal = null;
            }
        }
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            Voucher voucher = voucherService.validateVoucher(code, orderTotal);
            if (voucher == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Mã giảm giá không hợp lệ hoặc không đủ điều kiện.\"}");
            } else {
                // Lưu voucherId vào session
                req.getSession().setAttribute("appliedVoucherId", voucher.getVoucherId());
                // Tính discount phía backend để đồng bộ với frontend
                java.math.BigDecimal discount = java.math.BigDecimal.ZERO;
                if (voucher.getDiscountType().equalsIgnoreCase("percent")) {
                    discount = orderTotal.multiply(voucher.getDiscountValue().divide(new java.math.BigDecimal(100)));
                    if (voucher.getMaxDiscount() != null && discount.compareTo(voucher.getMaxDiscount()) > 0) {
                        discount = voucher.getMaxDiscount();
                    }
                } else if (voucher.getDiscountType().equalsIgnoreCase("amount")) {
                    discount = voucher.getDiscountValue();
                }
                if (discount.compareTo(orderTotal) > 0) discount = orderTotal;
                req.getSession().setAttribute("appliedVoucherDiscount", discount);
                out.print("{\"success\":true,\"voucher\":{" 
                    + "\"id\":" + voucher.getVoucherId() + ","
                    + "\"code\":\"" + voucher.getCode() + "\"," 
                    + "\"discountType\":\"" + voucher.getDiscountType() + "\"," 
                    + "\"discountValue\":" + voucher.getDiscountValue() + ","
                    + "\"minOrderValue\":" + voucher.getMinOrderValue() + ","
                    + "\"maxDiscount\":" + voucher.getMaxDiscount() + ","
                    + "\"discount\":" + discount + "}}"
                );
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print("{\"success\":false,\"message\":\"Lỗi máy chủ.\"}");
        }
    }
}
