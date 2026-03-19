package com.mobilestore.dao;

import com.mobilestore.model.Voucher;
import java.sql.*;
import java.util.Date;

import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public void createVoucher(Voucher v) throws SQLException {
        String sql = "INSERT INTO vouchers (code, description, discount_type, discount_value, min_order_value, max_discount, quantity, used_count, start_date, end_date, is_active, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, v.getCode());
            stmt.setString(2, v.getDescription());
            stmt.setString(3, v.getDiscountType());
            stmt.setBigDecimal(4, v.getDiscountValue());
            stmt.setBigDecimal(5, v.getMinOrderValue());
            if (v.getMaxDiscount() != null) stmt.setBigDecimal(6, v.getMaxDiscount()); else stmt.setNull(6, java.sql.Types.DECIMAL);
            if (v.getQuantity() != null) stmt.setInt(7, v.getQuantity()); else stmt.setNull(7, java.sql.Types.INTEGER);
            stmt.setInt(8, v.getUsedCount());
            if (v.getStartDate() != null) stmt.setDate(9, new java.sql.Date(v.getStartDate().getTime())); else stmt.setNull(9, java.sql.Types.DATE);
            if (v.getEndDate() != null) stmt.setDate(10, new java.sql.Date(v.getEndDate().getTime())); else stmt.setNull(10, java.sql.Types.DATE);
            stmt.setBoolean(11, v.isActive());
            stmt.executeUpdate();
        }
    }

        public List<Voucher> getAllVouchers() {
            List<Voucher> list = new ArrayList<>();
            String sql = "SELECT * FROM vouchers ORDER BY created_at DESC";
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDescription(rs.getString("description"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                    v.setQuantity(rs.getInt("quantity"));
                    v.setUsedCount(rs.getInt("used_count"));
                    v.setStartDate(rs.getDate("start_date"));
                    v.setEndDate(rs.getDate("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(v);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return list;
        }

        public Voucher getVoucherById(int voucherId) {
            String sql = "SELECT * FROM vouchers WHERE voucher_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, voucherId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Voucher v = new Voucher();
                        v.setVoucherId(rs.getInt("voucher_id"));
                        v.setCode(rs.getString("code"));
                        v.setDescription(rs.getString("description"));
                        v.setDiscountType(rs.getString("discount_type"));
                        v.setDiscountValue(rs.getBigDecimal("discount_value"));
                        v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                        v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                        v.setQuantity(rs.getInt("quantity"));
                        v.setUsedCount(rs.getInt("used_count"));
                        v.setStartDate(rs.getDate("start_date"));
                        v.setEndDate(rs.getDate("end_date"));
                        v.setActive(rs.getBoolean("is_active"));
                        v.setCreatedAt(rs.getTimestamp("created_at"));
                        v.setUpdatedAt(rs.getTimestamp("updated_at"));
                        return v;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/mobilestore_db", "root", "bigbone3012");
    }

    public Voucher getVoucherByCode(String code) throws SQLException {
        String sql = "SELECT * FROM vouchers WHERE code = ? AND is_active = TRUE AND (quantity IS NULL OR used_count < quantity) AND (start_date IS NULL OR start_date <= CURDATE()) AND (end_date IS NULL OR end_date >= CURDATE())";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Voucher v = new Voucher();
                    v.setVoucherId(rs.getInt("voucher_id"));
                    v.setCode(rs.getString("code"));
                    v.setDescription(rs.getString("description"));
                    v.setDiscountType(rs.getString("discount_type"));
                    v.setDiscountValue(rs.getBigDecimal("discount_value"));
                    v.setMinOrderValue(rs.getBigDecimal("min_order_value"));
                    v.setMaxDiscount(rs.getBigDecimal("max_discount"));
                    v.setQuantity(rs.getInt("quantity"));
                    v.setUsedCount(rs.getInt("used_count"));
                    v.setStartDate(rs.getDate("start_date"));
                    v.setEndDate(rs.getDate("end_date"));
                    v.setActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getTimestamp("created_at"));
                    v.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return v;
                }
            }
        }
        return null;
    }

    public void incrementUsedCount(int voucherId) throws SQLException {
        String sql = "UPDATE vouchers SET used_count = used_count + 1 WHERE voucher_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, voucherId);
            stmt.executeUpdate();
        }
    }
}
