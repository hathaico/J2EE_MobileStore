# 🎨 Hệ Thống Thông Báo Popup - Hướng Dẫn Sử Dụng

## Tổng Quan

Hệ thống thông báo popup mới được thiết kế để thay thế các Bootstrap alert cũ. Thông báo sẽ hiển thị dưới dạng popup đẹp ở góc trên bên phải của màn hình.

## 🎯 Tính Năng

- ✨ **Giao diện hiện đại**: Thiết kế gradient đẹp mắt
- 🎨 **4 loại thông báo**: Success, Error, Info, Warning
- ⏱️ **Tự động đóng**: Thông báo tự động biến mất sau 5 giây
- 📱 **Responsive**: Thích ứng với màn hình mobile
- 🎢 **Animations**: Hiệu ứng slide-in/slide-out mượt mà
- 🔄 **Progress bar**: Thanh tiến trình hiển thị thời gian còn lại

## 📚 Cách Sử Dụng

### 1️⃣ Thông Báo Thành Công
```javascript
// JavaScript
window.NotificationSystem.success('Thêm sản phẩm vào giỏ hàng thành công!', 'Thành công!');

// Hoặc ngắn gọn hơn
window.NotificationSystem.success('Sản phẩm đã được lưu');
```

### 2️⃣ Thông Báo Lỗi
```javascript
window.NotificationSystem.error('Có lỗi xảy ra khi lưu dữ liệu', 'Lỗi!');
```

### 3️⃣ Thông Báo Thông Tin
```javascript
window.NotificationSystem.info('Bạn có 3 đơn hàng chưa xác nhận', 'Thông báo');
```

### 4️⃣ Thông Báo Cảnh Báo
```javascript
window.NotificationSystem.warning('Sản phẩm này sắp hết hàng', 'Cảnh báo');
```

### 5️⃣ Thay Đổi Thời Gian Tự Động Đóng
```javascript
// Thông báo sẽ không tự động đóng
window.NotificationSystem.success('Thao tác được hoàn tất', 'Thành công!', false);

// Hoặc dùng hàm tổng quát
window.NotificationSystem.show('Tin nhắn của bạn', 'info', 'Tiêu đề', false);
```

## 🔧 Các Tham Số

### `show(message, type, title, autoClose)`
- **message** (string): Nội dung thông báo
- **type** (string): success | error | info | warning
- **title** (string): Tiêu đề (tùy chọn, sẽ dùng mặc định nếu không)
- **autoClose** (boolean): Tự động đóng sau 5s (mặc định: true)

## 💡 Ví Dụ Thực Tế

### Trong Form Thêm Sản Phẩm
```html
<form id="productForm" onsubmit="handleSubmit(event)">
    <input type="text" name="productName" required>
    <!-- các field khác -->
    <button type="submit">Thêm Sản Phẩm</button>
</form>

<script>
function handleSubmit(event) {
    event.preventDefault();
    
    // Gửi dữ liệu
    fetch('/admin/products?action=add', {
        method: 'POST',
        body: new FormData(this)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            window.NotificationSystem.success(
                'Sản phẩm đã được thêm thành công!',
                'Thêm Mới Thành Công'
            );
            // Reset form hoặc redirect
        } else {
            window.NotificationSystem.error(
                data.message || 'Có lỗi xảy ra',
                'Thao Tác Thất Bại'
            );
        }
    });
}
</script>
```

### Khi Thêm Sản Phẩm Vào Giỏ
```javascript
document.querySelectorAll('.btn-add-to-cart').forEach(btn => {
    btn.addEventListener('click', function() {
        const productId = this.getAttribute('data-product-id');
        
        fetch('/cart?action=add', {
            method: 'POST',
            body: `productId=${productId}&quantity=1`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                window.NotificationSystem.success(
                    'Sản phẩm đã được thêm vào giỏ hàng!',
                    'Thêm Giỏ Hàng'
                );
            }
        });
    });
});
```

### Khi Xóa Sản Phẩm
```javascript
function deleteProduct(productId) {
    if (confirm('Bạn chắc chắn muốn xóa sản phẩm này?')) {
        fetch(`/admin/products?action=delete&id=${productId}`, {
            method: 'DELETE'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                window.NotificationSystem.success(
                    'Sản phẩm đã được xóa thành công!',
                    'Xóa Thành Công'
                );
                // Reload page hoặc ẩn row
                setTimeout(() => location.reload(), 1500);
            }
        });
    }
}
```

## 🎨 Tùy Chỉnh Giao Diện

### Màu Sắc Theo Loại Thông Báo

| Loại | Màu Border | Màu Nền | Biểu Tượng |
|------|-----------|---------|-----------|
| Success | #10B981 (Xanh lá) | gradient green | ✓ |
| Error | #EF4444 (Đỏ) | gradient red | ⚠️ |
| Info | #2563EB (Xanh dương) | gradient blue | ⓘ |
| Warning | #F59E0B (Vàng) | gradient yellow | ⚠️ |

## 📍 Vị Trí Hiển Thị

- **Desktop**: Góc trên bên phải, cách từ mép 20px
- **Tablet/Mobile**: Full width (trừ lề 12px)
- **Z-index**: 9999 (luôn hiển thị ở trên cùng)

## ⏱️ Thời Gian Tự Động Đóng

Mặc định: **5 giây**

Bạn có thể thay đổi bằng cách sửa trong `footer.jsp`:
```javascript
setTimeout(() => {
    this.remove(notification);
}, 5000); // Thay 5000 ms = 5s thành giá trị khác
```

## 🔄 Loại Bỏ Thông Báo Cũ

Các tệp đã cập nhật:
- ✅ `index.jsp` - Đã xóa Bootstrap alert logout
- ✅ `header.jsp` - Thêm notification container + CSS
- ✅ `footer.jsp` - Thêm JavaScript notification system

Để thay đổi các tệp khác, chỉ cần loại bỏ `<div class="alert">...</div>` cũ và js sẽ tự động xử lý qua URL parameters.

## 🚀 Khởi Chạy

1. Truy cập trang chủ: `http://localhost:8080/mobilestore/`
2. Đăng xuất để thấy thông báo popup
3. Kiểm tra console (F12) để xem logs

## 📝 Các JSP đã được cập nhật

1. **index.jsp**
   - Xóa Bootstrap alert cũ cho logout
   - Giữ lại JSP logic để skip rendering nếu không có logout param

2. **header.jsp**
   - Thêm notification container: `<div id="notificationContainer">`
   - Thêm CSS cho notification UI (173 dòng)
   - Mobile responsive styles

3. **footer.jsp**
   - Thêm NotificationSystem JavaScript object
   - Auto-initialization cho logout redirect

## ✨ Ưu Điểm So Với Bootstrap Alert

| Tính Năng | Alert Cũ | Notification Mới |
|----------|----------|------------------|
| Giao diện | Cơ bản | Hiện đại, gradient |
| Vị trí | Inline | Fixed, corner |
| Animation | Fade | Slide in/out |
| Progress | Không | Có |
| Responsive | Bình thường | Tối ưu |
| Tích hợp | Manual | Auto |

## 🎯 Các Trang Tiếp Theo Có Thể Sử Dụng

- Product admin: Thêm/Sửa/Xóa sản phẩm
- User admin: Quản lý người dùng  
- Order admin: Xác nhận đơn hàng
- Cart page: Thêm/Xóa sản phẩm
- Checkout: Hoàn tất thanh toán
- User profile: Cập nhật thông tin

---

**Version**: 1.0  
**Last Updated**: 2026-04-01  
**Status**: ✅ Production Ready
