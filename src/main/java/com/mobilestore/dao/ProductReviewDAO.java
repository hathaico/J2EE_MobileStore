package com.mobilestore.dao;

import com.mobilestore.model.ProductReview;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductReviewDAO {
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/mobilestore_db", "root", "bigbone3012");
    }

    public boolean addReview(ProductReview review) throws SQLException {
        String sql = "INSERT INTO product_reviews (product_id, user_id, user_name, rating, comment, created_at, approved) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, review.getProductId());
            stmt.setInt(2, review.getUserId());
            stmt.setString(3, review.getUserName());
            stmt.setInt(4, review.getRating());
            stmt.setString(5, review.getComment());
            stmt.setTimestamp(6, review.getCreatedAt() != null ? Timestamp.valueOf(review.getCreatedAt()) : new Timestamp(System.currentTimeMillis()));
            stmt.setBoolean(7, review.isApproved());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) review.setReviewId(rs.getInt(1));
                }
                return true;
            }
        }
        return false;
    }

    public List<ProductReview> getReviewsByProduct(int productId, boolean onlyApproved) throws SQLException {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM product_reviews WHERE product_id = ?" + (onlyApproved ? " AND approved = 1" : "") + " ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSet(rs));
                }
            }
        }
        return reviews;
    }

    public List<ProductReview> getAllReviews(boolean onlyApproved) throws SQLException {
        List<ProductReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM product_reviews" + (onlyApproved ? " WHERE approved = 1" : "") + " ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSet(rs));
                }
            }
        }
        return reviews;
    }

    public boolean updateReviewApproval(int reviewId, boolean approved) throws SQLException {
        String sql = "UPDATE product_reviews SET approved = ? WHERE review_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, approved);
            stmt.setInt(2, reviewId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM product_reviews WHERE review_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        }
    }

    public double getAverageRating(int productId) throws SQLException {
        String sql = "SELECT AVG(rating) FROM product_reviews WHERE product_id = ? AND approved = 1";
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

    private ProductReview mapResultSet(ResultSet rs) throws SQLException {
        ProductReview review = new ProductReview();
        review.setReviewId(rs.getInt("review_id"));
        review.setProductId(rs.getInt("product_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setUserName(rs.getString("user_name"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) review.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) review.setUpdatedAt(updated.toLocalDateTime());
        review.setApproved(rs.getBoolean("approved"));
        return review;
    }
}

