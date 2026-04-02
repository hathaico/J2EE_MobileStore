<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="pageTitle" value="Chỉnh sửa Voucher" />
<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>

<div class="admin-content-header d-flex align-items-center justify-content-between mb-3">
    <h2 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Chỉnh sửa Voucher</h2>
    <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left"></i> Quay lại</a>
</div>
<div class="admin-card shadow-sm">
    <div class="admin-card-body">
        <c:if test="${not empty success}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="bi bi-check-circle-fill"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="bi bi-x-circle-fill"></i> ${error}
            </div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/admin/voucher-edit" autocomplete="off">
            <input type="hidden" name="id" value="${voucher.voucherId}" />
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold"><i class="bi bi-upc-scan me-1"></i> Mã voucher</label>
                    <input type="text" name="code" class="form-control" value="${voucher.code}" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold"><i class="bi bi-card-text me-1"></i> Mô tả</label>
                    <textarea name="description" class="form-control" rows="1">${voucher.description}</textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-percent me-1"></i> Loại giảm giá</label>
                    <select name="discountType" class="form-select">
                        <option value="PERCENT" ${voucher.discountType == 'PERCENT' ? 'selected' : ''}>Phần trăm (%)</option>
                        <option value="AMOUNT" ${voucher.discountType == 'AMOUNT' ? 'selected' : ''}>Số tiền (VNĐ)</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-cash-coin me-1"></i> Giá trị giảm</label>
                    <input type="number" name="discountValue" class="form-control" value="${voucher.discountValue}" required />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-bag-check me-1"></i> Đơn tối thiểu</label>
                    <input type="number" name="minOrderValue" class="form-control" value="${voucher.minOrderValue}" />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-arrow-down-up me-1"></i> Giảm tối đa</label>
                    <input type="number" name="maxDiscount" class="form-control" value="${voucher.maxDiscount}" />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-123 me-1"></i> Số lượng</label>
                    <input type="number" name="quantity" class="form-control" value="${voucher.quantity}" />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-calendar-event me-1"></i> Ngày bắt đầu</label>
                    <input type="date" name="startDate" class="form-control" value="${voucher.startDate}" />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-calendar2-x me-1"></i> Ngày kết thúc</label>
                    <input type="date" name="endDate" class="form-control" value="${voucher.endDate}" />
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold"><i class="bi bi-toggle-on me-1"></i> Trạng thái</label>
                    <select name="isActive" class="form-select">
                        <option value="true" ${voucher.active ? 'selected' : ''}>Kích hoạt</option>
                        <option value="false" ${!voucher.active ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>
            </div>
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary px-4"><i class="bi bi-save me-1"></i> Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary"><i class="bi bi-x-circle"></i> Hủy</a>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
