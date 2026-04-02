<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Mobile Store</title>
    
    <!-- Google Fonts - Noto Sans Vietnamese -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .register-container {
            min-height: 100vh;
            padding: 2rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .register-card {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        .register-logo {
            text-align: center;
            margin-bottom: 2rem;
        }
        .register-logo i {
            font-size: 3rem;
            color: #667eea;
        }
        .register-logo h2 {
            color: #333;
            margin-top: 1rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.75rem;
            font-weight: 600;
        }
        .btn-register:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            transition: all 0.3s;
        }
        .register-footer {
            text-align: center;
            margin-top: 1.5rem;
            color: #666;
        }
        .required-label::after {
            content: " *";
            color: red;
        }

        /* Notification Container Styles (from global system) */
        .notification-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-width: 400px;
            pointer-events: none;
        }

        .notification {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 16px 20px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.12);
            border-left: 4px solid;
            animation: slideInRight 0.3s ease-out;
            pointer-events: auto;
            min-height: 64px;
        }

        .notification.error {
            border-left-color: #EF4444;
            background: linear-gradient(135deg, #FEF2F2 0%, #FEE2E2 100%);
        }

        .notification-icon {
            flex-shrink: 0;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-top: 2px;
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
        }

        .notification-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .notification-title {
            font-weight: 600;
            font-size: 0.95rem;
            color: #991B1B;
        }

        .notification-message {
            font-size: 0.85rem;
            color: #7F1D1D;
            line-height: 1.4;
        }

        .notification-close {
            flex-shrink: 0;
            background: none;
            border: none;
            color: #9CA3AF;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 0;
            margin-top: 2px;
            transition: color 0.2s;
        }

        .notification-close:hover {
            color: #1F2937;
        }

        .notification-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 3px;
            width: 100%;
            border-radius: 0 0 12px 12px;
            background: #EF4444;
            animation: progress 5s linear;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(400px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideOutRight {
            from {
                opacity: 1;
                transform: translateX(0);
            }
            to {
                opacity: 0;
                transform: translateX(400px);
            }
        }

        @keyframes progress {
            from { width: 100%; }
            to { width: 0%; }
        }

        .notification.removing {
            animation: slideOutRight 0.3s ease-out forwards;
        }
    </style>
</head>
<body>
    <!-- Notification Container -->
    <div class="notification-container" id="notificationContainer" style="position: fixed; top: 20px; right: 20px; z-index: 9999; display: flex; flex-direction: column; gap: 12px; max-width: 400px; pointer-events: none;"></div>

    <div class="register-container">
        <div class="register-card">
            <div class="register-logo">
                <i class="bi bi-person-plus-fill"></i>
                <h2>Đăng Ký Tài Khoản</h2>
                <p class="text-muted">Tạo tài khoản mới để mua sắm</p>
            </div>
            
            <!-- Error Message - Now using Notification System -->
            <c:if test="${not empty error}">
                <script>
                    // Notification system for standalone pages (register)
                    window.NotificationSystem = window.NotificationSystem || {
                        container: document.getElementById('notificationContainer'),
                        
                        show: function(message, type = 'error', title = 'Lỗi!', autoClose = false) {
                            const notification = document.createElement('div');
                            notification.className = `notification ${type}`;
                            
                            notification.innerHTML = `
                                <div class="notification-icon">
                                    <i class="bi bi-exclamation-circle-fill"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">${title}</div>
                                    <div class="notification-message">${message}</div>
                                </div>
                                <button type="button" class="notification-close" aria-label="Close">
                                    <i class="bi bi-x"></i>
                                </button>
                                <div class="notification-progress"></div>
                            `;

                            this.container.appendChild(notification);

                            notification.querySelector('.notification-close').addEventListener('click', () => {
                                this.remove(notification);
                            });

                            if (autoClose) {
                                setTimeout(() => {
                                    this.remove(notification);
                                }, 5000);
                            }

                            return notification;
                        },

                        error: function(message, title = 'Lỗi!', autoClose = false) {
                            return this.show(message, 'error', title, autoClose);
                        },

                        remove: function(notification) {
                            notification.classList.add('removing');
                            setTimeout(() => {
                                notification.remove();
                            }, 300);
                        }
                    };

                    document.addEventListener('DOMContentLoaded', function() {
                        window.NotificationSystem.error('${error}', 'Đăng Ký Thất Bại!', false);
                    });
                </script>
            </c:if>
            
            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <div class="mb-3">
                    <label for="username" class="form-label required-label">
                        <i class="bi bi-person"></i> Username
                    </label>
                    <input type="text" class="form-control" id="username" name="username" 
                           value="${username}" required 
                           pattern="[a-zA-Z0-9]{3,20}"
                           title="Username: 3-20 ký tự, chỉ chữ cái và số"
                           placeholder="Ví dụ: johnsmith">
                    <small class="text-muted">3-20 ký tự, chỉ chữ cái và số</small>
                </div>
                
                <div class="mb-3">
                    <label for="fullName" class="form-label required-label">
                        <i class="bi bi-card-text"></i> Họ và Tên
                    </label>
                    <input type="text" class="form-control" id="fullName" name="fullName" 
                           value="${fullName}" required 
                           placeholder="Ví dụ: Nguyễn Văn A">
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label required-label">
                        <i class="bi bi-envelope"></i> Email
                    </label>
                    <input type="email" class="form-control" id="email" name="email" 
                           value="${email}" required 
                           placeholder="example@email.com">
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label required-label">
                        <i class="bi bi-lock"></i> Password
                    </label>
                    <input type="password" class="form-control" id="password" name="password" 
                           required minlength="6"
                           placeholder="Ít nhất 6 ký tự">
                    <small class="text-muted">Ít nhất 6 ký tự</small>
                </div>
                
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label required-label">
                        <i class="bi bi-lock-fill"></i> Xác Nhận Password
                    </label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           required minlength="6"
                           placeholder="Nhập lại password">
                </div>
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-register">
                        <i class="bi bi-person-check"></i> Đăng Ký
                    </button>
                </div>
            </form>
            
            <div class="register-footer">
                <p>Đã có tài khoản? 
                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold">
                        Đăng nhập ngay
                    </a>
                </p>
                <hr>
                <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const username = document.getElementById('username').value;
            
            // Check username format
            if (!/^[a-zA-Z0-9]{3,20}$/.test(username)) {
                e.preventDefault();
                alert('Username phải từ 3-20 ký tự và chỉ chứa chữ cái, số!');
                return false;
            }
            
            // Check password length
            if (password.length < 6) {
                e.preventDefault();
                alert('Password phải có ít nhất 6 ký tự!');
                return false;
            }
            
            // Check password match
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Xác nhận password không khớp!');
                return false;
            }
            
            return true;
        });
        
        // Real-time password match validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.setCustomValidity('Password không khớp');
                this.classList.add('is-invalid');
            } else {
                this.setCustomValidity('');
                this.classList.remove('is-invalid');
                if (confirmPassword) {
                    this.classList.add('is-valid');
                }
            }
        });
    </script>
</body>
</html>
