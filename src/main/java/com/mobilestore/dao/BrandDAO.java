package com.mobilestore.dao;

import com.mobilestore.model.Brand;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Brand DAO
 * Data access for brand records
 * NOTE: This class assumes a database table `brands(brand_id, name, logo_url)` exists.
 * Create the table in your migration or DB client before using createBrand().
 */
public class BrandDAO extends BaseDAO {

    public List<Brand> getAllBrands() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT brand_id, name, logo_url FROM brands ORDER BY name";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()){
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setName(rs.getString("name"));
                b.setLogoUrl(rs.getString("logo_url"));
                list.add(b);
            }
        } catch (SQLException e){
            System.err.println("Error fetching brands: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return list;
    }

    public boolean createBrand(Brand brand) throws SQLException {
        if (brand == null || brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name is required");
        }
        String sql = "INSERT INTO brands (name, logo_url) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, brand.getName());
            stmt.setString(2, brand.getLogoUrl());
            int cnt = stmt.executeUpdate();
            return cnt > 0;
        }
    }

    public Brand findByName(String name) {
        if (name == null) return null;
        String sql = "SELECT brand_id, name, logo_url FROM brands WHERE name = ? LIMIT 1";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            rs = stmt.executeQuery();
            if (rs.next()){
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setName(rs.getString("name"));
                b.setLogoUrl(rs.getString("logo_url"));
                return b;
            }
        } catch (SQLException e){
            System.err.println("Error finding brand: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return null;
    }
}
