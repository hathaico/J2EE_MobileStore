// Mobile Store - JavaScript Functions

// Show toast notification
function showToast(message, type = 'info') {
    const normalizedMessage = normalizeToastMessage(message);
    const toast = document.createElement('div');
    toast.className = `toast-notification toast-${type}`;
    toast.innerHTML = `
        <i class="bi ${type === 'success' ? 'bi-check-circle-fill' : type === 'error' ? 'bi-exclamation-circle-fill' : type === 'warning' ? 'bi-exclamation-triangle-fill' : 'bi-info-circle-fill'}"></i>
        <span>${normalizedMessage}</span>
        <button type="button" class="toast-close" aria-label="Đóng">&times;</button>
    `;
    document.body.appendChild(toast);

    const closeBtn = toast.querySelector('.toast-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        });
    }

    setTimeout(() => {
        toast.classList.add('show');
    }, 10);

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 5000);
}

function normalizeToastMessage(message) {
    if (message === null || message === undefined) {
        return 'Có thông báo mới.';
    }

    if (typeof message === 'boolean') {
        return message ? 'Thao tác thành công.' : 'Thao tác chưa thành công.';
    }

    const text = String(message).trim();
    if (!text) {
        return 'Có thông báo mới.';
    }

    if (text.toLowerCase() === 'false') {
        return 'Thao tác chưa thành công.';
    }
    if (text.toLowerCase() === 'true') {
        return 'Thao tác thành công.';
    }

    return text;
}

function showAlert(message, type = 'info') {
    showToast(message, type);
}

// Confirm delete action
function confirmDelete(message = 'Bạn có chắc chắn muốn xóa?') {
    return confirm(message);
}

// Format currency (VND)
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Format date
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN');
}

// Add to cart (AJAX)
function addToCart(productId, quantity = 1) {
    const contextPath = getContextPath();
    
    fetch(contextPath + '/cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=add&productId=${productId}&quantity=${quantity}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('Đã thêm vào giỏ hàng!', 'success');
            updateCartBadge(data.cartCount);
        } else {
            showAlert(data.message || 'Có lỗi xảy ra!', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Có lỗi xảy ra!', 'danger');
    });
}

// Add to cart with quantity from input
function addToCartWithQuantity(productId) {
    const quantityInput = document.getElementById('quantity');
    const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
    
    if (quantity < 1) {
        showAlert('Số lượng phải lớn hơn 0!', 'warning');
        return;
    }
    
    addToCart(productId, quantity);
}

// Get context path
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

// Update cart badge
function updateCartBadge(count) {
    const normalizedCount = Number.isFinite(Number(count)) ? Number(count) : 0;
    let badge = document.querySelector('#cart-count-badge') || document.querySelector('.cart-badge') || document.querySelector('.ms-nav-icon .ms-badge');

    if (!badge) {
        const cartLink = document.querySelector('a.ms-nav-icon[title="Giỏ hàng"]');
        if (cartLink) {
            badge = document.createElement('span');
            badge.id = 'cart-count-badge';
            badge.className = 'ms-badge cart-badge';
            cartLink.appendChild(badge);
        }
    }

    if (!badge) {
        return;
    }

    badge.textContent = String(normalizedCount);
    badge.style.display = normalizedCount > 0 ? 'flex' : 'none';
}

// Form validation
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return false;
    
    let isValid = true;
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
        }
    });
    
    return isValid;
}

// Clear form validation
function clearValidation(formId) {
    const form = document.getElementById(formId);
    if (!form) return;
    
    const inputs = form.querySelectorAll('.is-invalid, .is-valid');
    inputs.forEach(input => {
        input.classList.remove('is-invalid', 'is-valid');
    });
}

// Initialize tooltips and popovers (Bootstrap)
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Convert existing Bootstrap alerts to toast popups
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        const message = alert.textContent.trim();
        const type = alert.classList.contains('alert-success') ? 'success'
            : alert.classList.contains('alert-danger') ? 'error'
            : alert.classList.contains('alert-warning') ? 'warning'
            : 'info';
        if (message) {
            showToast(message, type);
        }
        alert.remove();
    });

    // Replace native alert() with toast popup
    window.nativeAlert = window.alert.bind(window);
    window.alert = function(message) {
        showToast(message, 'info');
    };

    // Back to Top Button
    const backToTopButton = document.getElementById('backToTop');
    if (backToTopButton) {
        // Show/hide button on scroll
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTopButton.classList.add('show');
            } else {
                backToTopButton.classList.remove('show');
            }
        });
        
        // Smooth scroll to top on click
        backToTopButton.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // Add to Cart Animation
    const addToCartButtons = document.querySelectorAll('[data-product-id]');
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            const cartIcon = document.querySelector('.ms-nav-icon .bi-cart3');
            if (cartIcon) {
                cartIcon.classList.add('cart-added');
                setTimeout(() => {
                    cartIcon.classList.remove('cart-added');
                }, 600);
            }
        });
    });
});
