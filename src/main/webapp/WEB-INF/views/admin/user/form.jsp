<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="users" scope="request" />
<c:set var="isAdd" value="${param.action == 'add'}" scope="request" />
<c:set var="pageTitle" value="${isAdd ? 'Thêm người dùng - Admin' : (user != null ? 'Cập nhật người dùng - Admin' : 'Thêm người dùng - Admin')}" scope="request" />
<c:set var="adminHideContentHeaderTitle" value="true" scope="request" />
<c:set var="adminHeaderBackHref" value="${pageContext.request.contextPath}/admin/users" scope="request" />
<c:set var="adminHeaderBackLabel" value="Danh sách người dùng" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<div class="admin-form-page">
<c:if test="${not empty param.error}">
    <div class="admin-alert admin-alert-danger mb-3" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${param.error}
        <button type="button" class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<div class="admin-card shadow-sm">
    <div class="admin-card-header">
        <h5><i class="bi bi-person-badge"></i> ${isAdd ? 'Thêm người dùng' : 'Chỉnh sửa người dùng'}</h5>
    </div>
    <div class="admin-card-body">
        <form id="userForm" method="post" action="${ctx}/admin/users" autocomplete="off" class="needs-validation">
            <c:choose>
                <c:when test="${!isAdd && user != null && not empty user.userId}">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="userId" value="${user.userId}"/>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="action" value="add"/>
                </c:otherwise>
            </c:choose>

            <div class="row g-4 align-items-lg-start">
                <div class="col-lg-8">
                    <div class="admin-form-section admin-form-section--boxed">
                        <div class="admin-form-section__head">
                            <h6 class="admin-form-section__title"><i class="bi bi-person-lines-fill"></i> Tài khoản &amp; liên hệ</h6>
                        </div>

                        <input type="text" name="fakeusernameremembered" class="d-none" tabindex="-1" autocomplete="off">
                        <input type="password" name="fakepasswordremembered" class="d-none" tabindex="-1" autocomplete="off">

                        <div class="mb-3">
                            <label class="admin-form-label" for="usernameField">Tên đăng nhập <span class="admin-required">*</span></label>
                            <input type="text" id="usernameField" name="username" class="admin-form-control" value="${isAdd ? '' : (user != null ? user.username : '')}" required autocomplete="new-username" placeholder="login_khong_dau" />
                            <p class="admin-form-hint mb-0">Dùng để đăng nhập bảng quản trị; không chứa khoảng trắng.</p>
                            <div class="admin-field-error" id="errusername"></div>
                        </div>

                        <div class="mb-3">
                            <label class="admin-form-label" for="fullNameField">Họ tên <span class="admin-required">*</span></label>
                            <input type="text" id="fullNameField" name="fullName" class="admin-form-control" value="${isAdd ? '' : (user != null ? user.fullName : '')}" required placeholder="Nguyễn Văn A" />
                            <div class="admin-field-error" id="errfullName"></div>
                        </div>

                        <div class="mb-3">
                            <label class="admin-form-label" for="emailField">Email <span class="admin-required">*</span></label>
                            <input type="email" id="emailField" name="email" class="admin-form-control" value="${isAdd ? '' : (user != null ? user.email : '')}" required placeholder="email@congty.com" />
                            <div class="admin-field-error" id="erremail"></div>
                        </div>

                        <div class="mb-0">
                            <label class="admin-form-label" for="phoneField">Điện thoại</label>
                            <input type="text" id="phoneField" name="phone" class="admin-form-control" value="${isAdd ? '' : (user != null ? user.phone : '')}" placeholder="09x xxx xxxx" />
                        </div>
                    </div>

                    <c:if test="${isAdd}">
                        <div class="admin-form-section admin-form-section--boxed mb-0">
                            <div class="admin-form-section__head">
                                <h6 class="admin-form-section__title"><i class="bi bi-shield-lock"></i> Mật khẩu</h6>
                            </div>
                            <label class="admin-form-label" for="newPassword">Mật khẩu <span class="admin-required">*</span></label>
                            <div class="d-flex flex-wrap gap-2 align-items-stretch">
                                <input type="password" name="new_password" id="newPassword" class="admin-form-control flex-grow-1" style="min-width:200px;" required autocomplete="new-password" />
                                <button type="button" class="admin-btn admin-btn-outline admin-btn-sm align-self-center" id="generatePw"><i class="bi bi-magic"></i> Gợi ý mật khẩu</button>
                            </div>
                            <p class="admin-form-hint mb-0" id="pwStrength">Tối thiểu 8 ký tự, nên gồm chữ hoa, số và ký tự đặc biệt.</p>
                            <div class="admin-field-error" id="errnew_password"></div>
                        </div>
                    </c:if>
                </div>

                <div class="col-lg-4 admin-form-sidebar-col">
                    <aside class="admin-media-panel">
                        <div class="admin-form-subpanel mb-4">
                            <div class="admin-form-section__head" style="border:none;padding-bottom:0;margin-bottom:14px;">
                                <h6 class="admin-form-section__title mb-0"><i class="bi bi-shield-check"></i> Quyền &amp; trạng thái</h6>
                            </div>
                            <div class="mb-3">
                                <label class="admin-form-label">Vai trò <span class="admin-required">*</span></label>
                                <c:choose>
                                    <c:when test="${user == null}">
                                        <input type="hidden" name="role" value="STAFF" />
                                        <input type="text" class="admin-form-control" value="Staff" readonly />
                                        <p class="admin-form-hint mb-0">Người dùng mới mặc định là Staff.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <select name="role" class="admin-form-select" required>
                                            <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="mb-0">
                                <label class="admin-form-label">Trạng thái <span class="admin-required">*</span></label>
                                <select name="active" class="admin-form-select" required>
                                    <c:choose>
                                        <c:when test="${user == null}">
                                            <option value="true" selected>Hoạt động</option>
                                            <option value="false">Khóa</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="true" ${user.active ? 'selected' : ''}>Hoạt động</option>
                                            <option value="false" ${!user.active ? 'selected' : ''}>Khóa</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>
                        </div>

                        <h6 class="admin-media-panel__title"><i class="bi bi-person-circle"></i> Ảnh đại diện</h6>
                        <p class="admin-media-panel__subtitle">Chỉ xem trước trên trình duyệt. Upload đầy đủ có thể bổ sung sau.</p>
                        <%
                            String avatarSrc = request.getContextPath() + "/assets/images/default-avatar.png";
                            String avatarName = "";
                            Object uObj = request.getAttribute("user");
                            if (uObj != null) {
                                try {
                                    Class<?> uc = uObj.getClass();
                                    try {
                                        java.lang.reflect.Method gm = uc.getMethod("getAvatarUrl");
                                        Object val = gm.invoke(uObj);
                                        if (val != null && !val.toString().isBlank()) {
                                            String v = val.toString();
                                            avatarName = v;
                                            if (v.startsWith("http")) avatarSrc = v;
                                            else avatarSrc = request.getContextPath() + "/assets/images/" + v.replaceFirst("^/+", "");
                                        }
                                    } catch (NoSuchMethodException ignore) {
                                        try {
                                            java.lang.reflect.Field f = uc.getField("avatarUrl");
                                            Object val = f.get(uObj);
                                            if (val != null && !val.toString().isBlank()) {
                                                String v = val.toString();
                                                avatarName = v;
                                                if (v.startsWith("http")) avatarSrc = v;
                                                else avatarSrc = request.getContextPath() + "/assets/images/" + v.replaceFirst("^/+", "");
                                            }
                                        } catch (Exception ignored) { }
                                    }
                                } catch (Exception ex) { /* ignore */ }
                            }
                        %>
                        <div class="preview-overlay admin-avatar-preview mx-auto admin-avatar-preview--lg">
                            <img id="avatarPreview" src="<%= avatarSrc %>" alt="avatar" style="width:100%;height:100%;object-fit:cover;"/>
                            <div class="preview-badge">Ảnh</div>
                        </div>
                        <div class="file-upload-wrapper mt-3 justify-content-center flex-wrap">
                            <label class="file-upload-btn mb-0" for="avatarFile" tabindex="0"><i class="bi bi-upload"></i> Chọn ảnh</label>
                            <span class="file-upload-filename text-truncate" id="avatarFilename" style="max-width:100%;"><%= avatarName.isEmpty() ? "Chưa chọn file" : avatarName %></span>
                        </div>
                        <input type="file" id="avatarFile" accept="image/*" class="file-upload-input" />
                    </aside>
                </div>
            </div>

            <div class="admin-save-bar">
                <a href="${ctx}/admin/users" class="admin-btn admin-btn-outline admin-btn-sm">Hủy</a>
                <button type="submit" class="admin-btn admin-btn-primary admin-btn-sm"><i class="bi bi-check2-circle"></i> Lưu</button>
            </div>
        </form>
    </div>
