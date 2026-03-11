<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Danh Sách Sản Phẩm - Mobile Store" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="margin-top: 2rem; margin-bottom: 4rem;">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" style="margin-bottom: 2rem;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
            <li class="breadcrumb-item active">Sản Phẩm</li>
        </ol>
    </nav>

    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 style="font-size: 2.5rem; font-weight: 700; margin-bottom: 0.5rem;">
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
        <p style="color: var(--gray-600); font-size: 1.1rem;">
            <c:choose>
                <c:when test="${not empty totalProducts}">
                    Tìm thấy ${totalProducts} sản phẩm
                </c:when>
                <c:otherwise>
                    Khám phá bộ sưu tập điện thoại mới nhất
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="row">
        <!-- Filter Sidebar -->
        <div class="col-lg-3 mb-4">
            <div class="filter-sidebar">
                <!-- Search Filter -->
                <div class="filter-group">
                    <h3 class="filter-title"><i class="bi bi-search"></i> Tìm Kiếm</h3>
                    <form action="${pageContext.request.contextPath}/products" method="get">
                        <input type="hidden" name="action" value="search">
                        <div style="display: flex; gap: 0.5rem;">
                            <input type="text" name="keyword" class="form-control" 
                                   placeholder="Tìm sản phẩm..." value="${keyword}">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Category Filter -->
                <div class="filter-group">
                    <h3 class="filter-title"><i class="bi bi-grid"></i> Danh Mục</h3>
                    <div class="filter-option">
                        <input type="radio" id="cat-all" name="category" 
                               onclick="window.location.href='${pageContext.request.contextPath}/products'"
                               ${empty selectedCategory ? 'checked' : ''}>
                        <label for="cat-all" style="cursor: pointer;">Tất cả sản phẩm</label>
                    </div>
                    <c:forEach var="category" items="${categories}">
                        <div class="filter-option">
                            <input type="radio" id="cat-${category.categoryId}" name="category"
                                   onclick="window.location.href='${pageContext.request.contextPath}/products?action=category&id=${category.categoryId}'"
                                   ${selectedCategory.categoryId == category.categoryId ? 'checked' : ''}>
                            <label for="cat-${category.categoryId}" style="cursor: pointer;">
                                ${category.categoryName}
                            </label>
                        </div>
                    </c:forEach>
                </div>

                <!-- Brand Filter -->
                <div class="filter-group">
                    <h3 class="filter-title"><i class="bi bi-tags"></i> Thương Hiệu</h3>
                    <div class="filter-option">
                        <input type="checkbox" id="brand-apple">
                        <label for="brand-apple" style="cursor: pointer;">Apple</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="brand-samsung">
                        <label for="brand-samsung" style="cursor: pointer;">Samsung</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="brand-xiaomi">
                        <label for="brand-xiaomi" style="cursor: pointer;">Xiaomi</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="brand-oppo">
                        <label for="brand-oppo" style="cursor: pointer;">Oppo</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="brand-vivo">
                        <label for="brand-vivo" style="cursor: pointer;">Vivo</label>
                    </div>
                </div>

                <!-- Price Filter -->
                <div class="filter-group">
                    <h3 class="filter-title"><i class="bi bi-cash-stack"></i> Mức Giá</h3>
                    <div class="filter-option">
                        <input type="checkbox" id="price-1">
                        <label for="price-1" style="cursor: pointer;">Dưới 5 triệu</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="price-2">
                        <label for="price-2" style="cursor: pointer;">5 - 10 triệu</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="price-3">
                        <label for="price-3" style="cursor: pointer;">10 - 15 triệu</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="price-4">
                        <label for="price-4" style="cursor: pointer;">15 - 20 triệu</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="price-5">
                        <label for="price-5" style="cursor: pointer;">Trên 20 triệu</label>
                    </div>
                </div>

                <!-- Storage Filter -->
                <div class="filter-group">
                    <h3 class="filter-title"><i class="bi bi-hdd"></i> Bộ Nhớ</h3>
                    <div class="filter-option">
                        <input type="checkbox" id="storage-64">
                        <label for="storage-64" style="cursor: pointer;">64GB</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="storage-128">
                        <label for="storage-128" style="cursor: pointer;">128GB</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="storage-256">
                        <label for="storage-256" style="cursor: pointer;">256GB</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="storage-512">
                        <label for="storage-512" style="cursor: pointer;">512GB</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="storage-1tb">
                        <label for="storage-1tb" style="cursor: pointer;">1TB</label>
                    </div>
                </div>

                <!-- Rating Filter -->
                <div class="filter-group" style="border-bottom: none;">
                    <h3 class="filter-title"><i class="bi bi-star"></i> Đánh Giá</h3>
                    <div class="filter-option">
                        <input type="checkbox" id="rating-5">
                        <label for="rating-5" style="cursor: pointer;">
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                        </label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="rating-4">
                        <label for="rating-4" style="cursor: pointer;">
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star" style="color: var(--gray-300);"></i>
                            trở lên
                        </label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox" id="rating-3">
                        <label for="rating-3" style="cursor: pointer;">
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star-fill" style="color: var(--warning-color);"></i>
                            <i class="bi bi-star" style="color: var(--gray-300);"></i>
                            <i class="bi bi-star" style="color: var(--gray-300);"></i>
                            trở lên
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Grid -->
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

            <!-- Sort Bar -->
            <div style="background: white; padding: 1rem; border-radius: 12px; margin-bottom: 2rem; 
                        display: flex; justify-content: space-between; align-items: center; box-shadow: var(--shadow-sm);">
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span style="color: var(--gray-600);">Sắp xếp theo:</span>
                    <select class="form-select" style="width: auto;">
                        <option>Mới nhất</option>
                        <option>Giá tăng dần</option>
                        <option>Giá giảm dần</option>
                        <option>Bán chạy</option>
                        <option>Đánh giá cao</option>
                    </select>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <button class="btn btn-sm btn-outline" title="Grid View">
                        <i class="bi bi-grid-3x3-gap"></i>
                    </button>
                    <button class="btn btn-sm btn-outline" title="List View">
                        <i class="bi bi-list"></i>
                    </button>
                </div>
            </div>

            <!-- Products -->
            <c:choose>
                <c:when test="${empty products}">
                    <div style="text-align: center; padding: 4rem 2rem; background: white; border-radius: 12px;">
                        <i class="bi bi-inbox" style="font-size: 5rem; color: var(--gray-300);"></i>
                        <h3 style="margin-top: 1rem; color: var(--gray-600);">Không tìm thấy sản phẩm</h3>
                        <p style="color: var(--gray-500);">Thử thay đổi bộ lọc hoặc tìm kiếm với từ khóa khác</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary" style="margin-top: 1rem;">
                            Xem Tất Cả Sản Phẩm
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="product-grid">
                        <c:forEach var="product" items="${products}">
                            <div class="product-card">
                                <!-- Product Image -->
                                <div class="product-card-image">
                                    <!-- Badge -->
                                    <c:if test="${product.stockQuantity == 0}">
                                        <span class="product-badge" style="background: var(--gray-600);">Hết hàng</span>
                                    </c:if>
                                    <c:if test="${product.stockQuantity > 0 && product.stockQuantity < 10}">
                                        <span class="product-badge" style="background: var(--warning-color); color: var(--gray-900);">
                                            Sắp hết
                                        </span>
                                    </c:if>
                                    
                                    <!-- Image -->
                                    <c:choose>
                                        <c:when test="${not empty product.imageUrl}">
                                            <img src="${pageContext.request.contextPath}/assets/images/products/${product.imageUrl}" 
                                                 alt="${product.productName}">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-phone" style="font-size: 8rem; color: var(--gray-300); 
                                                                          position: absolute; top: 50%; left: 50%; 
                                                                          transform: translate(-50%, -50%);"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Product Body -->
                                <div class="product-card-body">
                                    <div class="product-brand">${product.brand}</div>
                                    <h3 class="product-title">
                                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}">
                                            ${product.productName}
                                        </a>
                                    </h3>
                                    
                                    <!-- Rating -->
                                    <div class="product-rating">
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-half"></i>
                                        <span>(4.5)</span>
                                    </div>
                                    
                                    <!-- Price -->
                                    <div class="product-price">
                                        <fmt:formatNumber value="${product.price}" pattern="#,##0₫"/>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="product-actions">
                                        <c:choose>
                                            <c:when test="${product.stockQuantity > 0}">
                                                <button class="btn btn-primary btn-add-to-cart" data-product-id="${product.productId}" style="flex: 1;">
                                                    <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-outline" style="flex: 1;" disabled>
                                                    Hết Hàng
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.productId}" 
                                           class="btn btn-icon btn-outline" title="Xem chi tiết">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav style="margin-top: 3rem;">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}">
                                            <i class="bi bi-chevron-right"></i>
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

<script>
var listNewContextPath = '${pageContext.request.contextPath}';

function addToCart(productId) {
    fetch(listNewContextPath + '/cart?action=add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + productId + '&quantity=1'
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) { alert('Đã thêm sản phẩm vào giỏ hàng!'); location.reload(); }
        else alert('Có lỗi xảy ra: ' + data.message);
    })
    .catch(function() { alert('Có lỗi xảy ra khi thêm vào giỏ hàng'); });
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.btn-add-to-cart').forEach(function(btn) {
        btn.addEventListener('click', function() {
            addToCart(this.getAttribute('data-product-id'));
        });
    });
});
</script>

<jsp:include page="../common/footer.jsp"/>
