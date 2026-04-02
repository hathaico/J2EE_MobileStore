<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="activePage" value="products" scope="request" />
<c:set var="pageTitle" value="Sửa Sản Phẩm - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-pencil-square"></i> Sửa sản phẩm</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <a href="${ctx}/admin/products">Sản phẩm</a>
            <i class="bi bi-chevron-right"></i>
            <span>Sửa #${product.productId}</span>
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
        <form action="${ctx}/admin/products" method="post" enctype="multipart/form-data" id="productForm">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${product.productId}">

            <div class="mb-3">
                <label for="productName" class="admin-form-label">Tên sản phẩm <span style="color:var(--admin-danger);">*</span></label>
                <input type="text" class="admin-form-control" id="productName" name="productName" required maxlength="200" value="${product.productName}">
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="brand" class="admin-form-label">Thương hiệu</label>
                    <input type="text" class="admin-form-control" id="brand" name="brand" maxlength="100" value="${product.brand}">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="model" class="admin-form-label">Model</label>
                    <input type="text" class="admin-form-control" id="model" name="model" maxlength="100" value="${product.model}">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="color" class="admin-form-label">Màu sắc</label>
                    <input type="text" class="admin-form-control" id="color" name="color" maxlength="50" value="${product.color}" placeholder="Ví dụ: Đen, Bạc, Xanh">
                    <div class="admin-color-preview" id="colorPreviewWrapper" style="display: ${empty product.color ? 'none' : 'flex'}; flex-wrap: wrap; gap:0.75rem; margin-top:0.75rem;">
                        <div id="colorPreviewContainer" style="display:flex; flex-wrap: wrap; gap:0.75rem;"></div>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="capacity" class="admin-form-label">Dung lượng</label>
                    <input type="text" class="admin-form-control" id="capacity" name="capacity" maxlength="50" value="${product.capacity}" placeholder="Ví dụ: 128GB, 256GB">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="price" class="admin-form-label">Giá (VNĐ) <span style="color:var(--admin-danger);">*</span></label>
                    <input type="number" class="admin-form-control" id="price" name="price" required min="0" step="1000" value="${product.price}">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="stockQuantity" class="admin-form-label">Số lượng tồn kho <span style="color:var(--admin-danger);">*</span></label>
                    <input type="number" class="admin-form-control" id="stockQuantity" name="stockQuantity" required min="0" value="${product.stockQuantity}">
                </div>
            </div>

            <div class="mb-3">
                <label for="categoryId" class="admin-form-label">Danh mục <span style="color:var(--admin-danger);">*</span></label>
                <select class="admin-form-select" id="categoryId" name="categoryId" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${product.categoryId == category.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label class="admin-form-label">Thông số kỹ thuật</label>
                <p class="admin-form-hint mb-3">Nhập theo từng dòng thông số để hiển thị đúng bảng ở trang sản phẩm.</p>
                <div id="specRows" class="d-flex flex-column gap-2 mb-3"></div>
                <button type="button" class="admin-btn admin-btn-outline admin-btn-sm" id="addSpecRowBtn">
                    <i class="bi bi-plus-circle"></i> Thêm thông số
                </button>
                <label for="description" class="admin-form-label mt-3">Dữ liệu đồng bộ (tự tạo)</label>
                <textarea class="admin-form-control" id="description" name="description" rows="6" readonly>${product.description}</textarea>
            </div>

            <div class="mb-3">
                <label for="imageUrl" class="admin-form-label">Hình ảnh (tên file trong thư mục ảnh)</label>
                <input type="text" class="admin-form-control" id="imageUrl" name="imageUrl" maxlength="255" value="${product.imageUrl}" placeholder="ten-file-anh.jpg">
                <div style="font-size:0.8rem; color:var(--admin-text-muted); margin-top:6px;">
                    Hoặc chọn file mới bên dưới — ảnh sẽ được lưu vào /assets/images/products/
                </div>
            </div>

            <div class="mb-3">
                <label for="productImageFile" class="admin-form-label">Tải ảnh mới lên</label>
                <input type="file" id="productImageFile" name="productImageFile" accept="image/jpeg,image/png,image/gif,image/webp,image/svg+xml" class="form-control">
            </div>

            <c:set var="img" value="${fn:trim(product.imageUrl)}" />
            <c:if test="${not empty img}">
                <div class="mb-4">
                    <label class="admin-form-label">Ảnh hiện tại</label>
                    <div>
                        <c:choose>
                            <c:when test="${fn:startsWith(img, 'http://') or fn:startsWith(img, 'https://')}">
                                <img src="${img}" alt="Current" style="max-width:200px; border-radius:var(--admin-radius); border:2px solid var(--admin-border);">
                            </c:when>
                            <c:when test="${fn:startsWith(img, '/')}">
                                <img src="${ctx}${img}" alt="Current" style="max-width:200px; border-radius:var(--admin-radius); border:2px solid var(--admin-border);">
                            </c:when>
                            <c:when test="${fn:contains(img, 'assets/images/products')}">
                                <img src="${ctx}/${img}" alt="Current" style="max-width:200px; border-radius:var(--admin-radius); border:2px solid var(--admin-border);">
                            </c:when>
                            <c:otherwise>
                                <img src="${ctx}/assets/images/products/${img}" alt="Current" style="max-width:200px; border-radius:var(--admin-radius); border:2px solid var(--admin-border);">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <a href="${ctx}/admin/products" class="admin-btn admin-btn-outline">
                    <i class="bi bi-x-lg"></i> Hủy
                </a>
                <button type="submit" class="admin-btn admin-btn-primary">
                    <i class="bi bi-save"></i> Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var specRows = document.getElementById('specRows');
        var addSpecRowBtn = document.getElementById('addSpecRowBtn');
        var descriptionInput = document.getElementById('description');
        var form = document.getElementById('productForm');
        var initialSpecs = descriptionInput ? descriptionInput.value : '';

        function createSpecRow(key, value) {
            var row = document.createElement('div');
            row.className = 'row g-2 align-items-center spec-row';
            row.innerHTML =
                '<div class="col-md-5">' +
                    '<input type="text" class="admin-form-control spec-key" placeholder="Tên thông số (VD: Camera sau)" />' +
                '</div>' +
                '<div class="col-md-6">' +
                    '<input type="text" class="admin-form-control spec-value" placeholder="Giá trị (VD: 50MP + 12MP)" />' +
                '</div>' +
                '<div class="col-md-1">' +
                    '<button type="button" class="admin-btn admin-btn-outline admin-btn-sm spec-remove" title="Xóa dòng"><i class="bi bi-trash"></i></button>' +
                '</div>';

            var keyInput = row.querySelector('.spec-key');
            var valueInput = row.querySelector('.spec-value');
            var removeBtn = row.querySelector('.spec-remove');

            keyInput.value = key || '';
            valueInput.value = value || '';

            keyInput.addEventListener('input', syncSpecsToDescription);
            valueInput.addEventListener('input', syncSpecsToDescription);
            removeBtn.addEventListener('click', function() {
                row.remove();
                if (specRows.children.length === 0) {
                    createSpecRow('', '');
                }
                syncSpecsToDescription();
            });

            specRows.appendChild(row);
        }

        function syncSpecsToDescription() {
            var lines = [];
            specRows.querySelectorAll('.spec-row').forEach(function(row) {
                var k = row.querySelector('.spec-key').value.trim();
                var v = row.querySelector('.spec-value').value.trim();
                if (!k && !v) return;
                if (k && v) lines.push(k + ': ' + v);
                else if (k) lines.push(k + ':');
                else lines.push(v);
            });
            descriptionInput.value = lines.join('\n');
        }

        function initSpecs() {
            if (initialSpecs && initialSpecs.trim().length > 0) {
                initialSpecs.split(/\r?\n/).forEach(function(line) {
                    var text = line.trim();
                    if (!text) return;
                    var idx = text.indexOf(':');
                    if (idx > -1) {
                        createSpecRow(text.substring(0, idx).trim(), text.substring(idx + 1).trim());
                    } else {
                        createSpecRow(text, '');
                    }
                });
            }

            if (specRows.children.length === 0) {
                createSpecRow('', '');
            }
            syncSpecsToDescription();
        }

        if (addSpecRowBtn) {
            addSpecRowBtn.addEventListener('click', function() {
                createSpecRow('', '');
            });
        }

        if (form) {
            form.addEventListener('submit', function() {
                syncSpecsToDescription();
            });
        }

        initSpecs();

        var colorInput = document.getElementById('color');
        var previewWrapper = document.getElementById('colorPreviewWrapper');
        var previewContainer = document.getElementById('colorPreviewContainer');

        var colorMap = {
            "đen": "#111827",
            "den": "#111827",
            "trắng": "#FFFFFF",
            "trang": "#FFFFFF",
            "bạc": "#C0C0C0",
            "bac": "#C0C0C0",
            "xám": "#6B7280",
            "xam": "#6B7280",
            "đỏ": "#EF4444",
            "do": "#EF4444",
            "xanh dương": "#2563EB",
            "xanh duong": "#2563EB",
            "xanh lá": "#10B981",
            "xanh la": "#10B981",
            "xanh lục": "#10B981",
            "xanh luc": "#10B981",
            "tím": "#8B5CF6",
            "tim": "#8B5CF6",
            "hồng": "#EC4899",
            "hong": "#EC4899",
            "vàng": "#F59E0B",
            "vang": "#F59E0B",
            "cam": "#FB923C",
            "nâu": "#92400E",
            "nau": "#92400E",
            "xanh ngọc": "#14B8A6",
            "xanh ngoc": "#14B8A6",
            "xanh rêu": "#65A30D",
            "xanh reu": "#65A30D",
            "hồng nhạt": "#F9A8D4",
            "hong nhat": "#F9A8D4",
            "xám đậm": "#374151",
            "xam dam": "#374151",
            "trắng sữa": "#F8FAFC",
            "trang sua": "#F8FAFC"
        };

        function getCssColor(label) {
            var normalized = label.trim().toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            normalized = normalized.replace(/[^a-z0-9 ]+/g, ' ').replace(/\s+/g, ' ').trim();
            return colorMap[normalized] || label;
        }

        function renderColorPreview() {
            var value = colorInput.value.trim();
            previewContainer.innerHTML = '';

            if (value.length === 0) {
                previewWrapper.style.display = 'none';
                return;
            }

            previewWrapper.style.display = 'flex';
            var colors = value.split(/[,;/]+/).map(function(token) { return token.trim(); }).filter(function(token) { return token.length > 0; });

            colors.forEach(function(colorLabel) {
                var cssColor = getCssColor(colorLabel);
                var option = document.createElement('div');
                option.className = 'product-color-option';
                option.title = colorLabel;

                var swatch = document.createElement('div');
                swatch.className = 'product-color-swatch';
                swatch.style.background = cssColor;
                swatch.style.border = cssColor === 'transparent' ? '1px solid #D1D5DB' : '1px solid rgba(0, 0, 0, 0.08)';

                var label = document.createElement('div');
                label.className = 'product-color-name';
                label.textContent = colorLabel;

                option.appendChild(swatch);
                option.appendChild(label);
                previewContainer.appendChild(option);
            });
        }

        colorInput.addEventListener('input', renderColorPreview);
        renderColorPreview();
    });
</script>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
