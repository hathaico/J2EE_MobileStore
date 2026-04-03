<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="reviews" scope="request" />
<c:set var="pageTitle" value="Quản Lý Đánh Giá Sản Phẩm" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>


<div class="admin-card shadow-sm" style="border-radius:18px;overflow:hidden;">
    <div class="admin-card-body p-0" style="background:#fff;border-radius:0 0 18px 18px;">
        <div class="table-responsive">
            <table class="admin-table align-middle">
                <thead>
                    <tr>
                        <th class="text-center">ID</th>
                        <th class="text-center">Sản phẩm</th>
                        <th class="text-center">Người đánh giá</th>
                        <th class="text-center">Điểm</th>
                        <th class="text-center">Bình luận</th>
                        <th class="text-center">Ngày tạo</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="review" items="${reviews}">
                        <tr>
                            <td class="text-center">${review.reviewId}</td>
                            <td class="text-center">${review.productId}</td>
                            <td class="text-center">${review.userName}</td>
                            <td class="text-center">
                                <span class="d-inline-flex align-items-center gap-1 fw-semibold">
                                    ${review.rating}
                                    <i class="bi bi-star-fill admin-text-warning" style="color:#ffc107;font-size:1.1em;"></i>
                                </span>
                            </td>
                            <td class="text-center">${review.comment}</td>
                            <td class="text-center">${review.createdAt}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${review.approved}">
                                        <span class="admin-badge admin-badge-success rounded-pill px-3 py-2">Đã duyệt</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="admin-badge admin-badge-secondary rounded-pill px-3 py-2">Chờ duyệt</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <div class="d-flex gap-2 flex-wrap justify-content-center">
                                    <c:choose>
                                        <c:when test="${!review.approved}">
                                            <a href="${ctx}/admin/reviews?action=approve&id=${review.reviewId}" class="btn btn-success btn-sm rounded-3 d-inline-flex align-items-center gap-1" title="Duyệt"><i class="bi bi-check-circle"></i> Duyệt</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${ctx}/admin/reviews?action=hide&id=${review.reviewId}" class="btn btn-warning btn-sm rounded-3 d-inline-flex align-items-center gap-1" title="Ẩn"><i class="bi bi-eye-slash"></i> Ẩn</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${ctx}/admin/reviews?action=delete&id=${review.reviewId}" class="btn btn-outline-danger btn-sm rounded-3 d-inline-flex align-items-center gap-1" title="Xoá" onclick="return confirm('Xác nhận xoá đánh giá này?');"><i class="bi bi-trash"></i> Xoá</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <tr><td colspan="8" class="text-center py-4">Không có đánh giá nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
