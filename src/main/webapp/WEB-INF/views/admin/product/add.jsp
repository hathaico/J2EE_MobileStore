<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activePage" value="products" scope="request" />
<c:set var="pageTitle" value="Thêm Sản Phẩm - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-plus-circle-fill"></i> Thêm sản phẩm mới</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <a href="${ctx}/admin/products">Sản phẩm</a>
            <i class="bi bi-chevron-right"></i>
            <span>Thêm mới</span>
        </div>
    </div>
    <a href="${ctx}/admin/products" class="admin-btn admin-btn-outline">
        <i class="bi bi-arrow-left"></i> Quay lại
    </a>
</div>

<!-- Error Message -->
<c:if test="${not empty errorMessage}">
    <div class="admin-alert admin-alert-danger" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${errorMessage}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<!-- Product Form -->
<div class="admin-card">
    <div class="admin-card-header">
        <h5><i class="bi bi-info-circle"></i> Thông tin sản phẩm</h5>
    </div>
    <div class="admin-card-body">
        <form action="${ctx}/admin/products" method="post" id="productForm">
            <input type="hidden" name="action" value="create">

            <div class="mb-3">
                <label for="productName" class="admin-form-label">Tên sản phẩm <span style="color:var(--admin-danger);">*</span></label>
                <input type="text" class="admin-form-control" id="productName" name="productName" required maxlength="200" value="${param.productName}">
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="brand" class="admin-form-label">Thương hiệu</label>
                    <input type="text" class="admin-form-control" id="brand" name="brand" maxlength="100" value="${param.brand}">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="model" class="admin-form-label">Model</label>
                    <input type="text" class="admin-form-control" id="model" name="model" maxlength="100" value="${param.model}">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="price" class="admin-form-label">Giá (VNĐ) <span style="color:var(--admin-danger);">*</span></label>
                    <input type="number" class="admin-form-control" id="price" name="price" required min="0" step="1000" value="${param.price}">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="stockQuantity" class="admin-form-label">Số lượng tồn kho <span style="color:var(--admin-danger);">*</span></label>
                    <input type="number" class="admin-form-control" id="stockQuantity" name="stockQuantity" required min="0" value="${param.stockQuantity != null ? param.stockQuantity : 0}">
                </div>
            </div>

            <div class="mb-3">
                <label for="categoryId" class="admin-form-label">Danh mục</label>
                <select class="admin-form-select" id="categoryId" name="categoryId">
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${param.categoryId == category.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label for="description" class="admin-form-label">Mô tả</label>
                <textarea class="admin-form-control" id="description" name="description" rows="4">${param.description}</textarea>
            </div>

            <div class="mb-4">
                <label for="imageUrl" class="admin-form-label">Hình ảnh (tên file)</label>
                <input type="text" class="admin-form-control" id="imageUrl" name="imageUrl" maxlength="255" value="${param.imageUrl}" placeholder="ten-file-anh.jpg">
                <div style="font-size:0.8rem; color:var(--admin-text-muted); margin-top:6px;">
                    Tên file ảnh trong thư mục /assets/images/products/
                </div>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <a href="${ctx}/admin/products" class="admin-btn admin-btn-outline">
                    <i class="bi bi-x-lg"></i> Hủy
                </a>
                <button type="submit" class="admin-btn admin-btn-primary">
                    <i class="bi bi-save"></i> Lưu sản phẩm
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
