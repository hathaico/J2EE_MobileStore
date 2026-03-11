<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi Máy Chủ</title>
    
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
        <h1 class="display-1"><i class="bi bi-exclamation-octagon text-danger"></i></h1>
        <h1 class="display-3">500</h1>
        <h2>Lỗi Máy Chủ</h2>
        <p class="lead">Đã xảy ra lỗi trên máy chủ của chúng tôi.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary"><i class="bi bi-house"></i> Về Trang Chủ</a>
    </div>
</body>
</html>
