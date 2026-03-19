<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="users" scope="request" />
<c:set var="pageTitle" value="Quản Lý Người Dùng - Admin" scope="request" />

<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>
<script>
// Nếu trang trắng do lỗi render, tự động reload lại sau 1 giây
document.addEventListener('DOMContentLoaded', function() {
    // Nếu không có bảng users hoặc không có dữ liệu, reload lại trang
    var table = document.getElementById('usersTable');
    if (!table || table.rows.length === 0) {
        document.body.innerHTML = '<div style="text-align:center;padding:80px 0;font-size:1.3rem;">Đang tải lại dữ liệu, vui lòng chờ...</div>';
        setTimeout(function() {
            window.location.reload();
        }, 1000);
    }
});
</script>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1><i class="bi bi-people"></i> Quản lý người dùng</h1>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <i class="bi bi-chevron-right"></i>
            <span>Người dùng</span>
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

<!-- Users Table Card -->
<div class="admin-card">
    <form method="get" class="admin-toolbar" style="flex-wrap:wrap; gap:10px;">
        <input type="text" name="q" value="${qFilter}" placeholder="Tên hoặc email..." class="admin-form-input" style="min-width:180px;"/>
        <select name="role" class="admin-form-select" style="width:auto;">
            <option value="">Tất cả quyền</option>
            <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Admin</option>
            <option value="STAFF" ${roleFilter == 'STAFF' ? 'selected' : ''}>Staff</option>
            <option value="USER" ${roleFilter == 'USER' ? 'selected' : ''}>Khách</option>
        </select>
        <select name="active" class="admin-form-select" style="width:auto;">
            <option value="">Tất cả trạng thái</option>
            <option value="true" ${activeFilter == 'true' ? 'selected' : ''}>Hoạt động</option>
            <option value="false" ${activeFilter == 'false' ? 'selected' : ''}>Khoá</option>
        </select>
        <button type="submit" class="admin-btn admin-btn-outline"><i class="bi bi-funnel"></i> Lọc</button>
        <a href="${ctx}/admin/users" class="admin-btn admin-btn-link" style="margin-left:auto;"><i class="bi bi-x-circle"></i> Xoá lọc</a>
        <a href="${ctx}/admin/users?action=add" class="admin-btn admin-btn-primary"><i class="bi bi-plus-circle"></i> Thêm mới</a>
            <button type="submit" formaction="${ctx}/admin/users?action=exportExcel" formmethod="get" class="admin-btn admin-btn-success" style="margin-left:10px;">
                <i class="bi bi-file-earmark-excel"></i> Xuất Excel
            </button>
    </form>
    <div class="admin-card-body p-0">
        <div class="table-responsive">
            <table class="admin-table" id="usersTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Điện thoại</th>
                        <th>Quyền</th>
                        <th>Trạng thái</th>
                        <th style="text-align:center;">Thao tác</th>
                    <th style="text-align:center;">Mật khẩu</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${users == null}">
                        <tr>
                            <td colspan="9">
                                <div class="admin-alert admin-alert-danger">
                                    Không lấy được danh sách người dùng! Vui lòng kiểm tra lại dữ liệu hoặc liên hệ quản trị viên.
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.username}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <span class="admin-badge admin-badge-success">Admin</span>
                                        </c:when>
                                        <c:when test="${user.role == 'STAFF'}">
                                            <span class="admin-badge admin-badge-info">Staff</span>
                                        </c:when>
                                        <c:when test="${user.role == 'CUSTOMER'}">
                                            <span class="admin-badge admin-badge-gray">Khách</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="admin-badge admin-badge-secondary">${user.role}</span>
                                        </c:otherwise>
                                    </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <span class="admin-badge admin-badge-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-danger">Khoá</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <a href="${ctx}/admin/users?action=edit&id=${user.userId}" class="admin-action-btn btn-edit" title="Sửa"><i class="bi bi-pencil"></i></a>
                                <a href="${ctx}/admin/users?action=delete&id=${user.userId}" class="admin-action-btn btn-delete" title="Xoá" onclick="return confirm('Xác nhận xoá người dùng này?');"><i class="bi bi-trash"></i></a>
                            </td>
                            <td style="text-align:center;">
                                <button type="button" class="admin-action-btn btn-reset-pw" data-user-id="${user.userId}" data-username="${user.username}" title="Reset mật khẩu"><i class="bi bi-key"></i></button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8">
                                <div class="admin-empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <p>Chưa có người dùng nào</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        <!-- Modal Reset Password -->
        <div class="modal fade" id="resetPwModal" tabindex="-1" aria-labelledby="resetPwModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post" action="${ctx}/admin/users" id="resetPwForm">
                        <input type="hidden" name="action" value="resetPassword"/>
                        <input type="hidden" name="userId" id="resetPwUserId"/>
                        <div class="modal-header">
                            <h5 class="modal-title" id="resetPwModalLabel">Reset mật khẩu cho <span id="resetPwUsername"></span></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu mới</label>
                                <input type="password" name="newPassword" class="form-control" required minlength="6"/>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.btn-reset-pw').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var userId = this.getAttribute('data-user-id');
                    var username = this.getAttribute('data-username');
                    document.getElementById('resetPwUserId').value = userId;
                    document.getElementById('resetPwUsername').textContent = username;
                    var modal = new bootstrap.Modal(document.getElementById('resetPwModal'));
                    modal.show();
                });
            });
        });
        </script>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
