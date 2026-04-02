<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<c:set var="pageTitle" value="Quản Lý Đơn Hàng" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Alert Messages -->
<c:if test="${not empty param.success}">
    <div class="admin-alert admin-alert-success d-flex align-items-center justify-content-between gap-3 shadow-sm" data-auto-dismiss style="border-radius: 12px;">
        <span><i class="bi bi-check-circle-fill me-2"></i> ${param.success}</span>
        <button class="alert-close btn btn-light btn-sm rounded-circle border-0 d-flex align-items-center justify-content-center" style="width:32px;height:32px;transition:background 0.15s;" title="Đóng">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="admin-alert admin-alert-danger d-flex align-items-center justify-content-between gap-3 shadow-sm" data-auto-dismiss style="border-radius: 12px;">
        <span><i class="bi bi-exclamation-circle-fill me-2"></i> ${param.error}</span>
        <button class="alert-close btn btn-light btn-sm rounded-circle border-0 d-flex align-items-center justify-content-center" style="width:32px;height:32px;transition:background 0.15s;" title="Đóng">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>
</c:if>

<!-- Orders Table Card -->

<div class="admin-card shadow-sm" style="border-radius:18px;overflow:hidden;">
    <div class="admin-toolbar align-items-center flex-wrap gap-3 p-3 pb-2" style="background:var(--admin-primary-bg);border-bottom:1px solid var(--admin-border);border-radius:18px 18px 0 0;">
        <div class="admin-toolbar-search flex-shrink-0" style="min-width:220px;">
            <i class="bi bi-search search-icon"></i>
            <input type="text" placeholder="Tìm đơn hàng..." data-table-search="ordersTable" class="form-control rounded-3" style="padding-left:2.2rem;min-width:180px;">
        </div>
        <form method="get" class="admin-toolbar-form d-flex align-items-center flex-wrap gap-3 mb-0">
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Trạng thái:</label>
                <select class="admin-form-select rounded-3" name="status" onchange="this.form.submit()">
                    <option value="">Tất cả</option>
                    <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                    <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="SHIPPING" ${statusFilter == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                    <option value="DELIVERED" ${statusFilter == 'DELIVERED' ? 'selected' : ''}>Đã giao hàng</option>
                    <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Từ ngày:</label>
                <input type="date" name="startDate" value="${startDateFilter}" class="admin-form-input rounded-3" onchange="this.form.submit()"/>
            </div>
            <div class="d-flex align-items-center gap-2">
                <label class="admin-toolbar-label fw-semibold mb-0">Đến ngày:</label>
                <input type="date" name="endDate" value="${endDateFilter}" class="admin-form-input rounded-3" onchange="this.form.submit()"/>
            </div>
            <c:if test="${not empty statusFilter || not empty startDateFilter || not empty endDateFilter}">
                <a href="${ctx}/admin/orders" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center" title="Xóa bộ lọc" style="gap:4px;">
                    <i class="bi bi-x-circle"></i> Xóa lọc
                </a>
            </c:if>
        </form>
    </div>
    <div class="admin-card-body p-0" style="background:#fff;border-radius:0 0 18px 18px;">
        <div class="table-responsive">
            <table class="admin-table align-middle" id="ordersTable" style="margin-bottom:0;">
                <thead>
                    <tr>
                        <th>Mã ĐH</th>
                        <th>Khách hàng</th>
                        <th class="text-end">Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Thanh toán</th>
                        <th>Ngày đặt</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td><strong>#${order.orderId}</strong></td>
                            <td>
                                <div class="fw-bold">${order.customerName}</div>
                                <div class="text-muted small">${order.customerPhone}</div>
                            </td>
                            <td style="text-align:right; font-weight:700;">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}">
                                        <span class="admin-badge admin-badge-warning rounded-pill px-3 py-2"><i class="bi bi-clock"></i> Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CONFIRMED'}">
                                        <span class="admin-badge admin-badge-info rounded-pill px-3 py-2"><i class="bi bi-check-circle"></i> Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPING'}">
                                        <span class="admin-badge admin-badge-primary rounded-pill px-3 py-2"><i class="bi bi-truck"></i> Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status == 'DELIVERED'}">
                                        <span class="admin-badge admin-badge-success rounded-pill px-3 py-2"><i class="bi bi-check2-all"></i> Đã giao</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CANCELLED'}">
                                        <span class="admin-badge admin-badge-danger rounded-pill px-3 py-2"><i class="bi bi-x-circle"></i> Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-gray rounded-pill px-3 py-2">${order.statusLabel}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                        <span class="admin-badge admin-badge-success rounded-pill px-3 py-2"><i class="bi bi-check"></i> Đã TT</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-gray rounded-pill px-3 py-2">Chưa TT</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="font-size:0.85rem; color:var(--admin-text-secondary);">
                                <span class="text-muted small">${order.createdAtString}</span>
                            </td>
                            <td style="text-align:center;">
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}">
                                        <div class="btn-group gap-2 d-flex justify-content-center" role="group">
                                            <form action="${ctx}/admin/orders" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="confirm">
                                                <input type="hidden" name="id" value="${order.orderId}">
                                                <button type="submit" class="btn btn-success btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Xác nhận" onclick="return confirm('Xác nhận đơn hàng #${order.orderId}?')" style="gap:4px;">
                                                    <i class="bi bi-check-circle"></i> Xác nhận
                                                </button>
                                            </form>
                                            <a href="${ctx}/admin/orders?action=detail&id=${order.orderId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Chi tiết" style="gap:4px;">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/admin/orders?action=detail&id=${order.orderId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Chi tiết" style="gap:4px;">
                                            <i class="bi bi-eye"></i> Chi tiết
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7">
                                <div class="admin-empty-state py-5">
                                    <i class="bi bi-inbox" style="font-size:2rem;"></i>
                                    <p class="mt-2 mb-0">Không có đơn hàng nào</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
