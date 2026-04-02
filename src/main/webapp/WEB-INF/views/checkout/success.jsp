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
                <!-- Success Message -->
                <div class="text-center mb-4">
                    <i class="bi bi-check-circle text-success" style="font-size: 5rem;"></i>
                    <h2 class="mt-3">Đặt Hàng Thành Công!</h2>
                    <p class="text-muted">Cảm ơn bạn đã đặt hàng tại Mobile Store</p>
                </div>
                
                <!-- Order Information -->
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="bi bi-bag-check"></i> Thông Tin Đơn Hàng #${order.orderId}</h5>
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
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6>Thông Tin Khách Hàng</h6>
                                <p class="mb-1"><strong>Họ tên:</strong> ${order.customerName}</p>
                                <p class="mb-1"><strong>Điện thoại:</strong> ${order.customerPhone}</p>
                                <c:if test="${not empty order.customerEmail}">
                                    <p class="mb-1"><strong>Email:</strong> ${order.customerEmail}</p>
                                </c:if>
                            </div>
                            <div class="col-md-6">
                                <h6>Thông Tin Đơn Hàng</h6>
                                <p class="mb-1"><strong>Mã đơn:</strong> #${order.orderId}</p>
                                <p class="mb-1"><strong>Ngày đặt:</strong> 
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </p>
                                <p class="mb-1">
                                    <strong>Trạng thái:</strong> 
                                    <span class="badge ${order.statusBadgeClass}">${order.statusLabel}</span>
                                </p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="mb-3">
                            <h6>Địa Chỉ Giao Hàng</h6>
                            <p class="mb-0">${order.shippingAddress}</p>
                        </div>
                        
                        <hr>
                        
                        <div class="mb-3">
                            <h6>Sản Phẩm</h6>
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
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
                                                    <div>${item.productName}</div>
                                                    <div class="text-muted" style="font-size: 0.85rem;">Màu: ${not empty item.selectedColor ? item.selectedColor : 'Chưa chọn'} | Dung lượng: ${not empty item.selectedCapacity ? item.selectedCapacity : 'Chưa chọn'}</div>
                                                </td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.price}" type="currency" 
                                                                    currencyCode="VND" pattern="#,##0 ₫"/>
                                                </td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" 
                                                                    currencyCode="VND" pattern="#,##0 ₫"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
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
                        
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Phương thức thanh toán:</strong></p>
                                <p>${order.paymentMethodLabel}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Trạng thái thanh toán:</strong></p>
                                <p>
                                    <c:choose>
                                        <c:when test="${order.paymentStatus == 'PAID'}">
                                            <span class="badge bg-success">${order.paymentStatusLabel}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning">${order.paymentStatusLabel}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        
                        <c:if test="${not empty order.notes}">
                            <hr>
                            <div>
                                <p class="mb-1"><strong>Ghi chú:</strong></p>
                                <p class="mb-0">${order.notes}</p>
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
                            <li>Vui lòng chuẩn bị tiền mặt nếu chọn COD</li>
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
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
