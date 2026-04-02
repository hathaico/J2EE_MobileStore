<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activePage" value="vouchers" scope="request" />
<c:set var="pageTitle" value="Tạo voucher - Admin" scope="request" />
<c:set var="adminHideContentHeaderTitle" value="true" scope="request" />
<c:set var="adminHeaderBackHref" value="${pageContext.request.contextPath}/admin/vouchers" scope="request" />
<c:set var="adminHeaderBackLabel" value="Danh sách voucher" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<div class="admin-form-page">
    <c:if test="${not empty error}">
        <div class="admin-alert admin-alert-danger mb-3">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="admin-alert admin-alert-success mb-3">${success}</div>
    </c:if>

    <div class="admin-card shadow-sm">
        <div class="admin-card-header">
            <h5><i class="bi bi-ticket-perforated"></i> Tạo voucher mới</h5>
        </div>
        <div class="admin-card-body">
            <form id="voucherForm" action="${ctx}/admin/voucher-create" method="post" class="needs-validation" novalidate>
                <div class="admin-form-section admin-form-section--boxed">
                    <div class="admin-form-section__head">
                        <h6 class="admin-form-section__title"><i class="bi bi-tag"></i> Mã &amp; mô tả</h6>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="code" class="admin-form-label">Mã voucher <span class="admin-required">*</span></label>
                            <input type="text" class="admin-form-control text-uppercase" id="code" name="code" required placeholder="VD: SALE30">
                            <p class="admin-form-hint mb-0">Viết liền, không dấu. Hệ thống có thể chuẩn hóa khi lưu.</p>
                        </div>
                        <div class="col-md-6">
                            <label for="description" class="admin-form-label">Mô tả ngắn</label>
                            <input type="text" class="admin-form-control" id="description" name="description" placeholder="Giảm cho đơn từ 500k…">
                        </div>
                    </div>
                </div>

                <div class="admin-form-section admin-form-section--boxed">
                    <div class="admin-form-section__head">
                        <h6 class="admin-form-section__title"><i class="bi bi-percent"></i> Giá trị giảm</h6>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label for="discountType" class="admin-form-label">Loại giảm <span class="admin-required">*</span></label>
                            <select class="admin-form-select" id="discountType" name="discountType" required>
                                <option value="PERCENT">Phần trăm (%)</option>
                                <option value="AMOUNT">Số tiền cố định (VNĐ)</option>
                            </select>
                            <div class="admin-field-error" id="errDiscountType"></div>
                        </div>
                        <div class="col-md-4">
                            <label for="discountValue" class="admin-form-label">Giá trị <span class="admin-required">*</span></label>
                            <input type="number" step="0.01" min="0" class="admin-form-control" id="discountValue" name="discountValue" required placeholder="10 hoặc 50000">
                            <div class="admin-field-error" id="errDiscountValue"></div>
                        </div>
                        <div class="col-md-4">
                            <label for="maxDiscount" class="admin-form-label">Giảm tối đa (VNĐ)</label>
                            <input type="number" step="0.01" min="0" class="admin-form-control" id="maxDiscount" name="maxDiscount" placeholder="Áp dụng khi giảm %">
                            <p class="admin-form-hint mb-0">Bỏ trống nếu không giới hạn.</p>
                        </div>
                        <div class="col-md-6">
                            <label for="minOrderValue" class="admin-form-label">Giá trị đơn tối thiểu</label>
                            <input type="number" step="0.01" min="0" class="admin-form-control" id="minOrderValue" name="minOrderValue" placeholder="0">
                        </div>
                        <div class="col-md-6">
                            <label for="quantity" class="admin-form-label">Số lượng mã</label>
                            <input type="number" min="0" class="admin-form-control" id="quantity" name="quantity" placeholder="Số lần dùng tối đa">
                        </div>
                    </div>
                </div>

                <div class="admin-form-section admin-form-section--boxed mb-0">
                    <div class="admin-form-section__head">
                        <h6 class="admin-form-section__title"><i class="bi bi-calendar-event"></i> Thời gian &amp; trạng thái</h6>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label for="startDate" class="admin-form-label">Ngày bắt đầu</label>
                            <input type="date" class="admin-form-control" id="startDate" name="startDate">
                        </div>
                        <div class="col-md-4">
                            <label for="endDate" class="admin-form-label">Ngày kết thúc</label>
                            <input type="date" class="admin-form-control" id="endDate" name="endDate">
                        </div>
                        <div class="col-md-4">
                            <label for="isActive" class="admin-form-label">Kích hoạt</label>
                            <select class="admin-form-select" id="isActive" name="isActive">
                                <option value="true">Đang hoạt động</option>
                                <option value="false">Tạm tắt</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="admin-save-bar">
                    <a href="${ctx}/admin/vouchers" class="admin-btn admin-btn-outline admin-btn-sm">Hủy</a>
                    <button type="submit" class="admin-btn admin-btn-primary admin-btn-sm"><i class="bi bi-check2-circle"></i> Tạo voucher</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
