<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0"><i class="bi bi-ticket-perforated"></i> Quản lý Voucher</h2>
        <a href="${pageContext.request.contextPath}/admin/voucher-create" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Thêm Voucher
        </a>
    </div>
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Mã</th>
                        <th>Mô tả</th>
                        <th>Loại</th>
                        <th>Giá trị</th>
                        <th>Đơn tối thiểu</th>
                        <th>Giảm tối đa</th>
                        <th>Số lượng</th>
                        <th>Đã dùng</th>
                        <th>Hiệu lực</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${vouchers}">
                    <tr>
                        <td>${v.voucherId}</td>
                        <td><span class="fw-bold text-primary"><i class="bi bi-ticket-perforated"></i> ${v.code}</span></td>
                        <td>
                            <span title="${v.description}">
                                <c:choose>
                                    <c:when test="${not empty v.description}">
                                        <c:out value="${fn:length(v.description) > 30 ? fn:substring(v.description, 0, 30) + '...' : v.description}"/>
                                    </c:when>
                                    <c:otherwise><span class="text-muted">(Không có)</span></c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${v.discountType eq 'PERCENT'}">
                                    <span class="badge bg-info text-dark"><i class="bi bi-percent"></i> %</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark"><i class="bi bi-cash"></i> VNĐ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <fmt:formatNumber value="${v.discountValue}" pattern="#,##0"/>
                            <c:choose><c:when test="${v.discountType eq 'PERCENT'}">%</c:when><c:otherwise>₫</c:otherwise></c:choose>
                        </td>
                        <td><fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0₫"/></td>
                        <td><fmt:formatNumber value="${v.maxDiscount}" pattern="#,##0₫"/></td>
                        <td>
                            <span class="badge bg-secondary">${v.quantity != null ? v.quantity : '∞'}</span>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark">${v.usedCount}</span>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark">
                                <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${v.active}"><span class="badge bg-success"><i class="bi bi-check-circle"></i> Kích hoạt</span></c:when>
                                <c:otherwise><span class="badge bg-secondary"><i class="bi bi-x-circle"></i> Ẩn</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-secondary me-1" title="Sửa" disabled><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" title="Xóa" disabled><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
