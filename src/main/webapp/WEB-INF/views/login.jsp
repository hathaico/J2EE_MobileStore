<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Mobile Store</title>
    
    <!-- Google Fonts - Noto Sans Vietnamese -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            padding: 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        .login-logo {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-logo i {
            font-size: 4rem;
            color: #667eea;
        }
        .login-logo h2 {
            color: #333;
            margin-top: 1rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.75rem;
            font-weight: 600;
        }
        .btn-login:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            transition: all 0.3s;
        }
        .login-footer {
            text-align: center;
            margin-top: 1.5rem;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-logo">
                <i class="bi bi-phone"></i>
                <h2>Mobile Store</h2>
                <p class="text-muted">Đăng nhập vào tài khoản</p>
            </div>
            
            <!-- Success Message -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <div class="mb-3">
                    <label for="username" class="form-label">
                        <i class="bi bi-person"></i> Username
                    </label>
                    <input type="text" class="form-control" id="username" name="username" 
                           value="${username}" required autofocus 
                           placeholder="Nhập username">
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">
                        <i class="bi bi-lock"></i> Password
                    </label>
                    <input type="password" class="form-control" id="password" name="password" 
                           required placeholder="Nhập password">
                </div>
                
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember">
                    <label class="form-check-label" for="remember">
                        Ghi nhớ đăng nhập
                    </label>
                </div>
                
                <input type="hidden" name="redirect" value="${param.redirect}">
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-login">
                        <i class="bi bi-box-arrow-in-right"></i> Đăng Nhập
                    </button>
                </div>
            </form>
            
            <div class="login-footer">
                <p>Chưa có tài khoản? 
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold">
                        <i class="bi bi-person-plus"></i> Đăng ký ngay
                    </a>
                </p>
                <hr>
                <p>Demo Accounts:</p>
                <small class="text-muted">
                    <strong>Admin:</strong> admin / admin123<br>
                    <strong>Staff:</strong> staff / admin123
                </small>
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
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            
            if (username === '' || password === '') {
                e.preventDefault();
                alert('Vui lòng nhập đầy đủ thông tin!');
                return false;
            }
            
            if (username.length < 3) {
                e.preventDefault();
                alert('Username phải có ít nhất 3 ký tự!');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>
