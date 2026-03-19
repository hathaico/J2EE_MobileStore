package com.mobilestore.api;

import com.mobilestore.model.ProductReview;
import com.mobilestore.service.ProductReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

public class ProductReviewApiServlet extends HttpServlet {
    private ProductReviewService reviewService = new ProductReviewService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy dữ liệu từ request
        int productId = Integer.parseInt(req.getParameter("productId"));
        int userId = Integer.parseInt(req.getParameter("userId"));
        int rating = Integer.parseInt(req.getParameter("rating"));
        String comment = req.getParameter("comment");
        ProductReview review = new ProductReview();
        review.setProductId(productId);
        review.setUserId(userId);
        review.setRating(rating);
        review.setComment(comment);
        try {
            reviewService.addReview(review);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("success");
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        try {
            List<ProductReview> reviews = reviewService.getReviewsByProduct(productId);
            double avgRating = reviewService.getAverageRating(productId);
            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print("{\"averageRating\":" + avgRating + ",\"reviews\":[");
            for (int i = 0; i < reviews.size(); i++) {
                ProductReview r = reviews.get(i);
                out.print("{\"userId\":" + r.getUserId() + ",\"rating\":" + r.getRating() + ",\"comment\":\"" + escapeJson(r.getComment()) + "\",\"createdAt\":\"" + r.getCreatedAt() + "\"}");
                if (i < reviews.size() - 1) out.print(",");
            }
            out.print("]}");
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("error: " + e.getMessage());
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}
