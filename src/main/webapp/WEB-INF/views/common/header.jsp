<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${pageTitle != null ? pageTitle : 'Mobile Store'}</title>
    
    <!-- Google Fonts - Noto Sans Vietnamese -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        body { font-family: 'Noto Sans', sans-serif; color: #1F2937; }
        .ms-navbar { background: #fff; box-shadow: 0 2px 12px rgba(0,0,0,0.08); position: sticky; top: 0; z-index: 1050; }
        .ms-navbar .nav-link { color: #1F2937; font-weight: 500; padding: 10px 16px; border-radius: 8px; transition: all 0.2s; font-size: 0.95rem; display: flex; align-items: center; gap: 6px; }
        .ms-navbar .nav-link:hover { color: #2563EB; background: #F0F5FF; }
        .ms-navbar .nav-link.active { color: #2563EB; font-weight: 600; }
        .ms-navbar .dropdown-menu { border: 1px solid #E5E7EB; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 8px; margin-top: 8px; }
        .ms-navbar .dropdown-item { border-radius: 8px; padding: 10px 16px; font-size: 0.95rem; display: flex; align-items: center; gap: 8px; color: #1F2937; }
        .ms-navbar .dropdown-item:hover { background: #F0F5FF; color: #2563EB; }
        .ms-nav-icon { position: relative; width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; border-radius: 50%; color: #374151; transition: all 0.2s; font-size: 1.25rem; text-decoration: none; }
        .ms-nav-icon:hover { background: #F0F5FF; color: #2563EB; transform: translateY(-2px); }
        .ms-nav-icon .ms-badge { position: absolute; top: -2px; right: -2px; min-width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; padding: 0 5px; background: #EF4444; color: #fff; border-radius: 999px; font-size: 0.7rem; font-weight: 600; }
        .ms-search { position: relative; flex: 1; max-width: 320px; margin: 0 24px; }
        .ms-search input { width: 100%; padding: 10px 16px 10px 42px; border: 2px solid #E5E7EB; border-radius: 999px; font-size: 0.9rem; outline: none; transition: all 0.2s; background: #F9FAFB; }
        .ms-search input:focus { border-color: #2563EB; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); background: #fff; }
        .ms-search .search-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9CA3AF; font-size: 1rem; }
        @media (max-width: 991.98px) {
            .ms-search { display: none !important; }
            .ms-navbar .navbar-collapse { padding: 16px 0; }
            .ms-navbar .nav-link { padding: 12px 16px; }
        }
    </style>
</head>
<body>
    <!-- Modern Navbar -->
    <nav class="ms-navbar navbar navbar-expand-lg">
        <div class="container" style="max-width: 1200px; padding: 10px 16px;">
            <!-- Brand -->
            <a class="navbar-brand" href="${pageContext.request.contextPath}/" style="font-size: 1.5rem; font-weight: 700; color: #2563EB; display: flex; align-items: center; gap: 8px; text-decoration: none; margin-right: 8px;">
                <i class="bi bi-phone-fill" style="font-size: 1.7rem;"></i> Mobile Store
            </a>
            
            <!-- Mobile Toggle -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                    style="border: 1px solid #E5E7EB; padding: 6px 10px;">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Main Navigation -->
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="bi bi-house-door"></i> Trang Chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-grid"></i> Sản Phẩm
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-tags"></i> Thương Hiệu
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Apple">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><path d="M44.5 33.5c-.1-5.3 4.3-7.9 4.5-8-2.5-3.6-6.3-4.1-7.6-4.2-3.2-.3-6.4 1.9-8 1.9-1.7 0-4.2-1.9-6.9-1.8-3.5.1-6.8 2.1-8.6 5.2-3.7 6.4-1 15.9 2.6 21.1 1.8 2.5 3.9 5.4 6.6 5.3 2.7-.1 3.7-1.7 6.9-1.7 3.2 0 4.1 1.7 6.9 1.7 2.8 0 4.6-2.6 6.3-5.1 2-2.9 2.8-5.7 2.9-5.8-.1-.1-5.6-2.2-5.6-8.6zM39.3 17.6c1.4-1.8 2.4-4.2 2.1-6.6-2.1.1-4.6 1.4-6.1 3.1-1.3 1.5-2.5 4-2.2 6.3 2.3.2 4.7-1.1 6.2-2.8z" fill="#555555"/></svg> Apple
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Samsung">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><g fill="#1428A0"><path d="M8.5 28.2c-1.2 0-2.4.3-3 1.1-.5.6-.6 1.3-.6 2 0 1.5.7 2.2 2.8 2.9l1.1.4c1 .4 1.5.7 1.5 1.4 0 .8-.7 1.2-1.7 1.2-1.1 0-1.9-.5-2.4-1.4l-2 1.3c.8 1.5 2.3 2.4 4.3 2.4 2.7 0 4.3-1.3 4.3-3.5 0-1.7-.9-2.6-3-3.3l-1.2-.4c-.8-.3-1.3-.5-1.3-1.1 0-.6.5-1 1.3-1 .8 0 1.4.3 1.9 1l1.8-1.3c-.9-1.2-2.1-1.7-3.8-1.7z"/><path d="M17.7 28.4l-3.5 11h2.6l.7-2.3h3.5l.7 2.3h2.7l-3.6-11h-3.1zm-.1 6.8l1.2-3.9h.1l1.2 3.9h-2.5z"/><path d="M25.1 28.4v11h2.5v-4.1l1.1-1.2 3.1 5.3h3l-4.3-7 3.8-4h-3l-3.7 4.2v-4.2h-2.5z"/><path d="M35.3 28.4l2.4 7.3h.1l2.4-7.3h3.5v11h-2.4v-7.6h-.1l-2.5 7.6h-1.9l-2.6-7.6h-.1v7.6H32v-11h3.3z"/><path d="M47.2 28.4v11h2.5v-3.5h1.3c2.6 0 4.3-1.3 4.3-3.8 0-2.4-1.6-3.7-4.2-3.7h-3.9zm2.5 2.1h1.2c1.2 0 1.9.5 1.9 1.6 0 1.1-.7 1.7-1.9 1.7h-1.2v-3.3z"/></g></svg> Samsung
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Xiaomi">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><g fill="#FF6900"><rect x="12" y="16" width="40" height="32" rx="4" fill="none" stroke="#FF6900" stroke-width="3"/><path d="M22 26h8v12h-4v-8h-4v-4zm12 0h4v12h-4V26zm6 0h4v4h-4v-4zm0 8h4v4h-4v-4zm-2-4h4v4h-4v-4z"/></g></svg> Xiaomi
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Oppo">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><g fill="#1A8A3E"><path d="M10.5 32c0-4.2 2.8-7 6.6-7s6.6 2.8 6.6 7-2.8 7-6.6 7-6.6-2.8-6.6-7zm10.4 0c0-2.7-1.6-4.5-3.8-4.5s-3.8 1.8-3.8 4.5 1.6 4.5 3.8 4.5 3.8-1.8 3.8-4.5z"/><path d="M25.6 25.3h5.2c3.4 0 5.3 1.8 5.3 4.6s-1.9 4.6-5.3 4.6H28v4.5h-2.4V25.3zm5 7c1.9 0 3-1 3-2.4s-1.1-2.4-3-2.4H28v4.8h2.6z"/><path d="M37.7 25.3h5.2c3.4 0 5.3 1.8 5.3 4.6s-1.9 4.6-5.3 4.6h-2.8v4.5h-2.4V25.3zm5 7c1.9 0 3-1 3-2.4s-1.1-2.4-3-2.4h-2.6v4.8h2.6z"/><path d="M46.5 32c0-4.2 2.8-7 6.6-7s6.6 2.8 6.6 7-2.8 7-6.6 7-6.6-2.8-6.6-7zm10.4 0c0-2.7-1.6-4.5-3.8-4.5s-3.8 1.8-3.8 4.5 1.6 4.5 3.8 4.5 3.8-1.8 3.8-4.5z"/></g></svg> Oppo
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Vivo">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><g fill="#456FFF"><polygon points="8,24 16,24 21,36 26,24 34,24 24,44 18,44"/><path d="M32 24h4v20h-4z"/><polygon points="38,24 46,24 51,36 56,24 64,24 54,44 48,44"/><circle cx="34" cy="21" r="2.5"/></g></svg> Vivo
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?brand=Huawei">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" style="width:20px;height:20px;"><g fill="#CF0A2C"><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(45 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(90 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(135 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(180 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(225 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(270 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(315 32 32)"/></g></svg> Huawei
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products">
                                <i class="bi bi-grid" style="width:20px;"></i> Tất cả thương hiệu
                            </a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products?deals=true">
                            <i class="bi bi-lightning"></i> Ưu Đãi
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">
                            <i class="bi bi-envelope"></i> Liên Hệ
                        </a>
                    </li>
                </ul>
                
                <!-- Search Bar -->
                <div class="ms-search d-none d-lg-block">
                    <form action="${pageContext.request.contextPath}/products" method="get">
                        <input type="hidden" name="action" value="search">
                        <i class="bi bi-search search-icon"></i>
                        <input type="search" name="keyword" placeholder="Tìm kiếm điện thoại..." autocomplete="off">
                    </form>
                </div>
                
                <!-- User Actions -->
                <div style="display: flex; align-items: center; gap: 4px;">
                    <!-- Wishlist -->
                    <a href="${pageContext.request.contextPath}/wishlist" class="ms-nav-icon" title="Yêu thích">
                        <i class="bi bi-heart"></i>
                    </a>
                    
                    <!-- Shopping Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="ms-nav-icon" title="Giỏ hàng">
                        <i class="bi bi-cart3"></i>
                        <c:if test="${not empty sessionScope.cartCount && sessionScope.cartCount > 0}">
                            <span class="ms-badge">${sessionScope.cartCount}</span>
                        </c:if>
                    </a>
                    
                    <!-- User Account -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <a href="#" class="ms-nav-icon dropdown-toggle" data-bs-toggle="dropdown" 
                                   aria-expanded="false" title="Tài khoản" style="text-decoration: none;">
                                    <i class="bi bi-person-circle"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" style="border: 1px solid #E5E7EB; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 8px; min-width: 220px;">
                                    <li style="padding: 10px 16px;">
                                        <strong style="color: #1F2937; font-size: 0.95rem;">${sessionScope.user.fullName}</strong>
                                        <br><small style="color: #6b7280;">${sessionScope.user.email}</small>
                                    </li>
                                    <li><hr class="dropdown-divider" style="margin: 4px 0;"></li>
                                    <c:if test="${sessionScope.user.role == 'ADMIN' || sessionScope.user.role == 'STAFF'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard" style="border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; gap: 8px;">
                                            <i class="bi bi-speedometer2"></i> Quản Trị
                                        </a></li>
                                        <li><hr class="dropdown-divider" style="margin: 4px 0;"></li>
                                    </c:if>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile" style="border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; gap: 8px;">
                                        <i class="bi bi-person"></i> Tài Khoản
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders" style="border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; gap: 8px;">
                                        <i class="bi bi-bag"></i> Đơn Hàng Của Tôi
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist" style="border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; gap: 8px;">
                                        <i class="bi bi-heart"></i> Yêu Thích
                                    </a></li>
                                    <li><hr class="dropdown-divider" style="margin: 4px 0;"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout" style="border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; gap: 8px; color: #EF4444;">
                                        <i class="bi bi-box-arrow-right"></i> Đăng Xuất
                                    </a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="ms-nav-icon" title="Đăng nhập">
                                <i class="bi bi-person"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
