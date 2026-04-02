<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="users" scope="request" />
<c:set var="pageTitle" value="Quản Lý Người Dùng" scope="request" />

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
            <!-- Users Table Card -->
            <div class="admin-card shadow-sm" style="border-radius:18px;overflow:hidden;">
                <div class="admin-toolbar align-items-center flex-wrap gap-3 p-3 pb-2" style="background:var(--admin-primary-bg);border-bottom:1px solid var(--admin-border);border-radius:18px 18px 0 0;">
                    <form method="get" class="admin-toolbar-form d-flex align-items-center flex-wrap gap-3 mb-0 w-100">
                        <div class="admin-toolbar-search flex-shrink-0" style="min-width:220px;">
                            <i class="bi bi-search search-icon"></i>
                            <input type="text" name="q" value="${qFilter}" placeholder="Tên hoặc email..." class="form-control rounded-3" style="padding-left:2.2rem;min-width:180px;">
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <label class="admin-toolbar-label fw-semibold mb-0">Quyền:</label>
                            <select name="role" class="admin-form-select rounded-3">
                                <option value="">Tất cả quyền</option>
                                <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                <option value="STAFF" ${roleFilter == 'STAFF' ? 'selected' : ''}>Staff</option>
                                <option value="USER" ${roleFilter == 'USER' ? 'selected' : ''}>Khách</option>
                            </select>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <label class="admin-toolbar-label fw-semibold mb-0">Trạng thái:</label>
                            <select name="active" class="admin-form-select rounded-3">
                                <option value="">Tất cả trạng thái</option>
                                <option value="true" ${activeFilter == 'true' ? 'selected' : ''}>Hoạt động</option>
                                <option value="false" ${activeFilter == 'false' ? 'selected' : ''}>Khoá</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-funnel"></i> Lọc</button>
                        <div class="ms-auto d-flex align-items-center gap-2">
                            <c:if test="${not empty qFilter || not empty roleFilter || not empty activeFilter}">
                                <a href="${ctx}/admin/users" class="btn btn-outline-secondary btn-sm rounded-3 d-flex align-items-center gap-2" title="Xóa bộ lọc"><i class="bi bi-x-circle"></i> Xóa lọc</a>
                            </c:if>
                            <a href="${ctx}/admin/users?action=add" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-plus-circle"></i> Thêm mới</a>
                            <button type="submit" formaction="${ctx}/admin/users?action=exportExcel" formmethod="get" class="btn btn-success btn-sm rounded-3 d-flex align-items-center gap-2"><i class="bi bi-file-earmark-excel"></i> Xuất Excel</button>
                        </div>
                    </form>
                </div>
                <div class="admin-card-body p-0" style="background:#fff;border-radius:0 0 18px 18px;">
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
                                    <th class="text-center">Thao tác</th>
                                    <th class="text-center">Mật khẩu</th>
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
                                                    <span class="admin-badge admin-badge-success rounded-pill px-3 py-2">Admin</span>
                                                </c:when>
                                                <c:when test="${user.role == 'STAFF'}">
                                                    <span class="admin-badge admin-badge-info rounded-pill px-3 py-2">Staff</span>
                                                </c:when>
                                                <c:when test="${user.role == 'CUSTOMER'}">
                                                    <span class="admin-badge admin-badge-gray rounded-pill px-3 py-2">Khách</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="admin-badge admin-badge-secondary rounded-pill px-3 py-2">${user.role}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.active}">
                                                    <span class="admin-badge admin-badge-success rounded-pill px-3 py-2">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="admin-badge admin-badge-danger rounded-pill px-3 py-2">Khoá</span>
                                                </c:otherwise>
                                            </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <a href="${ctx}/admin/users?action=edit&id=${user.userId}" class="btn btn-outline-primary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Sửa" style="min-width:36px;gap:4px;"><i class="bi bi-pencil"></i></a>
                                <a href="${ctx}/admin/users?action=delete&id=${user.userId}" class="btn btn-outline-danger btn-sm rounded-3 d-inline-flex align-items-center justify-content-center" title="Xoá" style="min-width:36px;gap:4px;" onclick="return confirm('Xác nhận xoá người dùng này?');"><i class="bi bi-trash"></i></a>
                            </td>
                            <td style="text-align:center;">
                                <button type="button" class="btn btn-outline-secondary btn-sm rounded-3 d-inline-flex align-items-center justify-content-center btn-reset-pw" data-user-id="${user.userId}" data-username="${user.username}" title="Reset mật khẩu" style="min-width:36px;gap:4px;"><i class="bi bi-key"></i></button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8">
                                <div class="admin-empty-state py-5">
                                    <i class="bi bi-inbox" style="font-size:2rem;"></i>
                                    <p class="mt-2 mb-0">Chưa có người dùng nào</p>
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
                            <button type="button" class="btn btn-outline-secondary btn-sm rounded-3" data-bs-dismiss="modal">Huỷ</button>
                            <button type="submit" class="btn btn-primary btn-sm rounded-3">Xác nhận</button>
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
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
