<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Quản lý Voucher" />
<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
<div class="admin-card shadow-sm mb-3" style="border-radius:18px;overflow:hidden;background:var(--admin-primary-bg);">
    <div class="admin-toolbar align-items-center flex-wrap gap-3 p-3 pb-2" style="border-bottom:none;border-radius:18px;">
        <form method="get" class="admin-toolbar-form d-flex align-items-center flex-wrap gap-3 mb-0 w-100">
            <div class="admin-toolbar-search flex-shrink-0" style="min-width:220px;">
                <i class="bi bi-search search-icon"></i>
                <input type="text" name="q" value="${qFilter}" placeholder="Mã hoặc mô tả..." class="form-control rounded-3" style="padding-left:2.2rem;min-width:180px;">
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Loại:</label>
                <select name="type" class="admin-form-select rounded-3">
                    <option value="">Tất cả loại</option>
                    <option value="PERCENT" ${typeFilter == 'PERCENT' ? 'selected' : ''}>Phần trăm</option>
                    <option value="AMOUNT" ${typeFilter == 'AMOUNT' ? 'selected' : ''}>Tiền mặt</option>
                </select>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Trạng thái:</label>
                <select name="active" class="admin-form-select rounded-3">
                    <option value="">Tất cả trạng thái</option>
                    <option value="true" ${activeFilter == 'true' ? 'selected' : ''}>Kích hoạt</option>
                    <option value="false" ${activeFilter == 'false' ? 'selected' : ''}>Ẩn</option>
                </select>
            </div>
            <button type="submit" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-funnel"></i> Lọc</button>
            <div class="ms-auto d-flex align-items-center gap-2">
                <c:if test="${not empty qFilter || not empty typeFilter || not empty activeFilter}">
                    <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2" title="Xóa bộ lọc"><i class="bi bi-x-circle"></i> Xóa lọc</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/voucher-create" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-plus-circle"></i> Thêm mới</a>
                <button type="submit" formaction="${pageContext.request.contextPath}/admin/vouchers?action=exportExcel" formmethod="get" class="btn btn-success btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-file-earmark-excel"></i> Xuất Excel</button>
            </div>
        </form>
    </div>
</div>

<div class="admin-card shadow-sm" style="border-radius:18px;overflow:hidden;">
    <div class="admin-card-body p-0" style="background:#fff;border-radius:0 0 18px 18px;">
        <div class="table-responsive">
            <table class="admin-table align-middle">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã</th>
                        <th>Mô tả</th>
                        <th>Loại</th>
                        <th>Giá trị</th>
                        <th>Đơn tối thiểu</th>
                        <th>Giảm tối đa</th>
                        <th>Số lượng</th>
                        <th>Đã dùng</th>
                        <th>Hiệu lực</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${vouchers}">
                        <tr>
                            <td>${v.voucherId}</td>
                            <td><span class="admin-badge admin-badge-primary rounded-pill px-3 py-2"><i class="bi bi-ticket-perforated"></i> ${v.code}</span></td>
                            <td>
                                <span title="${v.description}">
                                    <c:choose>
                                        <c:when test="${not empty v.description}">
                                            <c:out value="${fn:length(v.description) > 30 ? fn:substring(v.description, 0, 30) + '...' : v.description}"/>
                                        </c:when>
                                        <c:otherwise><span class="admin-text-muted">(Không có)</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.discountType eq 'PERCENT'}">
                                        <span class="admin-badge admin-badge-info rounded-pill px-3 py-2"><i class="bi bi-percent"></i> %</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-warning rounded-pill px-3 py-2"><i class="bi bi-cash"></i> VNĐ</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatNumber value="${v.discountValue}" pattern="#,##0"/>
                                <c:choose><c:when test="${v.discountType eq 'PERCENT'}">%</c:when><c:otherwise>₫</c:otherwise></c:choose>
                            </td>
                            <td><fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0₫"/></td>
                            <td><fmt:formatNumber value="${v.maxDiscount}" pattern="#,##0₫"/></td>
                            <td>
                                <span class="admin-badge admin-badge-secondary rounded-pill px-3 py-2">${v.quantity != null ? v.quantity : '∞'}</span>
                            </td>
                            <td>
                                <span class="admin-badge admin-badge-light rounded-pill px-3 py-2">${v.usedCount}</span>
                            </td>
                            <td>
                                <span class="admin-badge admin-badge-light rounded-pill px-3 py-2">
                                    <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.active}"><span class="admin-badge admin-badge-success rounded-pill px-3 py-2"><i class="bi bi-check-circle"></i> Kích hoạt</span></c:when>
                                    <c:otherwise><span class="admin-badge admin-badge-secondary rounded-pill px-3 py-2"><i class="bi bi-x-circle"></i> Ẩn</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/admin/voucher-edit?id=${v.voucherId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Sửa" style="min-width:36px;gap:4px;"><i class="bi bi-pencil"></i></a>
                                <form id="deleteVoucherForm_${v.voucherId}" action="${pageContext.request.contextPath}/admin/voucher-delete" method="post" style="display:none;">
                                    <input type="hidden" name="id" value="${v.voucherId}" />
                                </form>
                                <button type="button" class="btn btn-outline-danger btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Xóa" style="min-width:36px;gap:4px;"
                                    onclick="adminConfirmDelete('deleteVoucherForm_${v.voucherId}', '${v.code}')">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Delete Confirmation Modal (dùng chung cho các trang admin) -->
<div class="admin-modal-overlay" id="deleteModal">
    <div class="admin-modal shadow-sm" style="border-radius:18px;max-width:350px;">
        <div class="modal-icon mb-2">
            <i class="bi bi-trash"></i>
        </div>
        <h3 class="mb-2">Xác nhận xóa</h3>
        <p class="mb-3">Bạn có chắc muốn xóa voucher "<span id="deleteItemName"></span>"?</p>
        <div class="admin-modal-actions d-flex gap-2 justify-content-end">
            <button class="btn btn-outline-secondary btn-sm rounded-3" onclick="adminCloseModal('deleteModal')">Hủy</button>
            <button class="btn btn-danger btn-sm rounded-3" id="deleteConfirmBtn">Xóa</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