</div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarFile = document.getElementById('avatarFile');
    var avatarPreview = document.getElementById('avatarPreview');
    if (avatarFile && avatarPreview) {
        avatarFile.addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (!file) return;
            var reader = new FileReader();
            reader.onload = function(evt) {
                avatarPreview.src = evt.target.result;
            };
            reader.readAsDataURL(file);
            var fn = document.getElementById('avatarFilename');
            if (fn) fn.textContent = file.name;
        });
    }

    var generateBtn = document.getElementById('generatePw');
    var pwInput = document.getElementById('newPassword');
    var pwStrength = document.getElementById('pwStrength');
    if (generateBtn && pwInput) {
        generateBtn.addEventListener('click', function() {
            var pw = Math.random().toString(36).slice(-10) + 'A1!';
            pwInput.value = pw;
            updateStrength(pw);
        });
        pwInput.addEventListener('input', function() { updateStrength(pwInput.value); });
    }
    function updateStrength(pw) {
        if (!pwStrength) return;
        if (!pw) {
            pwStrength.textContent = 'Tối thiểu 8 ký tự, nên gồm chữ hoa, số và ký tự đặc biệt.';
            return;
        }
        var score = 0;
        if (pw.length >= 8) score++;
        if (/[A-Z]/.test(pw)) score++;
        if (/[0-9]/.test(pw)) score++;
        if (/[^A-Za-z0-9]/.test(pw)) score++;
        var labels = ['Yếu', 'Trung bình', 'Tốt', 'Rất tốt'];
        pwStrength.textContent = 'Độ mạnh: ' + labels[Math.max(0, score - 1)];
    }
});
</script>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
