package com.mobilestore.service;

import com.mobilestore.dao.ProductReviewDAO;
import com.mobilestore.model.ProductReview;
import java.sql.SQLException;
import java.util.List;

public class ProductReviewService {
    private ProductReviewDAO reviewDAO = new ProductReviewDAO();

    public void addReview(ProductReview review) throws SQLException {
        // Có thể kiểm tra quyền, validate dữ liệu ở đây
        reviewDAO.addReview(review);
    }

    public List<ProductReview> getReviewsByProduct(int productId) throws SQLException {
        return reviewDAO.getReviewsByProduct(productId);
    }

    public double getAverageRating(int productId) throws SQLException {
        return reviewDAO.getAverageRating(productId);
    }
}
