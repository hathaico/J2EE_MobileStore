<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="ms" tagdir="/WEB-INF/tags" %>

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
                    <button id="closeFilter" class="btn btn-light btn-sm rounded-circle border-0 d-flex align-items-center justify-content-center" style="width:32px;height:32px;transition:background 0.15s;" title="Đóng">
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
                            <input type="text" name="keyword" class="form-control form-control-sm rounded-3" 
                                   placeholder="Tìm sản phẩm..." value="${keyword}"
                                   style="flex: 1; border: 1px solid #E5E7EB; padding: 8px 12px; font-size: 0.9rem;">
                            <button type="submit" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center justify-content-center" style="padding: 8px 14px;">
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
                        <div class="brand-filter-item brand-filter-item--apple" data-brand="Apple" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--apple">Apple</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--samsung" data-brand="Samsung" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--samsung">SAMSUNG</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--xiaomi" data-brand="Xiaomi" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--xiaomi">xiaomi</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--oppo" data-brand="Oppo" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--oppo">OPPO</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--vivo" data-brand="Vivo" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--vivo">vivo</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--huawei" data-brand="Huawei" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--huawei">HUAWEI</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--realme" data-brand="Realme" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--realme">realme</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--oneplus" data-brand="OnePlus" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--oneplus">OnePlus</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--google" data-brand="Google" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--google">Google</span>
                        </div>
                        <div class="brand-filter-item brand-filter-item--motorola" data-brand="Motorola" onclick="filterByBrand(this)">
                            <span class="brand-wordmark brand-wordmark--motorola">motorola</span>
                        </div>
                    </div>
                </div>

                <!-- Price Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-cash-stack" style="color: #2563EB;"></i> Mức Giá
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="price-filter" data-min="0" data-max="5000000" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">Dưới 5 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="price-filter" data-min="5000000" data-max="10000000" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">5 - 10 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="price-filter" data-min="10000000" data-max="15000000" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">10 - 15 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="price-filter" data-min="15000000" data-max="20000000" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">15 - 20 triệu</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="price-filter" data-min="20000000" data-max="999999999" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">Trên 20 triệu</label>
                    </div>
                </div>

                <!-- Storage Filter -->
                <div style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #E5E7EB;">
                    <h6 style="font-size: 0.95rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                        <i class="bi bi-hdd" style="color: #2563EB;"></i> Dung Lượng
                    </h6>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="capacity-filter" value="64GB" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">64GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="capacity-filter" value="128GB" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">128GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="capacity-filter" value="256GB" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">256GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="capacity-filter" value="512GB" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">512GB</label>
                    </div>
                    <div style="display: flex; align-items: center; padding: 5px 0;">
                        <input type="checkbox" class="capacity-filter" value="1TB" style="accent-color: #2563EB; margin-right: 8px; cursor: pointer;">
                        <label style="cursor: pointer; color: #6b7280; font-size: 0.9rem;">1TB</label>
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
            <!-- Notifications (JavaScript handled) -->
            <c:if test="${not empty successMessage}">
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        window.NotificationSystem.success('${successMessage}', 'Thành Công!');
                    });
                </script>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        window.NotificationSystem.error('${errorMessage}', 'Lỗi!', false);
                    });
                </script>
            </c:if>

            <!-- Top Toolbar -->
            <div style="background: #fff; padding: 12px 20px; border-radius: 16px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <!-- Mobile Filter Toggle -->
                    <button class="d-lg-none btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2" id="openFilter" style="padding: 6px 14px;">
                        <i class="bi bi-funnel"></i> Bộ Lọc
                    </button>
                    <span style="color: #6b7280; font-size: 0.9rem; white-space: nowrap;">Sắp xếp theo:</span>
                    <select class="form-select form-select-sm rounded-3" id="sortSelect" style="width: auto; border: 1px solid #E5E7EB; padding: 6px 32px 6px 12px; font-size: 0.9rem; color: #1F2937;">
                        <option value="newest">Mới nhất</option>
                        <option value="price-asc">Giá thấp đến cao</option>
                        <option value="price-desc">Giá cao đến thấp</option>
                        <option value="best-selling">Bán chạy</option>
                    </select>
                </div>
                <div style="display: flex; gap: 8px;">
                    <button class="btn-view active btn btn-primary btn-sm rounded-3 d-flex align-items-center justify-content-center" id="gridViewBtn" title="Grid View" style="width: 36px; height: 36px; font-size: 1rem;">
                        <i class="bi bi-grid-3x3-gap-fill"></i>
                    </button>
                    <button class="btn-view btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center justify-content-center" id="listViewBtn" title="List View" style="width: 36px; height: 36px; font-size: 1rem;">
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
                                <div class="product-card shadow-sm" style="background: #fff; border-radius: 18px; overflow: hidden; border: 1px solid #E5E7EB; height: 100%; display: flex; flex-direction: column; transition: all 0.3s;">
                                    <!-- Product Image -->
                                    <div class="store-product-card__media">
                                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" class="store-product-card__media-link">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="<ms:productImageSrc url="${product.imageUrl}" />"
                                                         alt="${product.productName}" loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="store-product-card__placeholder"><i class="bi bi-phone"></i></div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <!-- Badges -->
                                        <c:if test="${product.stockQuantity == 0}">
                                            <span class="store-product-card__badge store-product-card__badge--out">Hết hàng</span>
                                        </c:if>
                                        <c:if test="${product.stockQuantity > 0 && product.stockQuantity < 10}">
                                            <span class="store-product-card__badge store-product-card__badge--low">Sắp hết</span>
                                        </c:if>
                                        <!-- Wishlist & Quick View -->
                                        <div class="product-card-overlay store-product-card__overlay-actions">
                                            <button type="button" class="overlay-btn-wishlist btn btn-light btn-sm rounded-circle border-0 d-flex align-items-center justify-content-center" title="Yêu thích" style="width: 36px; height: 36px; font-size: 0.95rem;">
                                                <i class="bi bi-heart"></i>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}"
                                               title="Xem nhanh" class="btn btn-light btn-sm rounded-circle border-0 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; font-size: 0.95rem;">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
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
                                                    <button class="btn btn-primary btn-sm btn-add-to-cart rounded-3 d-flex align-items-center justify-content-center gap-2" data-product-id="${product.productId}"
                                                            style="flex: 1; font-size: 0.95rem; padding: 8px 12px;">
                                                        <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center justify-content-center gap-2" disabled
                                                            style="flex: 1; font-size: 0.95rem; padding: 8px 12px;">
                                                        <i class="bi bi-x-circle"></i> Hết Hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" 
                                               class="btn btn-outline-primary btn-sm rounded-3 d-flex align-items-center justify-content-center" title="Xem chi tiết"
                                               style="width: 38px; height: 38px; padding: 0;">
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
                                        <a class="page-link rounded-3 border-0" href="?page=${currentPage - 1}" style="background:#f3f4f6;color:#1F2937;padding:10px 16px;font-size:0.95rem;">
                                            <i class="bi bi-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <a class="page-link rounded-3 border-0" href="?page=${i}" style="background:#2563EB;color:#fff;padding:10px 16px;font-size:0.95rem;">
                                                    ${i}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link rounded-3 border-0" href="?page=${i}" style="background:#f3f4f6;color:#1F2937;padding:10px 16px;font-size:0.95rem;">
                                                    ${i}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link rounded-3 border-0" href="?page=${currentPage + 1}" style="background:#f3f4f6;color:#1F2937;padding:10px 16px;font-size:0.95rem;">
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

