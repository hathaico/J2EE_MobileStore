<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="dashboard" scope="request" />
<c:set var="pageTitle" value="Dashboard" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Admin</a>
            <i class="bi bi-chevron-right"></i>
            <span>Dashboard</span>
        </div>
    </div>
</div>

<!-- Stat Cards -->
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

<!-- Customer & Stock Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Khách hàng</h6>
                <div class="stat-value">${stats.totalCustomers}</div>
            </div>
            <div class="stat-icon bg-purple rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-people-fill"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Sắp hết hàng</h6>
                <div class="stat-value">${stats.lowStockProducts}</div>
            </div>
            <div class="stat-icon bg-yellow rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Hết hàng</h6>
                <div class="stat-value">${stats.outOfStockProducts}</div>
            </div>
            <div class="stat-icon bg-red rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-x-octagon-fill"></i>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-sm-6">
        <div class="admin-stat-card admin-animate-in shadow-sm" style="border-radius:18px;overflow:hidden;">
            <div class="stat-info">
                <h6>Chờ xác nhận</h6>
                <div class="stat-value">${stats.pendingOrders}</div>
            </div>
            <div class="stat-icon bg-yellow rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                <i class="bi bi-hourglass-split"></i>
            </div>
        </div>
    </div>
</div>

<!-- Order Status Summary -->
<div class="row g-3 mb-4">
    <div class="col-6 col-lg-3">
        <div class="admin-status-card admin-animate-in shadow-sm" style="border-radius:14px;">
            <div class="status-count" style="color:var(--admin-warning);font-weight:600;">${stats.pendingOrders}</div>
            <div class="status-label d-flex align-items-center gap-1"><i class="bi bi-clock"></i> Chờ xác nhận</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="admin-status-card admin-animate-in shadow-sm" style="border-radius:14px;">
            <div class="status-count" style="color:var(--admin-info);font-weight:600;">${stats.confirmedOrders}</div>
            <div class="status-label d-flex align-items-center gap-1"><i class="bi bi-check-circle"></i> Đã xác nhận</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="admin-status-card admin-animate-in shadow-sm" style="border-radius:14px;">
            <div class="status-count" style="color:var(--admin-primary);font-weight:600;">${stats.shippingOrders}</div>
            <div class="status-label d-flex align-items-center gap-1"><i class="bi bi-truck"></i> Đang giao</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="admin-status-card admin-animate-in shadow-sm" style="border-radius:14px;">
            <div class="status-count" style="color:var(--admin-success);font-weight:600;">${stats.deliveredOrders}</div>
            <div class="status-label d-flex align-items-center gap-1"><i class="bi bi-check2-all"></i> Đã giao</div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!-- Revenue & Orders Chart -->
    <div class="row mb-4">
        <div class="col-12">
                <!-- Chart card removed -->
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    // Dữ liệu mẫu, backend cần truyền revenueByMonth, ordersByMonth, labels
    const revenueData = ${revenueByMonthJson}; 
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
    <!-- Recent Orders -->
    <div class="col-xl-8">
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-clock-history"></i> Đơn hàng gần đây</h5>
                <a href="${ctx}/admin/orders" class="admin-btn admin-btn-outline admin-btn-sm">
                    Xem tất cả <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div class="admin-card-body p-0">
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Mã ĐH</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thanh toán</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${recentOrders}">
                                <tr>
                                    <td><strong>#${order.orderId}</strong></td>
                                    <td>
                                        <div style="font-weight:600;">${order.customerName}</div>
                                        <div style="font-size:0.78rem;color:var(--admin-text-muted);">${order.customerPhone}</div>
                                    </td>
                                    <td style="font-weight:700;">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'PENDING'}">
                                                <span class="admin-badge admin-badge-warning rounded-pill px-3 py-2"><i class="bi bi-clock"></i> Chờ xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.status == 'CONFIRMED'}">
                                                <span class="admin-badge admin-badge-info rounded-pill px-3 py-2"><i class="bi bi-check-circle"></i> Đã xác nhận</span>
                                            </c:when>
                                            <c:when test="${order.status == 'SHIPPING'}">
                                                <span class="admin-badge admin-badge-primary rounded-pill px-3 py-2"><i class="bi bi-truck"></i> Đang giao</span>
                                            </c:when>
                                            <c:when test="${order.status == 'DELIVERED'}">
                                                <span class="admin-badge admin-badge-success rounded-pill px-3 py-2"><i class="bi bi-check2-all"></i> Đã giao</span>
                                            </c:when>
                                            <c:when test="${order.status == 'CANCELLED'}">
                                                <span class="admin-badge admin-badge-danger rounded-pill px-3 py-2"><i class="bi bi-x-circle"></i> Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="admin-badge admin-badge-gray rounded-pill px-3 py-2">${order.statusLabel}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PAID'}">
                                                <span class="admin-badge admin-badge-success rounded-pill px-3 py-2"><i class="bi bi-check"></i> Đã TT</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="admin-badge admin-badge-gray rounded-pill px-3 py-2">Chưa TT</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${ctx}/admin/orders?action=detail&id=${order.orderId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Xem" style="min-width:36px;gap:4px;">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentOrders}">
                                <tr>
                                    <td colspan="6">
                                        <div class="admin-empty-state py-5">
                                            <i class="bi bi-inbox" style="font-size:2rem;"></i>
                                            <p class="mt-2 mb-0">Chưa có đơn hàng nào</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Side Column -->
    <div class="col-xl-4">
        <!-- Low Stock Products -->
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-exclamation-triangle"></i> Sắp hết hàng</h5>
                <span class="admin-badge admin-badge-danger">${stats.outOfStockProducts} hết</span>
            </div>
            <div class="admin-card-body">
                <c:choose>
                    <c:when test="${not empty lowStockProducts}">
                        <c:forEach var="product" items="${lowStockProducts}">
                            <div class="admin-low-stock-item">
                                <div style="min-width:0; flex:1;">
                                    <div style="font-weight:600; font-size:0.88rem; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                        ${product.productName}
                                    </div>
                                    <div style="font-size:0.78rem; color:var(--admin-text-muted);">
                                        Còn lại:
                                        <c:choose>
                                            <c:when test="${product.stockQuantity == 0}">
                                                <span class="admin-badge admin-badge-danger rounded-pill px-3 py-2">${product.stockQuantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="admin-badge admin-badge-warning rounded-pill px-3 py-2">${product.stockQuantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <a href="${ctx}/admin/products?action=edit&id=${product.productId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Sửa" style="min-width:36px;gap:4px;">
                                    <i class="bi bi-pencil"></i>
                                </a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="admin-empty-state py-5">
                            <i class="bi bi-check-circle" style="color:var(--admin-success);font-size:2rem;"></i>
                            <p class="mt-2 mb-0">Tất cả sản phẩm đều còn hàng</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-lightning-charge-fill"></i> Thao tác nhanh</h5>
            </div>
            <div class="admin-card-body">
                <div class="admin-quick-actions d-flex flex-wrap gap-2">
                    <a href="${ctx}/admin/products?action=add" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-plus-circle-fill"></i> Thêm sản phẩm
                    </a>
                    <a href="${ctx}/admin/orders" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-receipt"></i> Đơn hàng
                    </a>
                    <a href="${ctx}/admin/orders?status=PENDING" class="btn btn-warning btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-hourglass-split"></i> Chờ xử lý
                    </a>
                    <a href="${ctx}/admin/products" class="btn btn-outline-primary btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-box-seam"></i> Sản phẩm
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
