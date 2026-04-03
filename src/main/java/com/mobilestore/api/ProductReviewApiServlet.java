package com.mobilestore.api;

import com.mobilestore.model.ProductReview;
import com.mobilestore.service.ProductReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
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
        boolean ok = reviewService.addReview(review);
        if (ok) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("success");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("error: add review failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        // Chỉ lấy đánh giá đã duyệt
        List<ProductReview> reviews = reviewService.getReviewsByProduct(productId, true);
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
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
}
