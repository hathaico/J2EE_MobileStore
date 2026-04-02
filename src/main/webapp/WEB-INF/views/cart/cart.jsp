<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="ms" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Giỏ Hàng - Mobile Store" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="margin-top: 2rem; margin-bottom: 4rem;">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" style="margin-bottom: 2rem;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
            <li class="breadcrumb-item active">Giỏ Hàng</li>
        </ol>
    </nav>

    <!-- Page Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h1 style="font-size: 2.5rem; font-weight: 700; margin: 0;">
            <i class="bi bi-cart3"></i> Giỏ Hàng
            <c:if test="${not empty cart && !cart.isEmpty()}">
                <span style="font-size: 1.5rem; color: var(--gray-500);">(${cart.uniqueItemCount})</span>
            </c:if>
        </h1>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
            <i class="bi bi-arrow-left"></i> Tiếp Tục Mua Hàng
        </a>
    </div>

    <!-- Cart Content -->
    <c:choose>
        <c:when test="${empty cart || cart.isEmpty()}">
            <!-- Empty Cart -->
            <div style="text-align: center; padding: 5rem 2rem; background: white; border-radius: 16px; box-shadow: var(--shadow-md);">
                <i class="bi bi-cart-x" style="font-size: 6rem; color: var(--gray-300); margin-bottom: 1.5rem;"></i>
                <h3 style="font-size: 1.75rem; font-weight: 600; margin-bottom: 0.75rem;">Giỏ hàng trống</h3>
                <p style="color: var(--gray-600); font-size: 1.1rem; margin-bottom: 2rem;">
                    Bạn chưa có sản phẩm nào trong giỏ hàng
                </p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">
                    <i class="bi bi-shop"></i> Khám Phá Sản Phẩm
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8 mb-4">
                    <div style="background: white; border-radius: 16px; padding: 2rem; box-shadow: var(--shadow-md);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                            <h5 style="font-size: 1.5rem; font-weight: 600; margin: 0;">
                                Sản phẩm đã chọn
                            </h5>
                            <button onclick="clearCart()" class="btn btn-sm btn-outline" style="color: var(--danger-color); border-color: var(--danger-color);">
                                <i class="bi bi-trash"></i> Xóa Tất Cả
                            </button>
                        </div>

                        <c:forEach var="item" items="${cart.items}" varStatus="status">
                            <div class="cart-item-card" data-item-key="${item.itemKey}" data-product-id="${item.product.productId}">
                                <div class="row align-items-center">
                                    <!-- Product Image -->
                                    <div class="col-md-2 col-3">
                                        <div class="cart-item-thumb">
                                            <c:choose>
                                                <c:when test="${not empty item.product.imageUrl}">
                                                    <img src="<ms:productImageSrc url="${item.product.imageUrl}" />"
                                                         alt="${item.product.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-phone" style="font-size: 3rem; color: var(--gray-300); display: block; text-align: center;"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <!-- Product Info -->
                                    <div class="col-md-4 col-9">
                                        <h6 style="font-weight: 600; margin-bottom: 0.5rem; font-size: 1.05rem;">
                                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${item.product.productId}"
                                               style="text-decoration: none; color: var(--gray-900);">
                                                ${item.product.productName}
                                            </a>
                                        </h6>
                                        <div style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 0.5rem;">
                                            ${item.product.brand}
                                        </div>
                                        <div style="color: var(--gray-600); font-size: 0.84rem; margin-bottom: 0.4rem; line-height: 1.45;">
                                            <span style="font-weight: 600; color: var(--gray-800);">
                                                Màu: ${not empty item.selectedColor ? item.selectedColor : 'Chưa chọn'}
                                            </span>
                                            <span style="color: var(--gray-500);">|</span>
                                            <span style="font-weight: 600; color: var(--gray-800);">
                                                Dung lượng: ${not empty item.selectedCapacity ? item.selectedCapacity : 'Chưa chọn'}
                                            </span>
                                        </div>
                                        <div style="color: var(--primary-color); font-weight: 600; font-size: 1.1rem;">
                                            <fmt:formatNumber value="${item.product.price}" pattern="#,##0₫"/>
                                        </div>
                                        <small style="color: var(--gray-500);">
                                            Còn ${item.product.stockQuantity} sản phẩm
                                        </small>
                                    </div>
                                    
                                    <!-- Quantity Controls -->
                                    <div class="col-md-3 col-6 mt-3 mt-md-0">
                                        <div style="display: flex; align-items: center; gap: 0.5rem; justify-content: center;">
                                              <button class="qty-btn qty-decrease" data-item-key="${item.itemKey}" data-current-qty="${item.quantity}"
                                                    style="width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--gray-300); 
                                                           background: white; cursor: pointer; display: flex; align-items: center; 
                                                           justify-content: center; transition: var(--transition-base);">
                                                <i class="bi bi-dash"></i>
                                            </button>
                                            <input type="number" value="${item.quantity}" min="1" max="${item.product.stockQuantity}"
                                                  class="qty-input" data-item-key="${item.itemKey}"
                                                  style="width: 60px; height: 36px; text-align: center; padding: 0; line-height: 36px; 
                                                      border: 1px solid var(--gray-300); border-radius: 8px; font-weight: 600; 
                                                      appearance: textfield; -moz-appearance: textfield;">
                                              <button class="qty-btn qty-increase" data-item-key="${item.itemKey}" data-current-qty="${item.quantity}"
                                                    style="width: 36px; height: 36px; border-radius: 8px; border: 1px solid var(--gray-300); 
                                                           background: white; cursor: pointer; display: flex; align-items: center; 
                                                           justify-content: center; transition: var(--transition-base);">
                                                <i class="bi bi-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Total & Remove -->
                                    <div class="col-md-2 col-6 text-end mt-3 mt-md-0">
                                        <div style="font-weight: 700; font-size: 1.2rem; color: var(--gray-900); margin-bottom: 0.5rem;">
                                            <fmt:formatNumber value="${item.total}" pattern="#,##0₫"/>
                                        </div>
                                        <button class="btn btn-sm btn-outline btn-remove-item" data-item-key="${item.itemKey}"
                                                style="color: var(--danger-color); border-color: var(--danger-color);">
                                            <i class="bi bi-trash"></i> Xóa
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${!status.last}">
                                <div style="height: 1px; background: var(--gray-200); margin: 1.5rem 0;"></div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Order Summary Sidebar -->
                <div class="col-lg-4">
                    <div style="position: sticky; top: 100px;">
                        <!-- Order Summary -->
                        <div style="background: white; border-radius: 16px; padding: 2rem; box-shadow: var(--shadow-md); margin-bottom: 1.5rem;">
                            <h5 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 1.5rem;">Tổng Đơn Hàng</h5>
                            
                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; color: var(--gray-700);">
                                <span>Tạm tính:</span>
                                <span style="font-weight: 600;" id="subtotal">
                                    <fmt:formatNumber value="${cart.total}" pattern="#,##0₫"/>
                                </span>
                            </div>
                            
                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; color: var(--gray-700);">
                                <span>Phí vận chuyển:</span>
                                <span style="color: var(--success-color); font-weight: 600;">Miễn phí</span>
                            </div>
                            
                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; color: var(--gray-700);">
                                <span>Giảm giá:</span>
                            </div>
                            
                            <div style="height: 1px; background: var(--gray-200); margin: 1.5rem 0;"></div>
                            
                            <div style="display: flex; justify-content: space-between; margin-bottom: 2rem;">
                                <strong style="font-size: 1.25rem;">Tổng cộng:</strong>
                                    <strong style="font-size: 1.5rem; color: var(--primary-color);" id="total-amount">
                                        <fmt:formatNumber value="${cart.total}" pattern="#,##0₫"/>
                                    </strong>
                            </div>
                            
                            <a href="${pageContext.request.contextPath}/checkout" 
                               class="btn btn-primary" 
                               style="width: 100%; height: 56px; font-size: 1.1rem; font-weight: 600; margin-bottom: 0.75rem;">
                                <i class="bi bi-credit-card"></i> Tiến Hành Thanh Toán
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/products" 
                               class="btn btn-outline" 
                               style="width: 100%; height: 48px;">
                                <i class="bi bi-arrow-left"></i> Tiếp Tục Mua Hàng
                            </a>
                        </div>
                        
                        <!-- Shipping Benefits -->
                        <div style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); 
                                    border-radius: 16px; padding: 1.5rem; box-shadow: var(--shadow-md); color: white;">
                            <h6 style="font-weight: 600; margin-bottom: 1rem; font-size: 1.1rem;">
                                <i class="bi bi-truck"></i> Ưu Đãi Vận Chuyển
                            </h6>
                            <ul style="list-style: none; padding: 0; margin: 0;">
                                <li style="display: flex; align-items: start; gap: 0.5rem; margin-bottom: 0.75rem;">
                                    <i class="bi bi-check-circle-fill" style="margin-top: 0.125rem;"></i>
                                    <span>Miễn phí vận chuyển toàn quốc</span>
                                </li>
                                <li style="display: flex; align-items: start; gap: 0.5rem; margin-bottom: 0.75rem;">
                                    <i class="bi bi-check-circle-fill" style="margin-top: 0.125rem;"></i>
                                    <span>Giao hàng trong 2-3 ngày</span>
                                </li>
                                <li style="display: flex; align-items: start; gap: 0.5rem; margin-bottom: 0.75rem;">
                                    <i class="bi bi-check-circle-fill" style="margin-top: 0.125rem;"></i>
                                    <span>Đổi trả miễn phí trong 7 ngày</span>
                                </li>
                                <li style="display: flex; align-items: start; gap: 0.5rem;">
                                    <i class="bi bi-check-circle-fill" style="margin-top: 0.125rem;"></i>
                                    <span>Hỗ trợ trả góp 0% lãi suất</span>
                                </li>
                            </ul>
                        </div>

                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
