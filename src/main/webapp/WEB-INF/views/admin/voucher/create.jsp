<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<div class="admin-main-content">
    <div class="container mt-4">
        <h2>Thêm Voucher Mới</h2>
        <form action="${ctx}/admin/voucher-create" method="post" class="row g-3">
            <div class="col-md-6">
                <label for="code" class="form-label">Mã voucher</label>
                <input type="text" class="form-control" id="code" name="code" required>
            </div>
            <div class="col-md-6">
                <label for="description" class="form-label">Mô tả</label>
                <input type="text" class="form-control" id="description" name="description">
            </div>
            <div class="col-md-4">
                <label for="discountType" class="form-label">Loại giảm giá</label>
                <select class="form-select" id="discountType" name="discountType" required>
                    <option value="PERCENT">Phần trăm (%)</option>
                    <option value="AMOUNT">Số tiền (VNĐ)</option>
                </select>
            </div>
            <div class="col-md-4">
                <label for="discountValue" class="form-label">Giá trị giảm</label>
                <input type="number" step="0.01" class="form-control" id="discountValue" name="discountValue" required>
            </div>
            <div class="col-md-4">
                <label for="minOrderValue" class="form-label">Đơn tối thiểu</label>
                <input type="number" step="0.01" class="form-control" id="minOrderValue" name="minOrderValue">
            </div>
            <div class="col-md-4">
                <label for="maxDiscount" class="form-label">Giảm tối đa</label>
                <input type="number" step="0.01" class="form-control" id="maxDiscount" name="maxDiscount">
            </div>
            <div class="col-md-4">
                <label for="quantity" class="form-label">Số lượng</label>
                <input type="number" class="form-control" id="quantity" name="quantity">
            </div>
            <div class="col-md-4">
                <label for="startDate" class="form-label">Ngày bắt đầu</label>
                <input type="date" class="form-control" id="startDate" name="startDate">
            </div>
            <div class="col-md-4">
                <label for="endDate" class="form-label">Ngày kết thúc</label>
                <input type="date" class="form-control" id="endDate" name="endDate">
            </div>
            <div class="col-md-4">
                <label for="isActive" class="form-label">Kích hoạt</label>
                <select class="form-select" id="isActive" name="isActive">
                    <option value="true">Có</option>
                    <option value="false">Không</option>
                </select>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">Tạo voucher</button>
                <a href="${ctx}/admin/vouchers" class="btn btn-secondary">Quay lại</a>
            </div>
        </form>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success mt-3">${success}</div>
        </c:if>
    </div>
</div>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>