/* Brand Filter Grid */
.brand-filter-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
}

.brand-filter-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 12px;
    border-radius: 12px;
    border: 2px solid #E5E7EB;
    cursor: pointer;
    background: #fff;
    transition: all 0.2s;
}

.brand-filter-item:hover {
    border-color: #2563EB;
    background: #f0f9ff;
}

.brand-filter-item.selected {
    border-color: #2563EB;
    background: #eff6ff;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.brand-icon {
    width: 32px;
    height: 32px;
    margin-bottom: 6px;
}

.brand-name {
    font-size: 0.8rem;
    font-weight: 600;
    color: #1F2937;
    text-align: center;
}

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
            if (typeof updateCartBadge === 'function') {
                updateCartBadge(data.cartCount || 0);
            } else {
                var badge = document.querySelector('#cart-count-badge') || document.querySelector('.ms-badge');
                if (badge) {
                    badge.textContent = data.cartCount || parseInt(badge.textContent || '0', 10) + 1;
                    badge.style.display = 'flex';
                }
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

<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = '${pageContext.request.contextPath}';
    let selectedFilters = {
        prices: [],
        capacities: [],
        brands: []
    };

    // Price filter
    document.querySelectorAll('.price-filter').forEach(checkbox => {
        checkbox.addEventListener('change', applyFilters);
    });

    // Capacity filter
    document.querySelectorAll('.capacity-filter').forEach(checkbox => {
        checkbox.addEventListener('change', applyFilters);
    });

    // Brand filter
    document.querySelectorAll('.brand-filter-item').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            this.classList.toggle('active');
            if (this.classList.contains('active')) {
                this.style.opacity = '0.7';
            } else {
                this.style.opacity = '1';
            }
            applyFilters();
        });
    });

    function applyFilters() {
        const params = new URLSearchParams();
        
        // Collect price ranges
        const prices = [];
        document.querySelectorAll('.price-filter:checked').forEach(checkbox => {
            const min = checkbox.getAttribute('data-min');
            const max = checkbox.getAttribute('data-max');
            prices.push(min + '-' + max);
        });
        if (prices.length > 0) params.append('prices', prices.join(';'));

        // Collect capacities
        const capacities = [];
        document.querySelectorAll('.capacity-filter:checked').forEach(checkbox => {
            capacities.push(checkbox.value);
        });
        if (capacities.length > 0) params.append('capacities', capacities.join(';'));

        // Collect brands
        const brands = [];
        document.querySelectorAll('.brand-filter-item.selected').forEach(btn => {
            brands.push(btn.getAttribute('data-brand'));
        });
        if (brands.length > 0) params.append('brands', brands.join(';'));

        // Apply filters
        if (params.toString().length > 0) {
            window.location.href = ctx + '/products?action=filter&' + params.toString();
        } else {
            window.location.href = ctx + '/products';
        }
    }

    // Brand filter handler (from onclick)
    window.filterByBrand = function(element) {
        element.classList.toggle('selected');
        applyFilters();
    };

    // Mobile filter toggle
    document.getElementById('openFilter').addEventListener('click', function() {
        document.getElementById('filterSidebar').style.display = 'block';
        document.getElementById('filterOverlay').style.display = 'block';
    });

    document.getElementById('closeFilter').addEventListener('click', function() {
        document.getElementById('filterSidebar').style.display = 'none';
        document.getElementById('filterOverlay').style.display = 'none';
    });

    document.getElementById('filterOverlay').addEventListener('click', function() {
        document.getElementById('filterSidebar').style.display = 'none';
        document.getElementById('filterOverlay').style.display = 'none';
    });

    // Add to Cart handler
    document.querySelectorAll('.btn-add-to-cart').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const productId = this.getAttribute('data-product-id');
            // TODO: Add to cart functionality
            console.log('Add product ' + productId + ' to cart');
        });
    });
});
</script>
