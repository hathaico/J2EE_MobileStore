<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không Tìm Thấy Trang</title>
    
    <!-- Google Fonts - Noto Sans Vietnamese -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
    </style>
</head>
<body>
    <div class="container mt-5 text-center">
        <h1 class="display-1"><i class="bi bi-exclamation-triangle text-warning"></i></h1>
        <h1 class="display-3">404</h1>
        <h2>Không Tìm Thấy Trang</h2>
        <p class="lead">Trang bạn đang tìm kiếm không tồn tại.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary"><i class="bi bi-house"></i> Về Trang Chủ</a>
    </div>
</body>
</html>
