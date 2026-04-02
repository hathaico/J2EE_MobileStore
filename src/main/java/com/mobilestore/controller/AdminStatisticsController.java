package com.mobilestore.controller;

import com.mobilestore.model.DashboardStats;
import com.mobilestore.service.DashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Admin Statistics Controller
 * Hiển thị trang thống kê admin
 */
@WebServlet("/admin/statistics")
public class AdminStatisticsController extends HttpServlet {
    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu thống kê giống dashboard
        DashboardStats stats = dashboardService.getDashboardStats();
        request.setAttribute("stats", stats);
        // Forward tới trang thống kê
        request.getRequestDispatcher("/WEB-INF/views/admin/statistics.jsp")
               .forward(request, response);
    }
}
