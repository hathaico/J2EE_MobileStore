<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - Mobile Store</title>
    
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
        <h2 class="mb-4"><i class="bi bi-credit-card"></i> Thanh Toán</h2>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${vnpayDevModeActive}">
            <div class="alert alert-info" role="alert">
                <i class="bi bi-bezier2 me-2"></i>
                Đang bật chế độ mô phỏng thanh toán thẻ (DEV MODE - chỉ local). Đơn hàng thẻ sẽ được xác nhận thanh toán ngay để test nhanh.
            </div>
        </c:if>
        
        <div class="row">
            <!-- Checkout Form -->
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="bi bi-person"></i> Thông Tin Khách Hàng</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                                                        <!-- Hidden fields for voucher -->
                                                        <input type="hidden" name="voucherCode" id="hidden-voucher-code" value="">
                                                        <input type="hidden" name="voucherDiscount" id="hidden-voucher-discount" value="0">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="customerName" class="form-label">Họ và Tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="customerName" name="customerName" 
                                           value="${customerName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="customerPhone" class="form-label">Số Điện Thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="customerPhone" name="customerPhone" 
                                           value="${customerPhone}" required pattern="[0-9]{10,11}">
                                    <div class="form-text">Nhập 10-11 số</div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="customerEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="customerEmail" name="customerEmail" 
                                       value="${customerEmail}">
                                <div class="form-text">Email để nhận thông tin đơn hàng</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="shippingAddress" class="form-label">Địa Chỉ Giao Hàng <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                          rows="3" required>${shippingAddress}</textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Phương Thức Thanh Toán <span class="text-danger">*</span></label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="paymentCOD" value="COD" 
                                           ${empty paymentMethod || paymentMethod == 'COD' ? 'checked' : ''}>
                                    <label class="form-check-label" for="paymentCOD">
                                        <i class="bi bi-cash"></i> Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="paymentBank" value="BANK_TRANSFER"
                                           ${paymentMethod == 'BANK_TRANSFER' ? 'checked' : ''}>
                                    <label class="form-check-label" for="paymentBank">
                                        <i class="bi bi-bank"></i> Chuyển khoản ngân hàng
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="paymentCard" value="CREDIT_CARD"
                                           ${paymentMethod == 'CREDIT_CARD' ? 'checked' : ''}>
                                    <label class="form-check-label" for="paymentCard">
                                        <i class="bi bi-credit-card"></i> Thẻ ngân hàng qua VNPay (ATM/Visa/Mastercard)
                                    </label>
                                </div>
                                <div class="small text-muted ms-4">
                                    Khi bấm Đặt Hàng, hệ thống sẽ chuyển sang cổng thanh toán VNPay (hoặc mô phỏng local nếu DEV MODE bật).
                                </div>
                                <c:if test="${vnpayDevModeActive}">
                                    <div class="small text-info mt-2">
                                        <i class="bi bi-info-circle"></i> DEV MODE đang bật cho máy local này.
                                    </div>
                                </c:if>
                            </div>

                            <div id="card-payment-section" class="mb-3" style="display: none; border: 1px solid #E5E7EB; border-radius: 10px; padding: 1rem; background: #F8FAFC;">
                                <div class="mb-2" style="font-weight: 600; color: #1F2937;">
                                    <i class="bi bi-shield-lock"></i> Thông tin thẻ ngân hàng
                                </div>
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="cardHolderName" class="form-label">Tên chủ thẻ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cardHolderName" name="cardHolderName" maxlength="80" value="${cardHolderName}" placeholder="NGUYEN VAN A">
                                    </div>
                                    <div class="col-12">
                                        <label for="cardNumber" class="form-label">Số thẻ <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" inputmode="numeric" autocomplete="cc-number" maxlength="23" placeholder="1234 5678 9012 3456">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardExpiry" class="form-label">Ngày hết hạn (MM/YY) <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cardExpiry" name="cardExpiry" inputmode="numeric" autocomplete="cc-exp" maxlength="5" value="${cardExpiry}" placeholder="MM/YY">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardCvv" class="form-label">CVV/CVC <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="cardCvv" name="cardCvv" inputmode="numeric" autocomplete="cc-csc" maxlength="4" placeholder="123">
                                    </div>
                                </div>
                                <div class="form-text mt-2">
                                    Hệ thống chỉ dùng thông tin thẻ để xác thực thanh toán và không lưu CVV.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Ghi Chú</label>
                                <textarea class="form-control" id="notes" name="notes" 
                                          rows="2" placeholder="Ghi chú về đơn hàng (không bắt buộc)">${notes}</textarea>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay Lại Giỏ Hàng
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Đặt Hàng
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Order Summary -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="bi bi-cart-check"></i> Đơn Hàng</h5>
                    </div>
                    <div class="card-body">
                        <!-- Order Items -->
                        <c:forEach var="item" items="${cart.items}">
                            <div class="d-flex justify-content-between mb-2">
                                <div class="flex-grow-1">
                                    <strong>${item.product.productName}</strong>
                                    <br>
                                    <small class="text-muted d-block">
                                        Màu: ${not empty item.selectedColor ? item.selectedColor : 'Chưa chọn'} | Dung lượng: ${not empty item.selectedCapacity ? item.selectedCapacity : 'Chưa chọn'}
                                    </small>
                                    <small class="text-muted">
                                        <fmt:formatNumber value="${item.product.price}" type="currency" 
                                                        currencyCode="VND" pattern="#,##0 ₫"/> × ${item.quantity}
                                    </small>
                                </div>
                                <div class="text-end">
                                    <fmt:formatNumber value="${item.total}" type="currency" 
                                                    currencyCode="VND" pattern="#,##0 ₫"/>
                                </div>
                            </div>
                            <hr class="my-2">
                        </c:forEach>
                        
                        <!-- Total Summary -->
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tạm tính:</span>
                            <span>
                                <fmt:formatNumber value="${cart.total}" type="currency" 
                                                currencyCode="VND" pattern="#,##0 ₫"/>
                            </span>
                        </div>

                            <div class="d-flex justify-content-between mb-2 align-items-center">
                                <span>Mã giảm giá:</span>
                                <div style="display: flex; gap: 0.5rem;">
                                    <input type="text" class="form-control form-control-sm" placeholder="Nhập mã" style="width: 110px;" id="voucher-code-input">
                                    <button class="btn btn-outline btn-sm" type="button" id="apply-voucher-btn">Áp dụng</button>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Giảm giá:</span>
                                <span id="discount-amount">0₫</span>
                            </div>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phí vận chuyển:</span>
                            <span class="text-success">Miễn phí</span>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex justify-content-between">
                            <strong>Tổng cộng:</strong>
                                <strong class="text-danger" id="total-amount">
                                    <fmt:formatNumber value="${cart.total}" type="currency" 
                                                    currencyCode="VND" pattern="#,#00 ₫"/>
                                </strong>
                        </div>
                    </div>
                </div>
                
                <!-- Security Info -->
                <div class="card mt-3">
                    <div class="card-body">
                        <h6><i class="bi bi-shield-check"></i> Thanh Toán An Toàn</h6>
                        <ul class="list-unstyled small mb-0">
                            <li><i class="bi bi-check text-success"></i> Mã hóa SSL 256-bit</li>
                            <li><i class="bi bi-check text-success"></i> Thông tin được bảo mật</li>
                            <li><i class="bi bi-check text-success"></i> Không lưu trữ thẻ</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        // Voucher AJAX logic
        document.addEventListener('DOMContentLoaded', function() {
            var hiddenVoucherCode = document.getElementById('hidden-voucher-code');
            var hiddenVoucherDiscount = document.getElementById('hidden-voucher-discount');
            var applyBtn = document.getElementById('apply-voucher-btn');
            var codeInput = document.getElementById('voucher-code-input');
            var discountSpan = document.getElementById('discount-amount');
            var totalSpan = document.getElementById('total-amount');
            var subtotal = ${cart.total};
            if (applyBtn && codeInput) {
                applyBtn.addEventListener('click', function() {
                    var code = codeInput.value.trim();
                    if (!code) { alert('Vui lòng nhập mã giảm giá!'); return; }
                    fetch('${pageContext.request.contextPath}/api/voucher', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'code=' + encodeURIComponent(code) + '&orderTotal=' + subtotal
                    })
                    .then(r => r.json())
                    .then(data => {
                        console.log('Voucher API response:', data);
                        if (data.success && data.voucher) {
                            // Tính discount một lần duy nhất
                            let discount = 0;
                            let discountValue = Number(data.voucher.discountValue);
                            let maxDiscount = Number(data.voucher.maxDiscount);
                            let type = (data.voucher.discountType || '').toUpperCase();
                            if (type === 'PERCENT') {
                                discount = subtotal * (discountValue / 100);
                                if (!isNaN(maxDiscount) && maxDiscount > 0 && discount > maxDiscount) {
                                    discount = maxDiscount;
                                }
                            } else if (type === 'AMOUNT') {
                                discount = discountValue;
                            }
                            if (discount > subtotal) discount = subtotal;
                            // Cập nhật UI
                            discountSpan.textContent = discount.toLocaleString('vi-VN') + '₫';
                            totalSpan.textContent = (subtotal - discount).toLocaleString('vi-VN') + '₫';
                            codeInput.disabled = true;
                            applyBtn.disabled = true;
                            applyBtn.textContent = 'Đã áp dụng';
                            // Cập nhật hidden input
                            if (hiddenVoucherCode) hiddenVoucherCode.value = data.voucher.code;
                            if (hiddenVoucherDiscount) hiddenVoucherDiscount.value = discount;
                        } else {
                            alert(data.message || 'Mã giảm giá không hợp lệ hoặc không đủ điều kiện.');
                        }
                    })
                    .catch(() => alert('Có lỗi khi kiểm tra mã giảm giá.'));
                });
            }
        });
        </script>
    <script>
        // Form validation
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const name = document.getElementById('customerName').value.trim();
            const phone = document.getElementById('customerPhone').value.trim();
            const address = document.getElementById('shippingAddress').value.trim();
            const selectedPayment = document.querySelector('input[name="paymentMethod"]:checked');
            const paymentMethod = selectedPayment ? selectedPayment.value : '';
            
            if (name === '' || phone === '' || address === '') {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return false;
            }
            
            if (!/^[0-9]{10,11}$/.test(phone)) {
                e.preventDefault();
                alert('Số điện thoại phải có 10-11 chữ số!');
                return false;
            }

            if (paymentMethod === 'CREDIT_CARD') {
                const holder = document.getElementById('cardHolderName').value.trim();
                const cardNumber = document.getElementById('cardNumber').value.replace(/\D/g, '');
                const expiry = document.getElementById('cardExpiry').value.trim();
                const cvv = document.getElementById('cardCvv').value.trim();

                if (!holder) {
                    e.preventDefault();
                    alert('Vui lòng nhập tên chủ thẻ.');
                    return false;
                }

                if (cardNumber.length < 13 || cardNumber.length > 19 || !luhnCheck(cardNumber)) {
                    e.preventDefault();
                    alert('Số thẻ ngân hàng không hợp lệ.');
                    return false;
                }

                if (!/^(0[1-9]|1[0-2])\/[0-9]{2}$/.test(expiry) || isExpired(expiry)) {
                    e.preventDefault();
                    alert('Ngày hết hạn thẻ không hợp lệ.');
                    return false;
                }

                if (!/^[0-9]{3,4}$/.test(cvv)) {
                    e.preventDefault();
                    alert('Mã CVV/CVC không hợp lệ.');
                    return false;
                }
            }
            
            return true;
        });

        function luhnCheck(number) {
            let sum = 0;
            let shouldDouble = false;
            for (let i = number.length - 1; i >= 0; i--) {
                let digit = parseInt(number.charAt(i), 10);
                if (shouldDouble) {
                    digit *= 2;
                    if (digit > 9) digit -= 9;
                }
                sum += digit;
                shouldDouble = !shouldDouble;
            }
            return sum % 10 === 0;
        }

        function isExpired(expiry) {
            const [mm, yy] = expiry.split('/');
            const month = parseInt(mm, 10);
            const year = 2000 + parseInt(yy, 10);
            const now = new Date();
            const currentMonth = now.getMonth() + 1;
            const currentYear = now.getFullYear();

            return year < currentYear || (year === currentYear && month < currentMonth);
        }

        function toggleCardPaymentSection() {
            const selectedPayment = document.querySelector('input[name="paymentMethod"]:checked');
            const cardSection = document.getElementById('card-payment-section');
            const isCard = selectedPayment && selectedPayment.value === 'CREDIT_CARD';

            if (cardSection) {
                cardSection.style.display = isCard ? 'block' : 'none';
            }

            const cardFields = ['cardHolderName', 'cardNumber', 'cardExpiry', 'cardCvv'];
            cardFields.forEach(function(fieldId) {
                const input = document.getElementById(fieldId);
                if (!input) return;
                if (isCard) input.setAttribute('required', 'required');
                else input.removeAttribute('required');
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
                radio.addEventListener('change', toggleCardPaymentSection);
            });

            const cardNumber = document.getElementById('cardNumber');
            if (cardNumber) {
                cardNumber.addEventListener('input', function() {
                    const digits = this.value.replace(/\D/g, '').substring(0, 19);
                    this.value = digits.replace(/(.{4})/g, '$1 ').trim();
                });
            }

            const cardExpiry = document.getElementById('cardExpiry');
            if (cardExpiry) {
                cardExpiry.addEventListener('input', function() {
                    const digits = this.value.replace(/\D/g, '').substring(0, 4);
                    if (digits.length >= 3) {
                        this.value = digits.substring(0, 2) + '/' + digits.substring(2);
                    } else {
                        this.value = digits;
                    }
                });
            }

            toggleCardPaymentSection();
        });
    </script>
</body>
</html>
