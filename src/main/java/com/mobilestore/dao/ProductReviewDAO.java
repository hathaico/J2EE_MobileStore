package com.mobilestore.dao;

import com.mobilestore.model.ProductReview;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductReviewDAO {
    private Connection getConnection() throws SQLException {
        // Sử dụng DataSource hoặc DriverManager tuỳ cấu trúc dự án
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/mobilestore_db", "root", "bigbone3012");
    }

    public void addReview(ProductReview review) throws SQLException {
        String sql = "INSERT INTO product_reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getProductId());
            stmt.setInt(2, review.getUserId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.executeUpdate();
        }
    }

    public List<ProductReview> getReviewsByProduct(int productId) throws SQLException {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM product_reviews WHERE product_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductReview review = new ProductReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public double getAverageRating(int productId) throws SQLException {
        String sql = "SELECT AVG(rating) FROM product_reviews WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }
        return 0;
    }
}
