<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<c:set var="pageTitle" value="Chi Tiết Đơn Hàng #${order.orderId} - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-receipt"></i> Đơn hàng #${order.orderId}</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <a href="${ctx}/admin/orders">Đơn hàng</a>
            <i class="bi bi-chevron-right"></i>
            <span>#${order.orderId}</span>
        </div>
    </div>
    <a href="${ctx}/admin/orders" class="admin-btn admin-btn-outline">
        <i class="bi bi-arrow-left"></i> Quay lại
    </a>
</div>

<div class="row g-4">
    <!-- Order Info (Left Column) -->
    <div class="col-xl-8">
        <!-- Order Info Card -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-info-circle"></i> Thông tin đơn hàng</h5>
                <div style="display:flex; gap:8px;">
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
                    </c:choose>
                    <c:choose>
                        <c:when test="${order.paymentStatus == 'PAID'}">
                            <span class="admin-badge admin-badge-success"><i class="bi bi-check"></i> Đã thanh toán</span>
                        </c:when>
                        <c:otherwise>
                            <span class="admin-badge admin-badge-gray">Chưa thanh toán</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="admin-card-body">
                <div class="row" style="margin-bottom:20px;">
                    <div class="col-sm-6">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Mã đơn hàng</div>
                        <div style="font-weight:700; font-size:1.05rem;">#${order.orderId}</div>
                    </div>
                    <div class="col-sm-6">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Ngày đặt</div>
                        <div style="font-weight:600;"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>

                <div class="row" style="margin-bottom:20px;">
                    <div class="col-sm-6">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Phương thức thanh toán</div>
                        <div style="font-weight:600;">${order.paymentMethodLabel}</div>
                    </div>
                    <c:if test="${order.updatedAt != null}">
                        <div class="col-sm-6">
                            <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Cập nhật lần cuối</div>
                            <div style="font-weight:600;"><fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Customer Info Card -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-person"></i> Thông tin khách hàng</h5>
            </div>
            <div class="admin-card-body">
                <div class="row">
                    <div class="col-sm-6" style="margin-bottom:16px;">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Họ tên</div>
                        <div style="font-weight:600;">${order.customerName}</div>
                    </div>
                    <div class="col-sm-6" style="margin-bottom:16px;">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Điện thoại</div>
                        <div style="font-weight:600;">${order.customerPhone}</div>
                    </div>
                    <c:if test="${not empty order.customerEmail}">
                        <div class="col-sm-6" style="margin-bottom:16px;">
                            <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Email</div>
                            <div style="font-weight:600;">${order.customerEmail}</div>
                        </div>
                    </c:if>
                    <div class="col-12">
                        <div style="font-size:0.82rem; color:var(--admin-text-muted); margin-bottom:4px;">Địa chỉ giao hàng</div>
                        <div style="font-weight:600;">${order.shippingAddress}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Items Card -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-bag"></i> Sản phẩm đã đặt</h5>
            </div>
            <div class="admin-card-body p-0">
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th style="text-align:center;">Số lượng</th>
                                <th style="text-align:right;">Đơn giá</th>
                                <th style="text-align:right;">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td style="font-weight:600;">${item.productName}</td>
                                    <td style="text-align:center;">${item.quantity}</td>
                                    <td style="text-align:right;">
                                        <fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                                    </td>
                                    <td style="text-align:right; font-weight:700;">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div style="padding:16px 20px; border-top:2px solid var(--admin-border); display:flex; justify-content:flex-end; align-items:center; gap:12px;">
                    <span style="font-weight:600; color:var(--admin-text-secondary);">Tổng cộng:</span>
                    <span style="font-size:1.25rem; font-weight:800; color:var(--admin-danger);">
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencyCode="VND" pattern="#,##0 ₫"/>
                    </span>
                </div>
            </div>
        </div>

        <!-- Notes -->
        <c:if test="${not empty order.notes}">
            <div class="admin-card">
                <div class="admin-card-header">
                    <h5><i class="bi bi-chat-left-text"></i> Ghi chú</h5>
                </div>
                <div class="admin-card-body">
                    <p style="margin:0; color:var(--admin-text-secondary);">${order.notes}</p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Actions (Right Column) -->
    <div class="col-xl-4">
        <!-- Update Status -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-arrow-repeat"></i> Cập nhật trạng thái</h5>
            </div>
            <div class="admin-card-body">
                <form action="${ctx}/admin/orders" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="orderId" value="${order.orderId}">

                    <div style="margin-bottom:16px;">
                        <label for="status" class="admin-form-label">Trạng thái đơn hàng</label>
                        <select class="admin-form-select" id="status" name="status">
                            <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="SHIPPING" ${order.status == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Đã giao hàng</option>
                            <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>

                    <button type="submit" class="admin-btn admin-btn-primary" style="width:100%;">
                        <i class="bi bi-check-circle"></i> Cập nhật
                    </button>
                </form>
            </div>
        </div>

        <!-- Update Payment -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h5><i class="bi bi-credit-card"></i> Thanh toán</h5>
            </div>
            <div class="admin-card-body">
                <form action="${ctx}/admin/orders" method="post">
                    <input type="hidden" name="action" value="updatePayment">
                    <input type="hidden" name="orderId" value="${order.orderId}">

                    <div style="margin-bottom:16px;">
                        <label for="paymentStatus" class="admin-form-label">Trạng thái thanh toán</label>
                        <select class="admin-form-select" id="paymentStatus" name="paymentStatus">
                            <option value="UNPAID" ${order.paymentStatus == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="PAID" ${order.paymentStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                        </select>
                    </div>

                    <button type="submit" class="admin-btn admin-btn-success" style="width:100%;">
                        <i class="bi bi-check-circle"></i> Cập nhật
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
