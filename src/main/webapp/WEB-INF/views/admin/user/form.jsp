<%-- DEBUG: In ra giá trị user và action --%>
<%
    Object debugUser = request.getAttribute("user");
    String debugAction = request.getParameter("action");
    out.println("<div style='color:red;font-weight:bold'>[DEBUG] user=" + debugUser + ", action=" + debugAction + "</div>");
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="users" scope="request" />
<c:set var="isAdd" value="${param.action == 'add'}" scope="request" />
<c:set var="pageTitle" value="${isAdd ? 'Thêm Người Dùng' : (user != null ? 'Cập Nhật Người Dùng' : 'Thêm Người Dùng')} - Admin" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-person"></i> ${isAdd ? 'Thêm người dùng' : (user != null ? 'Cập nhật người dùng' : 'Thêm người dùng')}</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <a href="${ctx}/admin/users">Người dùng</a>
            <i class="bi bi-chevron-right"></i>
            <span>${isAdd ? 'Thêm mới' : (user != null ? 'Cập nhật' : 'Thêm mới')}</span>
        </div>
    </div>
</div>

<!-- Alert Messages -->
<c:if test="${not empty param.error}">
    <div class="admin-alert admin-alert-danger" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${param.error}
        <button class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<!-- User Form Card -->
<div class="admin-card shadow-sm p-4" style="max-width:480px; margin:auto; border-radius:16px; background:#fff;">
    <form method="post" action="${ctx}/admin/users" autocomplete="off" style="width:100%" name="addUserForm">
        <c:choose>
            <c:when test="${!isAdd && user != null && not empty user.userId}">
                <input type="hidden" name="action" value="edit"/>
                <input type="hidden" name="userId" value="${user.userId}"/>
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="add"/>
                <!-- KHÔNG gửi userId khi tạo mới -->
            </c:otherwise>
        </c:choose>
        <!-- Dummy fields to defeat browser autofill -->
        <input type="text" name="fakeusernameremembered" style="display:none">
        <input type="password" name="fakepasswordremembered" style="display:none">
        <div class="mb-3">
            <label class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
            <!-- Dummy field để chặn autofill -->
            <input type="text" name="dummyuserfield" id="dummyuserfield" style="display:none" autocomplete="off">
            <input type="search" name="inputUsernameX" id="inputUsernameX" class="form-control form-control-lg" value="${isAdd ? '' : (user != null ? user.username : '')}" required style="border-radius:8px;" autocomplete="new-username"/>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Họ tên <span class="text-danger">*</span></label>
            <input type="text" name="new_fullName" class="form-control form-control-lg" value="${isAdd ? '' : (user != null ? user.fullName : '')}" required style="border-radius:8px;" autocomplete="off"/>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
            <input type="email" name="new_email" class="form-control form-control-lg" value="${isAdd ? '' : (user != null ? user.email : '')}" required style="border-radius:8px;" autocomplete="off"/>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Điện thoại</label>
            <input type="text" name="new_phone" class="form-control form-control-lg" value="${isAdd ? '' : (user != null ? user.phone : '')}" style="border-radius:8px;" autocomplete="off"/>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Quyền <span class="text-danger">*</span></label>
            <c:choose>
                <c:when test="${user == null}">
                    <input type="hidden" name="role" value="STAFF" />
                    <input type="text" class="form-control form-control-lg" value="Staff" readonly style="border-radius:8px;background:#f5f5f5;"/>
                </c:when>
                <c:otherwise>
                    <select name="role" class="form-select form-select-lg" required style="border-radius:8px;">
                        <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    </select>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Trạng thái <span class="text-danger">*</span></label>
            <select name="active" class="form-select form-select-lg" required style="border-radius:8px;">
                <option value="true" ${user.active ? 'selected' : ''}>Hoạt động</option>
                <option value="false" ${!user.active ? 'selected' : ''}>Khoá</option>
            </select>
        </div>
        <c:if test="${isAdd}">
            <div class="mb-3">
                <label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                <input type="password" name="new_password" class="form-control form-control-lg" required style="border-radius:8px;" autocomplete="new-password"/>
            </div>
        </c:if>
        <div class="d-flex justify-content-between align-items-center mt-4">
            <a href="${ctx}/admin/users" class="btn btn-secondary px-4 py-2"><i class="bi bi-arrow-left"></i> Quay lại</a>
            <button type="submit" class="btn btn-primary px-5 py-2 fw-bold shadow-sm" style="border-radius:8px; font-size:1.1rem;"><i class="bi bi-save"></i> Lưu</button>
        </div>
    </form>
</div>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
<script>
window.addEventListener('DOMContentLoaded', function() {
    var usernameInput = document.getElementById('inputUsernameX');
    if (usernameInput) {
        usernameInput.value = '';
    }
});
</script>
