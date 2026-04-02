<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="statistics" scope="request" />
<c:set var="pageTitle" value="Thống kê" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<div class="admin-page-header">
    <div>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Admin</a>
            <i class="bi bi-chevron-right"></i>
            <span>Thống kê</span>
        </div>
    </div>
</div>

<!-- Stat Cards (copy từ dashboard) -->
<!-- Revenue & Orders Chart (moved from dashboard) -->
<div class="row mb-4">
    <div class="col-12">
        <div class="admin-card admin-animate-in" style="animation-delay: 0.65s;">
            <div class="admin-card-header">
                <h5><i class="bi bi-bar-chart-line"></i> Thống kê doanh thu &amp; đơn hàng theo tháng</h5>
            </div>
            <div class="admin-card-body">
                <canvas id="revenueOrdersChart" height="80"></canvas>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Dữ liệu mẫu, backend cần truyền revenueByMonth, ordersByMonth, labels
const revenueData = ${revenueByMonthJson}; 
const ordersData = ${ordersByMonthJson};
const labels = ${monthLabelsJson};        

const ctx = document.getElementById('revenueOrdersChart').getContext('2d');
const chart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [
            {
                label: 'Doanh thu (₫)',
                data: revenueData,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                yAxisID: 'y',
            },
            {
                label: 'Đơn hàng',
                data: ordersData,
                backgroundColor: 'rgba(255, 206, 86, 0.6)',
                type: 'line',
                yAxisID: 'y1',
            }
        ]
    },
    options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        stacked: false,
        plugins: {
            legend: { position: 'top' },
            title: { display: false }
        },
        scales: {
            y: {
                type: 'linear',
                display: true,
                position: 'left',
                ticks: { callback: value => value.toLocaleString('vi-VN') + '₫' }
            },
            y1: {
                type: 'linear',
                display: true,
                position: 'right',
                grid: { drawOnChartArea: false },
                beginAtZero: true
            }
        }
    }
});
</script>
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Voucher đã sử dụng</h6>
                <div class="stat-value">${stats.usedVouchers}</div>
                <span class="stat-trend up d-inline-flex align-items-center gap-1">
                    <i class="bi bi-ticket-perforated"></i> lượt dùng
                </span>
                <div style="font-size:0.95rem; color:var(--admin-text-muted);">
                    Tổng giảm: <fmt:formatNumber value="${stats.totalVoucherDiscount}" type="currency" currencyCode="VND" pattern="#,#00 ₫"/>
                </div>
            </div>
            <div class="stat-icon bg-orange rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-ticket-perforated"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Tổng sản phẩm</h6>
                <div class="stat-value">${stats.totalProducts}</div>
                <span class="stat-trend up d-inline-flex align-items-center gap-1">
                    <i class="bi bi-box-seam-fill"></i> sản phẩm
                </span>
            </div>
            <div class="stat-icon bg-blue rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-box-seam-fill"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Tổng đơn hàng</h6>
                <div class="stat-value">${stats.totalOrders}</div>
                <span class="stat-trend up d-inline-flex align-items-center gap-1">
                    <i class="bi bi-receipt"></i> đơn hàng
                </span>
            </div>
            <div class="stat-icon bg-green rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-bag-check-fill"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Tổng doanh thu</h6>
                <div class="stat-value" style="font-size:1.35rem;">
                    <fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                </div>
                <span class="stat-trend up d-inline-flex align-items-center gap-1">
                    <i class="bi bi-graph-up-arrow"></i> tổng thu
                </span>
            </div>
            <div class="stat-icon bg-yellow rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-cash-stack"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Đơn hôm nay</h6>
                <div class="stat-value">${stats.todayOrders}</div>
                <span class="stat-trend up d-inline-flex align-items-center gap-1">
                    <fmt:formatNumber value="${stats.todayRevenue}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                </span>
            </div>
            <div class="stat-icon bg-cyan rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-calendar-check-fill"></i>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
