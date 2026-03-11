<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="products" scope="request" />
<c:set var="pageTitle" value="Quản Lý Sản Phẩm - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-box-seam-fill"></i> Quản lý sản phẩm</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <span>Sản phẩm</span>
        </div>
    </div>
    <a href="${ctx}/admin/products?action=add" class="admin-btn admin-btn-primary">
        <i class="bi bi-plus-lg"></i> Thêm sản phẩm
    </a>
</div>

<!-- Alert Messages -->
<c:if test="${not empty successMessage}">
    <div class="admin-alert admin-alert-success" data-auto-dismiss>
        <i class="bi bi-check-circle-fill"></i> ${successMessage}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="admin-alert admin-alert-danger" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${errorMessage}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<!-- Products Table Card -->
<div class="admin-card">
    <div class="admin-toolbar">
        <div class="admin-toolbar-search">
            <i class="bi bi-search search-icon"></i>
            <input type="text" placeholder="Tìm sản phẩm..." data-table-search="productsTable">
        </div>
        <div class="ms-auto" style="font-size:0.85rem; color:var(--admin-text-muted);">
            Tổng: <strong>${products.size()}</strong> sản phẩm
        </div>
    </div>

    <div class="admin-card-body p-0">
        <div class="table-responsive">
            <table class="admin-table" id="productsTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Thương hiệu</th>
                        <th>Danh mục</th>
                        <th style="text-align:right;">Giá</th>
                        <th style="text-align:center;">Tồn kho</th>
                        <th>Trạng thái</th>
                        <th style="text-align:center;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty products}">
                            <tr>
                                <td colspan="8">
                                    <div class="admin-empty-state">
                                        <i class="bi bi-inbox"></i>
                                        <p>Chưa có sản phẩm nào</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td><strong>${product.productId}</strong></td>
                                    <td>
                                        <div class="product-cell">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="${ctx}/assets/images/products/${product.imageUrl}" alt="">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width:42px;height:42px;border-radius:8px;background:var(--admin-body-bg);display:flex;align-items:center;justify-content:center;color:var(--admin-text-muted);flex-shrink:0;">
                                                        <i class="bi bi-image"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="product-name">${product.productName}</div>
                                                <div class="product-sub">${product.model}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${product.brand}</td>
                                    <td><span class="admin-badge admin-badge-gray">${product.categoryName}</span></td>
                                    <td style="text-align:right; font-weight:700;">
                                        <fmt:formatNumber value="${product.price}" pattern="#,##0 ₫"/>
                                    </td>
                                    <td style="text-align:center;">${product.stockQuantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.stockQuantity == 0}">
                                                <span class="admin-badge admin-badge-danger"><i class="bi bi-x-circle"></i> Hết hàng</span>
                                            </c:when>
                                            <c:when test="${product.stockQuantity < 10}">
                                                <span class="admin-badge admin-badge-warning"><i class="bi bi-exclamation-triangle"></i> Sắp hết</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="admin-badge admin-badge-success"><i class="bi bi-check-circle"></i> Còn hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <div style="display:flex; gap:6px; justify-content:center;">
                                            <a href="${ctx}/products?action=detail&id=${product.productId}" class="admin-action-btn btn-view" title="Xem" target="_blank">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="${ctx}/admin/products?action=edit&id=${product.productId}" class="admin-action-btn btn-edit" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form id="deleteForm_${product.productId}" action="${ctx}/admin/products" method="get" style="display:none;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${product.productId}">
                                            </form>
                                            <button type="button" class="admin-action-btn btn-delete" title="Xóa"
                                                    onclick="adminConfirmDelete('deleteForm_${product.productId}', '${product.productName}')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="admin-modal-overlay" id="deleteModal">
    <div class="admin-modal">
        <div class="modal-icon">
            <i class="bi bi-trash"></i>
        </div>
        <h3>Xác nhận xóa</h3>
        <p>Bạn có chắc muốn xóa sản phẩm "<span id="deleteItemName"></span>"?</p>
        <div class="admin-modal-actions">
            <button class="admin-btn admin-btn-outline" onclick="adminCloseModal('deleteModal')">Hủy</button>
            <button class="admin-btn admin-btn-danger" id="deleteConfirmBtn">Xóa</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