var cartContextPath = '${pageContext.request.contextPath}';

function updateQuantity(itemKey, quantity) {
    quantity = parseInt(quantity);
    if (quantity < 1) {
        if (!confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) return;
    }
    fetch(cartContextPath + '/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=update&itemKey=' + encodeURIComponent(itemKey) + '&quantity=' + quantity
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) location.reload();
        else alert(data.message || 'Có lỗi xảy ra khi cập nhật giỏ hàng');
    })
    .catch(function() { alert('Có lỗi xảy ra khi cập nhật giỏ hàng'); });
}

function removeFromCart(itemKey) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
    fetch(cartContextPath + '/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=remove&itemKey=' + encodeURIComponent(itemKey)
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) location.reload();
        else alert(data.message || 'Có lỗi xảy ra khi xóa sản phẩm');
    })
    .catch(function() { alert('Có lỗi xảy ra khi xóa sản phẩm'); });
}

function clearCart() {
    if (!confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')) return;
    fetch(cartContextPath + '/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=clear'
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) location.reload();
        else alert(data.message || 'Có lỗi xảy ra khi xóa giỏ hàng');
    })
    .catch(function() { alert('Có lỗi xảy ra khi xóa giỏ hàng'); });
}

// Event delegation for quantity buttons and remove
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.qty-decrease').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var itemKey = this.getAttribute('data-item-key');
            var qty = parseInt(this.getAttribute('data-current-qty')) - 1;
            updateQuantity(itemKey, qty);
        });
    });
    document.querySelectorAll('.qty-increase').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var itemKey = this.getAttribute('data-item-key');
            var qty = parseInt(this.getAttribute('data-current-qty')) + 1;
            updateQuantity(itemKey, qty);
        });
    });
    document.querySelectorAll('.qty-input').forEach(function(input) {
        input.addEventListener('change', function() {
            var itemKey = this.getAttribute('data-item-key');
            updateQuantity(itemKey, this.value);
        });
    });
    document.querySelectorAll('.btn-remove-item').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var itemKey = this.getAttribute('data-item-key');
            removeFromCart(itemKey);
        });
    });
    document.querySelectorAll('.qty-btn').forEach(function(btn) {
        btn.addEventListener('mouseover', function() { this.style.background = 'var(--gray-100)'; });
        btn.addEventListener('mouseout', function() { this.style.background = 'white'; });
    });
});
</script>


