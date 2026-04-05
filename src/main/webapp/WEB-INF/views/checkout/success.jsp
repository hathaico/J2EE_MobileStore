<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - Mobile Store</title>
    
    <!-- Google Fonts - Noto Sans Vietnamese -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
    
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <strong>Lỗi!</strong> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            <i class="bi bi-house"></i> Về Trang Chủ
                        </a>
                    </div>
                </c:if>
                
                <!-- Success Message -->
                <c:if test="${not empty order}">
                <div class="text-center mb-4">
                    <i class="bi bi-check-circle text-success" style="font-size: 5rem;"></i>
                    <h2 class="mt-3">Đặt Hàng Thành Công!</h2>
                    <p class="text-muted">Cảm ơn bạn đã đặt hàng tại Mobile Store</p>
                </div>
                
                <!-- Order Information -->
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="bi bi-bag-check"></i> Thông Tin Đơn Hàng #${order.orderId}</h5>
                        <span class="badge ${order.statusBadgeClass}">${order.statusLabel}</span>
                    </div>
                    <div class="card-body">
                        <c:if test="${param.payment == 'success'}">
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>Thanh toán qua thẻ ngân hàng thành công.
                            </div>
                        </c:if>
                        <c:if test="${param.payment == 'mock_success'}">
                            <div class="alert alert-info" role="alert">
                                <i class="bi bi-bezier2 me-2"></i>Đơn hàng đã được thanh toán ở chế độ mô phỏng (DEV MODE).
                            </div>
                        </c:if>
                        <c:if test="${param.payment == 'failed'}">
                            <div class="alert alert-warning" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>Thanh toán thẻ chưa thành công. Bạn có thể thanh toán lại sau.
                            </div>
                        </c:if>
                        <c:if test="${param.payment == 'momo_success'}">
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>Thanh toán qua ví MoMo thành công.
                            </div>
                        </c:if>
                        <c:if test="${param.payment == 'momo_failed'}">
                            <div class="alert alert-warning" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>Thanh toán MoMo chưa thành công. Bạn có thể thanh toán lại sau.
                            </div>
                        </c:if>
                        
                        <!-- Customer Information Row -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <div class="bg-light p-3 rounded">
                                    <h6 class="mb-3 fw-bold"><i class="bi bi-person-circle me-2" style="color: #198754;"></i>Thông Tin Khách Hàng</h6>
                                    <dl class="row g-2 mb-0">
                                        <dt class="col-sm-5">Họ tên:</dt>
                                        <dd class="col-sm-7">${not empty order.customerName ? order.customerName : '<em class=\"text-muted\">Chưa cập nhật</em>'}</dd>
                                        
                                        <dt class="col-sm-5">Điện thoại:</dt>
                                        <dd class="col-sm-7">${not empty order.customerPhone ? order.customerPhone : '<em class=\"text-muted\">Chưa cập nhật</em>'}</dd>
                                        
                                        <c:if test="${not empty order.customerEmail}">
                                            <dt class="col-sm-5">Email:</dt>
                                            <dd class="col-sm-7">${order.customerEmail}</dd>
                                        </c:if>
                                    </dl>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="bg-light p-3 rounded">
                                    <h6 class="mb-3 fw-bold"><i class="bi bi-receipt me-2" style="color: #198754;"></i>Thông Tin Đơn Hàng</h6>
                                    <dl class="row g-2 mb-0">
                                        <dt class="col-sm-5">Mã đơn:</dt>
                                        <dd class="col-sm-7"><strong>#${order.orderId}</strong></dd>
                                        
                                        <dt class="col-sm-5">Ngày đặt:</dt>
                                        <dd class="col-sm-7">
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </dd>
                                        
                                        <dt class="col-sm-5">Trạng thái:</dt>
                                        <dd class="col-sm-7">
                                            <span class="badge ${order.statusBadgeClass}">${order.statusLabel}</span>
                                        </dd>
                                    </dl>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="mb-4">
                            <h6 class="fw-bold mb-2"><i class="bi bi-geo-alt-fill me-2" style="color: #198754;"></i>Địa Chỉ Giao Hàng</h6>
                            <div class="p-2 bg-light rounded">
                                <p class="mb-0">${not empty order.shippingAddress ? order.shippingAddress : '<em class=\"text-muted\">Chưa cập nhật</em>'}</p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="mb-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-box-seam me-2" style="color: #198754;"></i>Sản Phẩm Đặt Hàng</h6>
                            <div class="table-responsive">
                                <table class="table table-hover table-sm">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th class="text-center">Số lượng</th>
                                            <th class="text-end">Đơn giá</th>
                                            <th class="text-end">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.orderItems}">
                                            <tr>
                                                <td>
                                                    <div class="fw-500">${item.productName}</div>
                                                    <div class="text-muted small mt-1">
                                                        <i class="bi bi-palette me-1"></i>Màu: ${not empty item.selectedColor ? item.selectedColor : 'Chưa chọn'} 
                                                        <br>
                                                        <i class="bi bi-hdd me-1"></i>Dung lượng: ${not empty item.selectedCapacity ? item.selectedCapacity : 'Chưa chọn'}
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-secondary">${item.quantity}</span>
                                                </td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.price}" type="currency" 
                                                                    currencyCode="VND" pattern="#,##0 ₫"/>
                                                </td>
                                                <td class="text-end fw-bold">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" 
                                                                    currencyCode="VND" pattern="#,##0 ₫"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot class="table-light fw-bold">
                                        <tr>
                                            <th colspan="3" class="text-end">Tổng cộng:</th>
                                            <th class="text-end text-danger">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                currencyCode="VND" pattern="#,##0 ₫"/>
                                            </th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <!-- Payment Information Row -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <div class="bg-light p-3 rounded">
                                    <p class="mb-2"><strong><i class="bi bi-credit-card me-2" style="color: #198754;"></i>Phương thức thanh toán</strong></p>
                                    <p class="mb-0">${order.paymentMethodLabel}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="bg-light p-3 rounded">
                                    <p class="mb-2"><strong><i class="bi bi-check2-square me-2" style="color: #198754;"></i>Trạng thái thanh toán</strong></p>
                                    <p class="mb-0">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PAID'}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty order.notes}">
                            <hr>
                            <div>
                                <p class="mb-2"><strong><i class="bi bi-chat-left-text me-2" style="color: #198754;"></i>Ghi chú:</strong></p>
                                <p class="mb-0 p-2 bg-light rounded">${order.notes}</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Next Steps -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h6><i class="bi bi-info-circle"></i> Bước Tiếp Theo</h6>
                        <ul>
                            <li>Chúng tôi sẽ xác nhận đơn hàng trong vòng 24 giờ</li>
                            <li>Bạn sẽ nhận được thông báo qua điện thoại/email</li>
                            <li>Thời gian giao hàng dự kiến: 2-3 ngày làm việc</li>
                            <li>Vui lòng chuẩn bị tiền mặt nếu chọn CASH</li>
                        </ul>
                    </div>
                </div>
                
                <!-- Actions -->
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary me-2">
                        <i class="bi bi-house"></i> Về Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                        <i class="bi bi-shop"></i> Tiếp Tục Mua Hàng
                    </a>
                </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
