<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Danh Sách Sản Phẩm - Mobile Store" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1200px; margin-top: 2rem; margin-bottom: 4rem;">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" style="margin-bottom: 0.75rem;">
        <ol class="breadcrumb" style="background: transparent; padding: 0; margin-bottom: 0;">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"><i class="bi bi-house-door"></i> Trang Chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Sản Phẩm</li>
        </ol>
    </nav>

    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 style="font-size: 2rem; font-weight: 700; color: #1F2937; margin-bottom: 0.25rem;">
            <c:choose>
                <c:when test="${not empty selectedCategory}">
                    ${selectedCategory.categoryName}
                </c:when>
                <c:when test="${not empty keyword}">
                    Kết quả tìm kiếm: "${keyword}"
                </c:when>
                <c:otherwise>
                    Tất Cả Sản Phẩm
                </c:otherwise>
            </c:choose>
        </h1>
        <p style="color: #6b7280; font-size: 1.05rem; margin: 0;">
            <c:choose>
                <c:when test="${not empty totalProducts}">
                    Tìm thấy <strong style="color: #2563EB;">${totalProducts}</strong> sản phẩm
                </c:when>
                <c:otherwise>
                    Khám phá bộ sưu tập điện thoại mới nhất
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <!-- Main Layout: Sidebar + Content using Bootstrap Grid -->
    <div class="row">
        <!-- Filter Sidebar (25%) -->
        <div class="col-lg-3 mb-4">
            <div id="filterSidebar" style="background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); position: sticky; top: 80px;">
                
                <!-- Mobile Filter Close -->
                <div class="d-lg-none" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid #E5E7EB;">
                    <h3 style="font-size: 1.15rem; font-weight: 600; margin: 0; color: #1F2937;"><i class="bi bi-funnel"></i> Bộ Lọc</h3>
                    <button id="closeFilter" style="background: none; border: none; font-size: 1.25rem; color: #6b7280; cursor: pointer; padding: 4px;">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>

                <!-- Search Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-search" style="color: #2563EB;"></i> Tìm Kiếm
                    </h6>
                    <form action="${pageContext.request.contextPath}/products" method="get">
                        <input type="hidden" name="action" value="search">
                        <div style="display: flex; gap: 8px;">
                            <input type="text" name="keyword" class="form-control form-control-sm" 
                                   placeholder="Tìm sản phẩm..." value="${keyword}"
                                   style="flex: 1; border-radius: 8px; border: 1px solid #E5E7EB; padding: 8px 12px; font-size: 0.9rem;">
                            <button type="submit" style="background: #2563EB; color: #fff; border: none; border-radius: 8px; padding: 8px 14px; cursor: pointer;">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Category Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-grid" style="color: #2563EB;"></i> Danh Mục
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0; cursor: pointer;">
                        <input type="radio" id="cat-all" name="category" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;"
                               onclick="window.location.href='${pageContext.request.contextPath}/products'"
                               ${empty selectedCategory ? 'checked' : ''}>
                        <label for="cat-all" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">Tất cả sản phẩm</label>
                    </div>
                    <c:forEach var="category" items="${categories}">
                        <div style="display: flex; align-items: center; padding: 5px 0; cursor: pointer;">
                            <input type="radio" id="cat-${category.categoryId}" name="category" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;"
                                   onclick="window.location.href='${pageContext.request.contextPath}/products?action=category&id=${category.categoryId}'"
                                   ${selectedCategory.categoryId == category.categoryId ? 'checked' : ''}>
                            <label for="cat-${category.categoryId}" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">
                                ${category.categoryName}
                            </label>
                        </div>
                    </c:forEach>
                </div>

                <!-- Brand Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-tags" style="color: #2563EB;"></i> Thương Hiệu
                    </h6>
                    <div class="brand-filter-grid">
                        <div class="brand-filter-item" data-brand="Apple" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><path d="M44.5 33.5c-.1-5.3 4.3-7.9 4.5-8-2.5-3.6-6.3-4.1-7.6-4.2-3.2-.3-6.4 1.9-8 1.9-1.7 0-4.2-1.9-6.9-1.8-3.5.1-6.8 2.1-8.6 5.2-3.7 6.4-1 15.9 2.6 21.1 1.8 2.5 3.9 5.4 6.6 5.3 2.7-.1 3.7-1.7 6.9-1.7 3.2 0 4.1 1.7 6.9 1.7 2.8 0 4.6-2.6 6.3-5.1 2-2.9 2.8-5.7 2.9-5.8-.1-.1-5.6-2.2-5.6-8.6zM39.3 17.6c1.4-1.8 2.4-4.2 2.1-6.6-2.1.1-4.6 1.4-6.1 3.1-1.3 1.5-2.5 4-2.2 6.3 2.3.2 4.7-1.1 6.2-2.8z" fill="#555555"/></svg>
                            <span class="brand-name">Apple</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Samsung" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#1428A0"><path d="M8.5 28.2c-1.2 0-2.4.3-3 1.1-.5.6-.6 1.3-.6 2 0 1.5.7 2.2 2.8 2.9l1.1.4c1 .4 1.5.7 1.5 1.4 0 .8-.7 1.2-1.7 1.2-1.1 0-1.9-.5-2.4-1.4l-2 1.3c.8 1.5 2.3 2.4 4.3 2.4 2.7 0 4.3-1.3 4.3-3.5 0-1.7-.9-2.6-3-3.3l-1.2-.4c-.8-.3-1.3-.5-1.3-1.1 0-.6.5-1 1.3-1 .8 0 1.4.3 1.9 1l1.8-1.3c-.9-1.2-2.1-1.7-3.8-1.7z"/><path d="M17.7 28.4l-3.5 11h2.6l.7-2.3h3.5l.7 2.3h2.7l-3.6-11h-3.1zm-.1 6.8l1.2-3.9h.1l1.2 3.9h-2.5z"/><path d="M25.1 28.4v11h2.5v-4.1l1.1-1.2 3.1 5.3h3l-4.3-7 3.8-4h-3l-3.7 4.2v-4.2h-2.5z"/><path d="M35.3 28.4l2.4 7.3h.1l2.4-7.3h3.5v11h-2.4v-7.6h-.1l-2.5 7.6h-1.9l-2.6-7.6h-.1v7.6H32v-11h3.3z"/><path d="M47.2 28.4v11h2.5v-3.5h1.3c2.6 0 4.3-1.3 4.3-3.8 0-2.4-1.6-3.7-4.2-3.7h-3.9zm2.5 2.1h1.2c1.2 0 1.9.5 1.9 1.6 0 1.1-.7 1.7-1.9 1.7h-1.2v-3.3z"/></g></svg>
                            <span class="brand-name">Samsung</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Xiaomi" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#FF6900"><rect x="12" y="16" width="40" height="32" rx="4" fill="none" stroke="#FF6900" stroke-width="3"/><path d="M22 26h8v12h-4v-8h-4v-4zm12 0h4v12h-4V26zm6 0h4v4h-4v-4zm0 8h4v4h-4v-4zm-2-4h4v4h-4v-4z"/></g></svg>
                            <span class="brand-name">Xiaomi</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Oppo" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#1A8A3E"><path d="M10.5 32c0-4.2 2.8-7 6.6-7s6.6 2.8 6.6 7-2.8 7-6.6 7-6.6-2.8-6.6-7zm10.4 0c0-2.7-1.6-4.5-3.8-4.5s-3.8 1.8-3.8 4.5 1.6 4.5 3.8 4.5 3.8-1.8 3.8-4.5z"/><path d="M25.6 25.3h5.2c3.4 0 5.3 1.8 5.3 4.6s-1.9 4.6-5.3 4.6H28v4.5h-2.4V25.3zm5 7c1.9 0 3-1 3-2.4s-1.1-2.4-3-2.4H28v4.8h2.6z"/><path d="M37.7 25.3h5.2c3.4 0 5.3 1.8 5.3 4.6s-1.9 4.6-5.3 4.6h-2.8v4.5h-2.4V25.3zm5 7c1.9 0 3-1 3-2.4s-1.1-2.4-3-2.4h-2.6v4.8h2.6z"/><path d="M46.5 32c0-4.2 2.8-7 6.6-7s6.6 2.8 6.6 7-2.8 7-6.6 7-6.6-2.8-6.6-7zm10.4 0c0-2.7-1.6-4.5-3.8-4.5s-3.8 1.8-3.8 4.5 1.6 4.5 3.8 4.5 3.8-1.8 3.8-4.5z"/></g></svg>
                            <span class="brand-name">Oppo</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Vivo" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#456FFF"><polygon points="8,24 16,24 21,36 26,24 34,24 24,44 18,44"/><path d="M32 24h4v20h-4z"/><polygon points="38,24 46,24 51,36 56,24 64,24 54,44 48,44"/><circle cx="34" cy="21" r="2.5"/></g></svg>
                            <span class="brand-name">Vivo</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Huawei" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#CF0A2C"><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(45 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(90 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(135 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(180 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(225 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(270 32 32)"/><path d="M32 8c1.5 0 2.8 3.2 3.5 7.5.4 2.5.6 5.3.5 7.5-.2 3-1.2 5-4 5s-3.8-2-4-5c-.1-2.2.1-5 .5-7.5C29.2 11.2 30.5 8 32 8z" transform="rotate(315 32 32)"/></g></svg>
                            <span class="brand-name">Huawei</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Realme" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#F5C518"><path d="M10 26h6c3.2 0 5 1.4 5 3.8 0 1.8-1 3-2.8 3.5l3.4 5.7h-3.2L15.4 34H13v5h-3V26zm5.6 5.8c1.4 0 2.2-.6 2.2-1.8s-.8-1.8-2.2-1.8H13v3.6h2.6z"/><path d="M23.5 32.5c0-4 2.6-6.8 6.2-6.8 3.4 0 5.8 2.3 5.8 6v.9H26.3c.2 2.2 1.6 3.5 3.6 3.5 1.5 0 2.6-.7 3.2-1.8l2.2 1.2c-1 2-3 3.2-5.5 3.2-3.8 0-6.3-2.7-6.3-6.2zm9.3-1.4c-.2-1.8-1.4-3-3.1-3-1.7 0-3 1.2-3.3 3h6.4z"/><path d="M37.5 33.5c0-3.4 1.8-5.2 4.5-5.2 1.6 0 2.8.7 3.5 1.8v-1.6h2.7v10.5h-2.7v-1.6c-.7 1.1-1.9 1.8-3.5 1.8-2.7 0-4.5-1.8-4.5-5.2zm8 .3v-.6c-.3-1.8-1.5-2.8-3-2.8-1.8 0-3 1.3-3 3.1 0 1.8 1.2 3.1 3 3.1 1.5 0 2.7-1 3-2.8z"/><path d="M51 26h2.7v13h-2.7z"/></g></svg>
                            <span class="brand-name">Realme</span>
                        </div>
                        <div class="brand-filter-item" data-brand="OnePlus" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#F5010C"><path d="M16 14h5v30h-8v-5h3V21l-4 2.5v-5.5l4-4z"/><rect x="30" y="21" width="4" height="22" rx="1"/><rect x="23" y="28" width="18" height="4" rx="1" transform="translate(0 2)"/></g></svg>
                            <span class="brand-name">OnePlus</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Google" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g><path d="M32 13.6c5.1 0 8.5 2.2 10.5 4l7.6-7.5C45 5.7 39 3 32 3 20.5 3 10.8 9.6 6.2 19l8.8 6.8C17 19 24 13.6 32 13.6z" fill="#EA4335" transform="scale(0.65) translate(16 17)"/><path d="M61.2 32.7c0-2.3-.2-4-.6-5.8H32v10.6h16.5c-.7 3.8-2.9 7-6.2 9.2l9.5 7.4c5.7-5.3 9.4-13 9.4-21.4z" fill="#4285F4" transform="scale(0.65) translate(16 17)"/><path d="M15 38.2c-1-2.8-1.5-5.8-1.5-9s.5-6.2 1.5-9L6.2 13.4C3.2 19.2 1.5 25.8 1.5 32.7s1.7 13.5 4.7 19.3l8.8-6.8z" fill="#FBBC05" transform="scale(0.65) translate(16 17)"/><path d="M32 62c7 0 13-2.3 17.3-6.3l-9.5-7.4c-2.4 1.6-5.4 2.6-7.8 2.6-8 0-15-5.4-17-12.6l-8.8 6.8C10.8 54.4 20.5 62 32 62z" fill="#34A853" transform="scale(0.65) translate(16 17)"/></g></svg>
                            <span class="brand-name">Google</span>
                        </div>
                        <div class="brand-filter-item" data-brand="Motorola" onclick="filterByBrand(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="brand-icon"><g fill="#5C2D91"><circle cx="32" cy="32" r="28" fill="none" stroke="#5C2D91" stroke-width="3"/><path d="M32 14 L18 48 L22 48 L32 24 L42 48 L46 48 Z"/><circle cx="32" cy="20" r="5" fill="#5C2D91"/></g></svg>
                            <span class="brand-name">Motorola</span>
                        </div>
                    </div>
                </div>

                <!-- Price Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-cash-stack" style="color: #2563EB;"></i> Mức Giá
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="price-1" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="price-1" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">Dưới 5 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="price-2" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="price-2" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">5 - 10 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="price-3" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="price-3" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">10 - 15 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="price-4" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="price-4" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">15 - 20 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="price-5" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="price-5" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">Trên 20 triệu</label>
                    </div>
                </div>

                <!-- Storage Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-hdd" style="color: #2563EB;"></i> Bộ Nhớ
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="storage-64" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="storage-64" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">64GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="storage-128" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="storage-128" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">128GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="storage-256" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="storage-256" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">256GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="storage-512" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="storage-512" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">512GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="storage-1tb" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="storage-1tb" style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">1TB</label>
                    </div>
                </div>

                <!-- Rating Filter -->
                <div>
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-star" style="color: #2563EB;"></i> Đánh Giá
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="rating-5" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="rating-5" style="cursor: pointer; display: flex; align-items: center; gap: 4px;">
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                        </label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="rating-4" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="rating-4" style="cursor: pointer; display: flex; align-items: center; gap: 4px; color: #6b7280; font-size: 0.9rem;">
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star" style="color: #d1d5db; font-size: 0.85rem;"></i>
                            <span style="margin-left: 2px;">trở lên</span>
                        </label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" id="rating-3" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label for="rating-3" style="cursor: pointer; display: flex; align-items: center; gap: 4px; color: #6b7280; font-size: 0.9rem;">
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                            <i class="bi bi-star" style="color: #d1d5db; font-size: 0.85rem;"></i>
                            <i class="bi bi-star" style="color: #d1d5db; font-size: 0.85rem;"></i>
                            <span style="margin-left: 2px;">trở lên</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content (75%) -->
        <div class="col-lg-9">
            <!-- Alert Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-circle"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Top Toolbar -->
            <div style="background: #fff; padding: 12px 20px; border-radius: 12px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <!-- Mobile Filter Toggle -->
                    <button class="d-lg-none" id="openFilter" style="display: inline-flex; align-items: center; gap: 6px; background: #fff; border: 1px solid #E5E7EB; border-radius: 8px; padding: 6px 14px; font-size: 0.9rem; color: #1F2937; cursor: pointer;">
                        <i class="bi bi-funnel"></i> Bộ Lọc
                    </button>
                    <span style="color: #6b7280; font-size: 0.9rem; white-space: nowrap;">Sắp xếp theo:</span>
                    <select class="form-select form-select-sm" id="sortSelect" style="width: auto; border: 1px solid #E5E7EB; border-radius: 8px; padding: 6px 32px 6px 12px; font-size: 0.9rem; color: #1F2937;">
                        <option value="newest">Mới nhất</option>
                        <option value="price-asc">Giá thấp đến cao</option>
                        <option value="price-desc">Giá cao đến thấp</option>
                        <option value="best-selling">Bán chạy</option>
                    </select>
                </div>
                <div style="display: flex; gap: 4px;">
                    <button class="btn-view active" id="gridViewBtn" title="Grid View" style="width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: #2563EB; border: 1px solid #2563EB; border-radius: 8px; color: #fff; cursor: pointer; font-size: 1rem;">
                        <i class="bi bi-grid-3x3-gap-fill"></i>
                    </button>
                    <button class="btn-view" id="listViewBtn" title="List View" style="width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: transparent; border: 1px solid #E5E7EB; border-radius: 8px; color: #6b7280; cursor: pointer; font-size: 1rem;">
                        <i class="bi bi-list-ul"></i>
                    </button>
                </div>
            </div>

            <!-- Products -->
            <c:choose>
                <c:when test="${empty products}">
                    <div style="text-align: center; padding: 4rem 2rem; background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                        <div style="margin-bottom: 1.5rem;">
                            <i class="bi bi-inbox" style="font-size: 5rem; color: #d1d5db;"></i>
                        </div>
                        <h3 style="color: #1F2937; font-weight: 600; margin-bottom: 0.5rem;">Không tìm thấy sản phẩm</h3>
                        <p style="color: #6b7280; margin-bottom: 1.5rem;">Thử thay đổi bộ lọc hoặc tìm kiếm với từ khóa khác</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                            <i class="bi bi-arrow-left"></i> Xem Tất Cả Sản Phẩm
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Product Grid using Bootstrap -->
                    <div class="row g-3" id="productGrid">
                        <c:forEach var="product" items="${products}">
                            <div class="col-xl-4 col-md-6 col-12">
                                <div class="product-card" style="background: #fff; border-radius: 12px; overflow: hidden; border: 1px solid #E5E7EB; box-shadow: 0 4px 14px rgba(0,0,0,0.05); height: 100%; display: flex; flex-direction: column; transition: all 0.3s ease;">
                                    <!-- Product Image -->
                                    <div style="position: relative; height: 200px; display: flex; align-items: center; justify-content: center; background: #F8FAFC; overflow: hidden;">
                                        <!-- Badges -->
                                        <c:if test="${product.stockQuantity == 0}">
                                            <span style="position: absolute; top: 12px; left: 12px; padding: 4px 12px; background: #4b5563; color: #fff; font-size: 0.75rem; font-weight: 600; border-radius: 9999px; z-index: 2;">Hết hàng</span>
                                        </c:if>
                                        <c:if test="${product.stockQuantity > 0 && product.stockQuantity < 10}">
                                            <span style="position: absolute; top: 12px; left: 12px; padding: 4px 12px; background: #f59e0b; color: #111827; font-size: 0.75rem; font-weight: 600; border-radius: 9999px; z-index: 2;">Sắp hết</span>
                                        </c:if>
                                        
                                        <!-- Wishlist & Quick View -->
                                        <div class="product-card-overlay" style="position: absolute; top: 12px; right: 12px; display: flex; flex-direction: column; gap: 8px; z-index: 2; opacity: 0; transform: translateX(10px); transition: all 0.3s ease;">
                                            <button class="overlay-btn-wishlist" title="Yêu thích" style="width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: #fff; border: none; border-radius: 50%; color: #6b7280; box-shadow: 0 4px 14px rgba(0,0,0,0.05); cursor: pointer; font-size: 0.95rem;">
                                                <i class="bi bi-heart"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" 
                                               title="Xem nhanh" style="width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; background: #fff; border: none; border-radius: 50%; color: #6b7280; box-shadow: 0 4px 14px rgba(0,0,0,0.05); text-decoration: none; font-size: 0.95rem;">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
                                        
                                        <!-- Image -->
                                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/assets/images/products/${product.imageUrl}" 
                                                         alt="${product.productName}" loading="lazy"
                                                         style="max-height: 180px; max-width: 90%; object-fit: contain; transition: transform 0.5s ease;">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-phone" style="font-size: 5rem; color: #d1d5db;"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    
                                    <!-- Product Body -->
                                    <div style="padding: 20px; flex: 1; display: flex; flex-direction: column;">
                                        <div style="font-size: 0.8rem; color: #6b7280; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; font-weight: 500;">${product.brand}</div>
                                        <h3 style="font-size: 1rem; font-weight: 600; color: #1F2937; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.4;">
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" style="color: inherit; text-decoration: none;">
                                                ${product.productName}
                                            </a>
                                        </h3>
                                        
                                        <!-- Rating -->
                                        <div style="display: flex; align-items: center; gap: 4px; margin-bottom: 12px;">
                                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                                            <i class="bi bi-star-fill" style="color: #f59e0b; font-size: 0.85rem;"></i>
                                            <i class="bi bi-star-half" style="color: #f59e0b; font-size: 0.85rem;"></i>
                                            <span style="font-size: 0.8rem; color: #6b7280; margin-left: 2px;">(4.5)</span>
                                        </div>
                                        
                                        <!-- Price -->
                                        <div style="margin-top: auto; margin-bottom: 16px;">
                                            <span style="font-size: 1.3rem; font-weight: 700; color: #2563EB;">
                                                <fmt:formatNumber value="${product.price}" pattern="#,##0₫"/>
                                            </span>
                                        </div>
                                        
                                        <!-- Actions -->
                                        <div style="display: flex; gap: 8px;">
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 0}">
                                                    <button class="btn btn-primary btn-sm btn-add-to-cart" data-product-id="${product.productId}"
                                                            style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-radius: 8px; font-size: 0.85rem; padding: 8px 12px;">
                                                        <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-outline-secondary btn-sm" disabled
                                                            style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-radius: 8px; font-size: 0.85rem; padding: 8px 12px;">
                                                        <i class="bi bi-x-circle"></i> Hết Hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" 
                                               class="btn btn-outline-primary btn-sm" title="Xem chi tiết"
                                               style="width: 38px; height: 38px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px;">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav style="margin-top: 2.5rem;" aria-label="Phân trang sản phẩm">
                            <ul class="pagination justify-content-center" style="gap: 6px;">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}" style="border-radius: 8px; border: 1px solid #E5E7EB; color: #1F2937; padding: 10px 16px; font-size: 0.9rem;">
                                            <i class="bi bi-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <a class="page-link" href="?page=${i}" style="border-radius: 8px; background: #2563EB; border-color: #2563EB; color: #fff; padding: 10px 16px; font-size: 0.9rem;">
                                                    ${i}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${i}" style="border-radius: 8px; border: 1px solid #E5E7EB; color: #1F2937; padding: 10px 16px; font-size: 0.9rem;">
                                                    ${i}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}" style="border-radius: 8px; border: 1px solid #E5E7EB; color: #1F2937; padding: 10px 16px; font-size: 0.9rem;">
                                            Sau <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Filter Overlay for Mobile -->
<div id="filterOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1040;"></div>

<style>
/* Product card hover effects */
.product-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important;
    border-color: #2563EB !important;
}
.product-card:hover .product-card-overlay {
    opacity: 1 !important;
    transform: translateX(0) !important;
}
.product-card:hover img {
    transform: scale(1.08);
}
.overlay-btn-wishlist:hover,
.product-card-overlay a:hover {
    background: #2563EB !important;
    color: #fff !important;
}
.overlay-btn-wishlist.wishlisted {
    color: #F43F5E !important;
}
.overlay-btn-wishlist.wishlisted:hover {
    background: #F43F5E !important;
    color: #fff !important;
}

/* View toggle buttons */
.btn-view.active {
    background: #2563EB !important;
    color: #fff !important;
    border-color: #2563EB !important;
}

/* Toast notification */
.toast-notification {
    position: fixed;
    top: 24px;
    right: 24px;
    padding: 14px 24px;
    border-radius: 8px;
    color: #fff;
    font-size: 0.95rem;
    font-weight: 500;
    z-index: 10000;
    transform: translateX(120%);
    transition: transform 0.3s ease;
    display: flex;
    align-items: center;
    gap: 8px;
    box-shadow: 0 15px 30px rgba(0,0,0,0.1);
}
.toast-notification.show { transform: translateX(0); }
.toast-success { background: #10b981; }
.toast-error { background: #ef4444; }

/* Mobile filter drawer */
@media (max-width: 991.98px) {
    #filterSidebar {
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 320px !important;
        height: 100% !important;
        z-index: 1050 !important;
        border-radius: 0 !important;
        overflow-y: auto !important;
        transform: translateX(-100%);
        transition: transform 0.3s ease;
    }
    #filterSidebar.open {
        transform: translateX(0);
    }
    #filterOverlay.show {
        display: block !important;
    }
}
@media (max-width: 575.98px) {
    #filterSidebar { width: 280px !important; }
    .toast-notification { left: 16px; right: 16px; top: auto; bottom: 24px; }
}
</style>

