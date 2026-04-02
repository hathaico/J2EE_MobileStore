package com.mobilestore.controller;

import com.mobilestore.model.ProductReview;
import com.mobilestore.service.ProductReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminProductReviewController extends HttpServlet {
    private ProductReviewService reviewService;

    @Override
    public void init() throws ServletException {
        reviewService = new ProductReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "approve":
                handleApprove(request, response, true);
                break;
            case "hide":
                handleApprove(request, response, false);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                handleList(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        List<ProductReview> reviews;
        if (productIdStr != null && !productIdStr.isEmpty()) {
            int productId = Integer.parseInt(productIdStr);
            reviews = reviewService.getReviewsByProduct(productId, false);
        } else {
            reviews = reviewService.getAllReviews(false);
        }
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/views/admin/review/list.jsp").forward(request, response);
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response, boolean approve) throws IOException {
        int reviewId = Integer.parseInt(request.getParameter("id"));
        reviewService.updateReviewApproval(reviewId, approve);
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reviewId = Integer.parseInt(request.getParameter("id"));
        reviewService.deleteReview(reviewId);
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }
}