<script>
// Voucher AJAX logic
document.addEventListener('DOMContentLoaded', function() {
    var applyBtn = document.getElementById('apply-voucher-btn');
    var codeInput = document.getElementById('voucher-code-input');
    var discountSpan = document.getElementById('discount-amount');
    var totalSpan = document.getElementById('total-amount');
    var subtotal = ${cart.total};
    var appliedVoucher = null;
    if (applyBtn && codeInput) {
        applyBtn.addEventListener('click', function() {
            var code = codeInput.value.trim();
            if (!code) { alert('Vui lòng nhập mã giảm giá!'); return; }
            fetch(cartContextPath + '/api/voucher', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'code=' + encodeURIComponent(code) + '&orderTotal=' + subtotal
            })
            .then(r => r.json())
            .then(data => {
                if (data.success && data.voucher) {
                    appliedVoucher = data.voucher;
                    let discount = 0;
                    if (appliedVoucher.discountType === 'percent') {
                        discount = subtotal * (appliedVoucher.discountValue / 100);
                        if (appliedVoucher.maxDiscount && discount > appliedVoucher.maxDiscount) {
                            discount = appliedVoucher.maxDiscount;
                        }
                    } else if (appliedVoucher.discountType === 'amount') {
                        discount = appliedVoucher.discountValue;
                    }
                    if (discount > subtotal) discount = subtotal;
                    discountSpan.textContent = discount.toLocaleString('vi-VN') + '₫';
                    totalSpan.textContent = (subtotal - discount).toLocaleString('vi-VN') + '₫';
                    codeInput.disabled = true;
                    applyBtn.disabled = true;
                    applyBtn.textContent = 'Đã áp dụng';
                } else {
                    alert(data.message || 'Mã giảm giá không hợp lệ hoặc không đủ điều kiện.');
                }
            })
            .catch(() => alert('Có lỗi khi kiểm tra mã giảm giá.'));
        });
    }
});
</script>
<jsp:include page="../common/footer.jsp"/>