<script>
var listContextPath = '${pageContext.request.contextPath}';

// Add to Cart
function addToCart(productId) {
    fetch(listContextPath + '/cart?action=add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'productId=' + productId + '&quantity=1'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            var badge = document.querySelector('.badge');
            if (badge) {
                badge.textContent = data.cartCount || parseInt(badge.textContent || '0') + 1;
            }
            showToast('Đã thêm sản phẩm vào giỏ hàng!', 'success');
        } else {
            showToast('Có lỗi xảy ra: ' + data.message, 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
    });
}

// Toast
function showToast(message, type) {
    var existing = document.querySelector('.toast-notification');
    if (existing) existing.remove();
    var toast = document.createElement('div');
    toast.className = 'toast-notification toast-' + type;
    toast.innerHTML = '<i class="bi ' + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill') + '"></i> ' + message;
    document.body.appendChild(toast);
    setTimeout(function() { toast.classList.add('show'); }, 10);
    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() { toast.remove(); }, 300);
    }, 3000);
}

document.addEventListener('DOMContentLoaded', function() {
    // Grid / List view toggle
    var gridBtn = document.getElementById('gridViewBtn');
    var listBtn = document.getElementById('listViewBtn');
    var grid = document.getElementById('productGrid');
    
    if (gridBtn && listBtn && grid) {
        gridBtn.addEventListener('click', function() {
            grid.classList.remove('product-list-view');
            gridBtn.style.background = '#2563EB';
            gridBtn.style.color = '#fff';
            gridBtn.style.borderColor = '#2563EB';
            listBtn.style.background = 'transparent';
            listBtn.style.color = '#6b7280';
            listBtn.style.borderColor = '#E5E7EB';
        });
        listBtn.addEventListener('click', function() {
            grid.classList.add('product-list-view');
            listBtn.style.background = '#2563EB';
            listBtn.style.color = '#fff';
            listBtn.style.borderColor = '#2563EB';
            gridBtn.style.background = 'transparent';
            gridBtn.style.color = '#6b7280';
            gridBtn.style.borderColor = '#E5E7EB';
        });
    }

    // Mobile filter
    var openFilter = document.getElementById('openFilter');
    var closeFilter = document.getElementById('closeFilter');
    var filterSidebar = document.getElementById('filterSidebar');
    var filterOverlay = document.getElementById('filterOverlay');

    // Event delegation for add-to-cart buttons
    document.querySelectorAll('.btn-add-to-cart').forEach(function(btn) {
        btn.addEventListener('click', function() {
            addToCart(this.getAttribute('data-product-id'));
        });
    });
    
    if (openFilter && filterSidebar && filterOverlay) {
        openFilter.addEventListener('click', function() {
            filterSidebar.classList.add('open');
            filterOverlay.classList.add('show');
            document.body.style.overflow = 'hidden';
        });
        function closePanel() {
            filterSidebar.classList.remove('open');
            filterOverlay.classList.remove('show');
            document.body.style.overflow = '';
        }
        if (closeFilter) closeFilter.addEventListener('click', closePanel);
        filterOverlay.addEventListener('click', closePanel);
    }

    // Wishlist toggle
    document.querySelectorAll('.overlay-btn-wishlist').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            var icon = this.querySelector('i');
            icon.classList.toggle('bi-heart');
            icon.classList.toggle('bi-heart-fill');
            this.classList.toggle('wishlisted');
        });
    });
});

// Brand filter click handler
function filterByBrand(el) {
    el.classList.toggle('active');
}
</script>

<jsp:include page="../common/footer.jsp"/>
