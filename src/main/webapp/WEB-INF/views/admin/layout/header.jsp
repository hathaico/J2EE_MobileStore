<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Admin - Mobile Store'}</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Admin CSS -->
    <link rel="stylesheet" href="${ctx}/assets/css/admin.css">
</head>
<body>
<div class="admin-wrapper">
    <!-- Sidebar Overlay (Mobile) -->
    <div class="admin-sidebar-overlay" id="sidebarOverlay"></div>

    <!-- === SIDEBAR === -->
    <aside class="admin-sidebar" id="adminSidebar">
        <!-- Brand -->
        <div class="admin-sidebar-brand">
            <div class="brand-icon">
                <i class="bi bi-phone"></i>
            </div>
            <div class="brand-text">
                Mobile Store
                <small>Admin Panel</small>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="admin-sidebar-nav">
            <div class="admin-nav-section">
                <div class="admin-nav-label">Tổng quan</div>
                <a href="${ctx}/admin/dashboard" class="admin-nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                    <i class="bi bi-grid-1x2-fill"></i> Dashboard
                </a>
            </div>

            <div class="admin-nav-section">
                <div class="admin-nav-label">Quản lý</div>
                <a href="${ctx}/admin/statistics" class="admin-nav-item ${activePage == 'statistics' ? 'active' : ''}">
                    <i class="bi bi-bar-chart-line"></i> Thống kê
                </a>
                <a href="${ctx}/admin/products" class="admin-nav-item ${activePage == 'products' ? 'active' : ''}">
                    <i class="bi bi-box-seam-fill"></i> Sản phẩm
                </a>
                <a href="${ctx}/admin/orders" class="admin-nav-item ${activePage == 'orders' ? 'active' : ''}">
                    <i class="bi bi-receipt"></i> Đơn hàng
                    <c:if test="${pendingOrderCount != null && pendingOrderCount > 0}">
                        <span class="nav-badge">${pendingOrderCount}</span>
                    </c:if>
                </a>
                <a href="${ctx}/admin/users" class="admin-nav-item ${activePage == 'users' ? 'active' : ''}">
                    <i class="bi bi-people-fill"></i> Người dùng
                </a>
                <a href="${ctx}/admin/vouchers" class="admin-nav-item ${activePage == 'vouchers' ? 'active' : ''}">
                    <i class="bi bi-ticket-perforated"></i> Voucher
                </a>
                <a href="${ctx}/admin/reviews" class="admin-nav-item ${activePage == 'reviews' ? 'active' : ''}">
                    <i class="bi bi-star-fill"></i> Đánh giá
                </a>
            </div>

            <div class="admin-nav-section">
                <div class="admin-nav-label">Hệ thống</div>
                <a href="${ctx}/" class="admin-nav-item" target="_blank">
                    <i class="bi bi-shop"></i> Xem cửa hàng
                </a>
            </div>
        </nav>

        <!-- Sidebar Footer -->
        <div class="admin-sidebar-footer">
            <a href="${ctx}/logout" class="admin-nav-item">
                <i class="bi bi-box-arrow-left"></i> Đăng xuất
            </a>
        </div>
    </aside>

    <!-- === MAIN CONTENT === -->
    <div class="admin-main">
        <!-- Top Header -->
        <header class="admin-header">
            <button class="admin-header-toggle" id="sidebarToggle" type="button">
                <i class="bi bi-list"></i>
            </button>

            <div class="admin-header-search">
                <i class="bi bi-search search-icon"></i>
                <input type="text" placeholder="Tìm kiếm..." id="adminGlobalSearch">
            </div>

            <div class="admin-header-actions">
                <a href="${ctx}/" class="admin-view-store-link" target="_blank">
                    <i class="bi bi-shop"></i> Xem cửa hàng
                </a>

                <button class="admin-header-btn" title="Thông báo">
                    <i class="bi bi-bell"></i>
                    <span class="badge-dot"></span>
                </button>

                <div style="position:relative;">
                    <div class="admin-header-profile" id="profileToggle">
                        <div class="profile-avatar">
                            ${sessionScope.user != null ? sessionScope.user.fullName.substring(0,1).toUpperCase() : 'A'}
                        </div>
                        <div class="profile-info">
                            <div class="profile-name">${sessionScope.user != null ? sessionScope.user.fullName : 'Admin'}</div>
                            <div class="profile-role">${sessionScope.user != null ? sessionScope.user.role : 'ADMIN'}</div>
                        </div>
                        <i class="bi bi-chevron-down" style="font-size:0.7rem; color: var(--admin-text-muted);"></i>
                    </div>

                    <div class="admin-profile-dropdown" id="profileDropdown">
                        <a href="${ctx}/logout">
                            <i class="bi bi-box-arrow-left"></i> Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Page Content -->
        <div class="admin-content">
            <div class="admin-content-container">
                <c:if test="${empty adminHideContentHeaderTitle or not empty adminHeaderBackHref}">
                <div class="admin-content-header ${not empty adminHideContentHeaderTitle ? 'admin-content-header--actions-only' : ''}">
                    <c:if test="${empty adminHideContentHeaderTitle}">
                    <div class="admin-content-header-main">
                        <h2>${pageTitle != null ? pageTitle : 'Admin - Mobile Store'}</h2>
                        <c:if test="${not empty adminPageDesc}">
                            <p class="admin-content-desc"><c:out value="${adminPageDesc}" /></p>
                        </c:if>
                    </div>
                    </c:if>
                    <c:if test="${not empty adminHeaderBackHref}">
                        <div class="admin-content-header-actions">
                            <a href="${adminHeaderBackHref}" class="admin-btn admin-btn-outline admin-btn-sm">
                                <i class="bi bi-arrow-left"></i>
                                <c:choose>
                                    <c:when test="${not empty adminHeaderBackLabel}"><c:out value="${adminHeaderBackLabel}" /></c:when>
                                    <c:otherwise>Quay lại</c:otherwise>
                                </c:choose>
                            </a>
                        </div>
                    </c:if>
                </div>
                </c:if>
                <div class="admin-content-body">
