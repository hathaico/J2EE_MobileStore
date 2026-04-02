package com.mobilestore.controller;

import com.mobilestore.dao.VoucherDAO;
import com.mobilestore.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/vouchers", "/admin/voucher-create", "/admin/voucher-edit", "/admin/voucher-delete"})
public class AdminVoucherController extends HttpServlet {
    private VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/admin/voucher-create")) {
            req.getRequestDispatcher("/WEB-INF/views/admin/voucher/create.jsp").forward(req, resp);
            return;
        }
        if (uri.endsWith("/admin/voucher-edit")) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Voucher voucher = voucherDAO.getVoucherById(id);
                    if (voucher != null) {
                        req.setAttribute("voucher", voucher);
                        req.getRequestDispatcher("/WEB-INF/views/admin/voucher/edit.jsp").forward(req, resp);
                        return;
                    }
                } catch (Exception ex) {
                    req.setAttribute("error", "Không tìm thấy voucher cần sửa!");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
            return;
        }
        // Danh sách voucher
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        req.setAttribute("vouchers", vouchers);
        req.getRequestDispatcher("/WEB-INF/views/admin/voucher/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/admin/voucher-create")) {
            // ...existing code for create...
            String code = req.getParameter("code");
            String description = req.getParameter("description");
            String discountType = req.getParameter("discountType");
            String discountValue = req.getParameter("discountValue");
            String minOrderValue = req.getParameter("minOrderValue");
            String maxDiscount = req.getParameter("maxDiscount");
            String quantity = req.getParameter("quantity");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");
            String isActive = req.getParameter("isActive");
            try {
                Voucher v = new Voucher();
                v.setCode(code);
                v.setDescription(description);
                v.setDiscountType(discountType);
                v.setDiscountValue(new java.math.BigDecimal(discountValue));
                v.setMinOrderValue(minOrderValue == null || minOrderValue.isEmpty() ? java.math.BigDecimal.ZERO : new java.math.BigDecimal(minOrderValue));
                v.setMaxDiscount(maxDiscount == null || maxDiscount.isEmpty() ? null : new java.math.BigDecimal(maxDiscount));
                v.setQuantity(quantity == null || quantity.isEmpty() ? null : Integer.parseInt(quantity));
                v.setUsedCount(0);
                v.setStartDate(startDate == null || startDate.isEmpty() ? null : java.sql.Date.valueOf(startDate));
                v.setEndDate(endDate == null || endDate.isEmpty() ? null : java.sql.Date.valueOf(endDate));
                v.setActive("true".equals(isActive));
                voucherDAO.createVoucher(v);
                req.setAttribute("success", "Tạo voucher thành công!");
            } catch (Exception ex) {
                req.setAttribute("error", "Có lỗi khi tạo voucher: " + ex.getMessage());
            }
            req.getRequestDispatcher("/WEB-INF/views/admin/voucher/create.jsp").forward(req, resp);
            return;
        }
        if (uri.endsWith("/admin/voucher-edit")) {
            // Xử lý cập nhật voucher
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Voucher v = voucherDAO.getVoucherById(id);
                    if (v != null) {
                        v.setCode(req.getParameter("code"));
                        v.setDescription(req.getParameter("description"));
                        v.setDiscountType(req.getParameter("discountType"));
                        v.setDiscountValue(new java.math.BigDecimal(req.getParameter("discountValue")));
                        String minOrderValue = req.getParameter("minOrderValue");
                        String maxDiscount = req.getParameter("maxDiscount");
                        String quantity = req.getParameter("quantity");
                        String startDate = req.getParameter("startDate");
                        String endDate = req.getParameter("endDate");
                        String isActive = req.getParameter("isActive");
                        v.setMinOrderValue(minOrderValue == null || minOrderValue.isEmpty() ? java.math.BigDecimal.ZERO : new java.math.BigDecimal(minOrderValue));
                        v.setMaxDiscount(maxDiscount == null || maxDiscount.isEmpty() ? null : new java.math.BigDecimal(maxDiscount));
                        v.setQuantity(quantity == null || quantity.isEmpty() ? null : Integer.parseInt(quantity));
                        v.setStartDate(startDate == null || startDate.isEmpty() ? null : java.sql.Date.valueOf(startDate));
                        v.setEndDate(endDate == null || endDate.isEmpty() ? null : java.sql.Date.valueOf(endDate));
                        v.setActive("true".equals(isActive));
                        voucherDAO.updateVoucher(v);
                        req.setAttribute("success", "Cập nhật voucher thành công!");
                        req.setAttribute("voucher", v);
                        req.getRequestDispatcher("/WEB-INF/views/admin/voucher/edit.jsp").forward(req, resp);
                        return;
                    }
                } catch (Exception ex) {
                    req.setAttribute("error", "Có lỗi khi cập nhật voucher: " + ex.getMessage());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
            return;
        }
        if (uri.endsWith("/admin/voucher-delete")) {
            // Xử lý xóa voucher
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    voucherDAO.deleteVoucher(id);
                } catch (Exception ex) {
                    // Có thể log lỗi hoặc set error message nếu muốn
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/vouchers");
    }
}
