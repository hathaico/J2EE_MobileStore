
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="activePage" value="products" scope="request" />
<c:set var="pageTitle" value="Quản Lý Sản Phẩm" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Bộ lọc sản phẩm kiểu mới giống đơn hàng -->
<div class="admin-card shadow-sm mb-3" style="border-radius:18px;overflow:hidden;background:var(--admin-primary-bg);">
    <div class="admin-toolbar align-items-center flex-wrap gap-3 p-3 pb-2" style="border-bottom:none;border-radius:18px;">
        <form method="get" class="admin-toolbar-form d-flex align-items-center flex-wrap gap-3 mb-0 w-100">
            <div class="admin-toolbar-search flex-shrink-0" style="min-width:220px;">
                <i class="bi bi-search search-icon"></i>
                <input type="text" name="q" value="${qFilter}" placeholder="Tên, mã hoặc model..." class="form-control rounded-3" style="padding-left:2.2rem;min-width:180px;">
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Hãng:</label>
                <select name="brand" class="admin-form-select rounded-3">
                    <option value="">Tất cả</option>
                    <c:forEach var="b" items="${brands}">
                        <option value="${b}" ${brandFilter == b ? 'selected' : ''}>${b}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Danh mục:</label>
                <select name="category" class="admin-form-select rounded-3">
                    <option value="">Tất cả</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}" ${categoryFilter == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Trạng thái:</label>
                <select name="status" class="admin-form-select rounded-3">
                    <option value="">Tất cả</option>
                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Còn hàng</option>
                    <option value="low" ${statusFilter == 'low' ? 'selected' : ''}>Sắp hết</option>
                    <option value="out" ${statusFilter == 'out' ? 'selected' : ''}>Hết hàng</option>
                </select>
            </div>
            <button type="submit" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-funnel"></i> Lọc</button>
            <div class="ms-auto d-flex align-items-center gap-2">
                <c:if test="${not empty qFilter || not empty brandFilter || not empty categoryFilter || not empty statusFilter}">
                    <a href="${ctx}/admin/products" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2" title="Xóa bộ lọc" style="gap:4px;"><i class="bi bi-x-circle"></i> Xóa lọc</a>
                </c:if>
                <a href="${ctx}/admin/products?action=add" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-plus-circle"></i> Thêm mới</a>
                <button type="submit" formaction="${ctx}/admin/products?action=exportExcel" formmethod="get" class="btn btn-success btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-file-earmark-excel"></i> Xuất Excel</button>
            </div>
        </form>
    </div>
</div>

<c:if test="${not empty products}">
    <div class="admin-card">
        <div class="admin-card-body p-0">
            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên sản phẩm</th>
                            <th class="text-center">Hãng</th>
                            <th class="text-center">Danh mục</th>
                            <th>Giá</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td><strong>${product.productId}</strong></td>
                                <td>
                                    <div class="product-cell product-cell--left">
                                        <c:set var="img" value="${fn:trim(product.imageUrl)}" />
                                        <c:choose>
                                            <c:when test="${empty img}">
                                                <div class="product-image-placeholder">
                                                    <i class="bi bi-image"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${fn:startsWith(img, 'http://') or fn:startsWith(img, 'https://')}">
                                                <img src="${img}" alt="">
                                            </c:when>
                                            <c:when test="${fn:startsWith(img, '/')}">
                                                <img src="${ctx}${img}" alt="">
                                            </c:when>
                                            <c:when test="${fn:contains(img, 'assets/images/products')}">
                                                <img src="${ctx}/${img}" alt="">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${ctx}/assets/images/products/${img}" alt="">
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <div class="product-name">${product.productName}</div>
                                            <div class="product-sub">${product.model}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">${product.brand}</td>
                                <td class="text-center">
                                    <span class="admin-badge admin-badge-gray">
                                        <c:choose>
                                            <c:when test="${not empty product.categoryName}">${product.categoryName}</c:when>
                                            <c:when test="${not empty product.categoryId}">Danh mục #${product.categoryId}</c:when>
                                            <c:otherwise>Chưa phân loại</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td class="text-right font-bold">
                                    <fmt:formatNumber value="${product.price}" pattern="#,##0 ₫"/>
                                </td>
                                <td class="text-center">${product.stockQuantity}</td>
                                <td class="text-center">
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
                                <td class="text-center">
                                    <div class="admin-action-group">
                                        <a href="${ctx}/products?action=detail&id=${product.productId}" class="admin-action-btn btn-view" title="Xem" target="_blank">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${ctx}/admin/products?action=edit&id=${product.productId}" class="admin-action-btn btn-edit" title="Sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form id="deleteForm_${product.productId}" action="${ctx}/admin/products" method="get" class="d-none">
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
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</c:if>
<c:if test="${empty products}">
    <div class="admin-card">
        <div class="admin-card-body">
            Không có sản phẩm nào.
        </div>
    </div>
</c:if>

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
