<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<c:set var="pageTitle" value="Quản Lý Đơn Hàng - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-receipt"></i> Quản lý đơn hàng</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <span>Đơn hàng</span>
        </div>
    </div>
</div>

<!-- Alert Messages -->
<c:if test="${not empty param.success}">
    <div class="admin-alert admin-alert-success" data-auto-dismiss>
        <i class="bi bi-check-circle-fill"></i> ${param.success}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="admin-alert admin-alert-danger" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${param.error}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<!-- Orders Table Card -->
<div class="admin-card">
    <div class="admin-toolbar">
        <div class="admin-toolbar-search">
            <i class="bi bi-search search-icon"></i>
            <input type="text" placeholder="Tìm đơn hàng..." data-table-search="ordersTable">
        </div>

        <form method="get" style="display:flex; align-items:center; gap:10px; margin-left:auto;">
            <label style="font-size:0.85rem; font-weight:600; color:var(--admin-text-secondary); white-space:nowrap;">Trạng thái:</label>
            <select class="admin-form-select" name="status" onchange="this.form.submit()" style="width:auto; min-width:170px; padding:7px 12px;">
                <option value="">Tất cả</option>
                <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                <option value="SHIPPING" ${statusFilter == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                <option value="DELIVERED" ${statusFilter == 'DELIVERED' ? 'selected' : ''}>Đã giao hàng</option>
                <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
            </select>
            <c:if test="${not empty statusFilter}">
                <a href="${ctx}/admin/orders" style="color:var(--admin-text-muted); font-size:0.85rem; text-decoration:none;" title="Xóa bộ lọc">
                    <i class="bi bi-x-circle"></i>
                </a>
            </c:if>
        </form>
    </div>

    <div class="admin-card-body p-0">
        <div class="table-responsive">
            <table class="admin-table" id="ordersTable">
                <thead>
                    <tr>
                        <th>Mã ĐH</th>
                        <th>Khách hàng</th>
                        <th style="text-align:right;">Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Thanh toán</th>
                        <th>Ngày đặt</th>
                        <th style="text-align:center;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td><strong>#${order.orderId}</strong></td>
                            <td>
                                <div style="font-weight:600;">${order.customerName}</div>
                                <div style="font-size:0.78rem; color:var(--admin-text-muted);">${order.customerPhone}</div>
                            </td>
                            <td style="text-align:right; font-weight:700;">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}">
                                        <span class="admin-badge admin-badge-warning"><i class="bi bi-clock"></i> Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CONFIRMED'}">
                                        <span class="admin-badge admin-badge-info"><i class="bi bi-check-circle"></i> Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPING'}">
                                        <span class="admin-badge admin-badge-primary"><i class="bi bi-truck"></i> Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status == 'DELIVERED'}">
                                        <span class="admin-badge admin-badge-success"><i class="bi bi-check2-all"></i> Đã giao</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CANCELLED'}">
                                        <span class="admin-badge admin-badge-danger"><i class="bi bi-x-circle"></i> Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-gray">${order.statusLabel}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID'}">
                                        <span class="admin-badge admin-badge-success"><i class="bi bi-check"></i> Đã TT</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-gray">Chưa TT</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="font-size:0.85rem; color:var(--admin-text-secondary);">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td style="text-align:center;">
                                <a href="${ctx}/admin/orders?action=detail&id=${order.orderId}" class="admin-action-btn btn-view" title="Chi tiết">
                                    <i class="bi bi-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7">
                                <div class="admin-empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <p>Không có đơn hàng nào</p>
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
