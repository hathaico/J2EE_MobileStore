package com.mobilestore.service;

import com.mobilestore.dao.VoucherDAO;
import com.mobilestore.model.Voucher;
import java.math.BigDecimal;
import java.sql.SQLException;

public class VoucherService {
        /**
         * Trả về Voucher theo code (không kiểm tra điều kiện đơn hàng)
         */
        public Voucher getVoucherByCode(String code) {
            try {
                return voucherDAO.getVoucherByCode(code);
            } catch (Exception e) {
                return null;
            }
        }
    private VoucherDAO voucherDAO = new VoucherDAO();

    public Voucher validateVoucher(String code, BigDecimal orderTotal) throws SQLException {
        Voucher v = voucherDAO.getVoucherByCode(code);
        if (v == null) return null;
        if (orderTotal != null && v.getMinOrderValue() != null && orderTotal.compareTo(v.getMinOrderValue()) < 0) {
            return null; // Không đủ điều kiện giá trị đơn hàng tối thiểu
        }
        return v;
    }

    public void markVoucherUsed(int voucherId) throws SQLException {
        voucherDAO.incrementUsedCount(voucherId);
    }
}
