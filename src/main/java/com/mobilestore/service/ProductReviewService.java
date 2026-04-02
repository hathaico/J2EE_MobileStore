
package com.mobilestore.service;

import com.mobilestore.dao.ProductReviewDAO;
import com.mobilestore.model.ProductReview;
import java.sql.SQLException;
import java.util.List;

public class ProductReviewService {
    private ProductReviewDAO reviewDAO = new ProductReviewDAO();

    public List<ProductReview> getAllReviews(boolean onlyApproved) {
        try {
            return reviewDAO.getAllReviews(onlyApproved);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public boolean addReview(ProductReview review) {
        try {
            return reviewDAO.addReview(review);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ProductReview> getReviewsByProduct(int productId, boolean onlyApproved) {
        try {
            return reviewDAO.getReviewsByProduct(productId, onlyApproved);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public double getAverageRating(int productId) {
        try {
            return reviewDAO.getAverageRating(productId);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean updateReviewApproval(int reviewId, boolean approved) {
        try {
            return reviewDAO.updateReviewApproval(reviewId, approved);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReview(int reviewId) {
        try {
            return reviewDAO.deleteReview(reviewId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
