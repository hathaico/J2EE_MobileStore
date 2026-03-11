package com.mobilestore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

@WebServlet("/page/*")
public class PageController extends HttpServlet {

    private static final Set<String> VALID_PAGES = Set.of(
        "warranty", "return-policy", "shopping-guide", "faq", "terms"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String page = pathInfo.substring(1);
        if (!VALID_PAGES.contains(page)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("pageTitle", getPageTitle(page));
        request.getRequestDispatcher("/WEB-INF/views/page/" + page + ".jsp")
               .forward(request, response);
    }

    private String getPageTitle(String page) {
        switch (page) {
            case "warranty": return "Chính Sách Bảo Hành - Mobile Store";
            case "return-policy": return "Chính Sách Đổi Trả - Mobile Store";
            case "shopping-guide": return "Hướng Dẫn Mua Hàng - Mobile Store";
            case "faq": return "Câu Hỏi Thường Gặp - Mobile Store";
            case "terms": return "Điều Khoản Sử Dụng - Mobile Store";
            default: return "Mobile Store";
        }
    }
}
