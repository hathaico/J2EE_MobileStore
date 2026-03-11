<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Mobile Store - Cửa Hàng Điện Thoại Uy Tín" scope="request"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<!-- Logout Success Message -->
<c:if test="${param.logout == 'success'}">
    <div class="container mt-3" style="max-width: 1200px;">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            Đã đăng xuất thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </div>
</c:if>

<!-- Hero Banner Section -->
<section style="background: linear-gradient(135deg, #2563EB 0%, #1e40af 60%, #1e3a8a 100%); padding: 80px 0; color: #fff; position: relative; overflow: hidden;">
    <!-- Background Pattern -->
    <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: radial-gradient(rgba(255,255,255,0.08) 1px, transparent 1px); background-size: 30px 30px;"></div>
    
    <div class="container" style="max-width: 1200px; position: relative; z-index: 1;">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 style="font-size: 3.2rem; font-weight: 700; margin-bottom: 20px; line-height: 1.2;">Smartphone Mới Nhất <br>Với Giá Tốt Nhất</h1>
                <p style="font-size: 1.15rem; margin-bottom: 28px; opacity: 0.92; line-height: 1.7;">Khám phá bộ sưu tập điện thoại thông minh từ các thương hiệu hàng đầu thế giới. Ưu đãi đặc biệt lên đến 50%!</p>
                <div style="display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 36px;">
                    <a href="${pageContext.request.contextPath}/products" 
                       style="display: inline-flex; align-items: center; gap: 8px; background: #fff; color: #2563EB; padding: 14px 32px; border-radius: 10px; font-weight: 600; font-size: 1.05rem; text-decoration: none; box-shadow: 0 4px 14px rgba(0,0,0,0.15); transition: transform 0.2s;">
                        <i class="bi bi-bag"></i> Mua Ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/products?deals=true" 
                       style="display: inline-flex; align-items: center; gap: 8px; background: transparent; color: #fff; padding: 14px 32px; border-radius: 10px; font-weight: 600; font-size: 1.05rem; text-decoration: none; border: 2px solid rgba(255,255,255,0.5); transition: all 0.2s;">
                        <i class="bi bi-lightning-fill"></i> Xem Ưu Đãi
                    </a>
                </div>
                
                <!-- Trust Badges -->
                <div style="display: flex; gap: 32px; flex-wrap: wrap;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="bi bi-shield-check" style="font-size: 1.8rem; opacity: 0.9;"></i>
                        <div>
                            <strong style="font-size: 0.95rem;">Bảo Hành</strong><br>
                            <small style="opacity: 0.8; font-size: 0.85rem;">12 tháng</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="bi bi-truck" style="font-size: 1.8rem; opacity: 0.9;"></i>
                        <div>
                            <strong style="font-size: 0.95rem;">Miễn Phí</strong><br>
                            <small style="opacity: 0.8; font-size: 0.85rem;">Vận chuyển</small>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <i class="bi bi-arrow-repeat" style="font-size: 1.8rem; opacity: 0.9;"></i>
                        <div>
                            <strong style="font-size: 0.95rem;">Đổi Trả</strong><br>
                            <small style="opacity: 0.8; font-size: 0.85rem;">Trong 7 ngày</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 d-none d-lg-flex" style="justify-content: center; align-items: center;">
                <div style="width: 320px; height: 400px; background: rgba(255,255,255,0.08); border-radius: 40px; display: flex; align-items: center; justify-content: center; border: 3px solid rgba(255,255,255,0.12); position: relative;">
                    <i class="bi bi-phone" style="font-size: 10rem; color: rgba(255,255,255,0.25);"></i>
                    <!-- Floating decorations -->
                    <div style="position: absolute; top: -20px; right: -20px; width: 60px; height: 60px; background: rgba(255,255,255,0.1); border-radius: 50%;"></div>
                    <div style="position: absolute; bottom: -15px; left: -15px; width: 40px; height: 40px; background: rgba(255,255,255,0.08); border-radius: 50%;"></div>
                    <div style="position: absolute; top: 40%; right: -35px; width: 24px; height: 24px; background: #f59e0b; border-radius: 50%; opacity: 0.8;"></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Shop by Brand Section -->
<section class="brand-section">
    <div class="container" style="max-width: 1200px;">
        <div style="text-align: center; margin-bottom: 36px;">
            <h2 class="brand-section-title">Thương Hiệu Nổi Bật</h2>
            <p class="brand-section-subtitle">Chọn thương hiệu smartphone yêu thích của bạn</p>
        </div>
        
        <div class="brand-grid-home">
            <!-- Apple -->
            <a href="${pageContext.request.contextPath}/products?brand=Apple" class="brand-card">
                <svg viewBox="0 0 170 200" class="brand-logo">
                    <path d="M119.62 40.18c-5.85 6.83-15.35 12.12-24.72 11.37a34.15 34.15 0 01-.26-4.19c0-10.6 4.6-21.93 12.78-31.15 4.08-4.7 9.28-8.6 15.57-11.72 6.26-3.08 12.19-4.78 17.8-5.07.22 1.5.26 3 .26 4.42 0 10.6-3.63 21.28-11.97 27.57l-9.46 8.77z" fill="#333"/>
                    <path d="M131.3 57.57c-7.85-4.67-14.56-3.35-20.73-3.35-7.2 0-13.7-2.5-21.1-2.5-15.95.24-31.13 14.35-31.13 36.42 0 22.07 7.65 47.8 17.04 63.6 7.86 13.2 14.7 24.26 25.32 24.26 9.72 0 14.27-6.89 24.95-6.89 10.87 0 13.94 6.67 24.57 6.67 11.32 0 18.37-12.22 25.58-24.26 4.47-7.42 6.14-11.2 9.56-19.6-25.13-9.54-29.16-45.2-4.46-58.76-9.24-11.59-22.1-17.01-32.22-16.82l-17.38 1.23z" fill="#333"/>
                    <text x="85" y="188" text-anchor="middle" font-family="'SF Pro Display', -apple-system, Arial, sans-serif" font-size="28" font-weight="600" fill="#333">Apple</text>
                </svg>
            </a>
            <!-- Samsung -->
            <a href="${pageContext.request.contextPath}/products?brand=Samsung" class="brand-card">
                <svg viewBox="0 0 460 100" class="brand-logo">
                    <text x="230" y="65" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="58" font-weight="700" letter-spacing="8" fill="#1428A0">SAMSUNG</text>
                </svg>
            </a>
            <!-- Xiaomi -->
            <a href="${pageContext.request.contextPath}/products?brand=Xiaomi" class="brand-card">
                <svg viewBox="0 0 180 80" class="brand-logo">
                    <rect x="2" y="2" width="56" height="56" rx="14" fill="#FF6900"/>
                    <path d="M20 42h-7V24h7v18zm0-22h-14v22h-7V16c0-3.5 2.8-6.3 6.3-6.3H20v10zm20 22h-7V28h-6v-4h-7V16h13c4 0 7 3 7 7v19z" transform="translate(6,6) scale(0.75)" fill="#fff"/>
                    <text x="100" y="44" font-family="'Helvetica Neue', Arial, sans-serif" font-size="32" font-weight="500" fill="#FF6900">xiaomi</text>
                </svg>
            </a>
            <!-- OPPO -->
            <a href="${pageContext.request.contextPath}/products?brand=Oppo" class="brand-card">
                <svg viewBox="0 0 280 80" class="brand-logo">
                    <text x="140" y="58" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="56" font-weight="700" letter-spacing="10" fill="#1A8A3E">OPPO</text>
                </svg>
            </a>
            <!-- Vivo -->
            <a href="${pageContext.request.contextPath}/products?brand=Vivo" class="brand-card">
                <svg viewBox="0 0 200 80" class="brand-logo">
                    <text x="100" y="58" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="52" font-weight="400" letter-spacing="6" fill="#456FFF">vivo</text>
                </svg>
            </a>
            <!-- Realme -->
            <a href="${pageContext.request.contextPath}/products?brand=Realme" class="brand-card">
                <svg viewBox="0 0 260 80" class="brand-logo">
                    <text x="130" y="56" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="50" font-weight="700" letter-spacing="2" fill="#F5C518">realme</text>
                </svg>
            </a>
            <!-- Huawei -->
            <a href="${pageContext.request.contextPath}/products?brand=Huawei" class="brand-card">
                <svg viewBox="0 0 260 80" class="brand-logo">
                    <g transform="translate(20, 6) scale(0.42)" fill="#CF0A2C">
                        <path d="M85 0c-4 8-14 28-14 40 0 8 4 14 14 17 10-3 14-9 14-17 0-12-10-32-14-40z"/>
                        <path d="M43 36c1 9 5 32 12 40 5 5 12 7 21 3 4-10 3-17-3-22-7-8-23-19-30-21z"/>
                        <path d="M127 36c-7 2-23 13-30 21-6 5-7 12-3 22 9 4 16 2 21-3 7-8 11-31 12-40z"/>
                        <path d="M26 90c8 4 29 13 40 13 7 0 14-4 16-14-7-7-14-9-21-9-9 1-26 7-35 10z"/>
                        <path d="M144 90c-9-3-26-9-35-10-7 0-14 2-21 9 2 10 9 14 16 14 11 0 32-9 40-13z"/>
                        <path d="M48 134c7-6 24-20 28-30 3-7 1-14-7-20-9 2-14 8-15 15-2 10-4 27-6 35z"/>
                        <path d="M122 134c-2-8-4-25-6-35-1-7-6-13-15-15-8 6-10 13-7 20 4 10 21 24 28 30z"/>
                        <path d="M85 142c6-7 19-25 21-36 2-7-1-14-10-18-8 5-11 12-11 19 0 9 0 27 0 35z"/>
                        <path d="M85 142c-6-7-19-25-21-36-2-7 1-14 10-18 8 5 11 12 11 19 0 9 0 27 0 35z"/>
                    </g>
                    <text x="160" y="54" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="36" font-weight="700" fill="#CF0A2C">HUAWEI</text>
                </svg>
            </a>
            <!-- OnePlus -->
            <a href="${pageContext.request.contextPath}/products?brand=OnePlus" class="brand-card">
                <svg viewBox="0 0 280 80" class="brand-logo">
                    <text x="140" y="56" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="46" font-weight="600" letter-spacing="1" fill="#F5010C">OnePlus</text>
                </svg>
            </a>
            <!-- Google Pixel -->
            <a href="${pageContext.request.contextPath}/products?brand=Google" class="brand-card">
                <svg viewBox="0 0 280 80" class="brand-logo">
                    <text x="18" y="58" font-family="'Product Sans', 'Helvetica Neue', Arial, sans-serif" font-size="54" font-weight="500">
                        <tspan fill="#4285F4">G</tspan><tspan fill="#EA4335">o</tspan><tspan fill="#FBBC05">o</tspan><tspan fill="#4285F4">g</tspan><tspan fill="#34A853">l</tspan><tspan fill="#EA4335">e</tspan>
                    </text>
                </svg>
            </a>
            <!-- Motorola -->
            <a href="${pageContext.request.contextPath}/products?brand=Motorola" class="brand-card">
                <svg viewBox="0 0 260 80" class="brand-logo">
                    <g transform="translate(16, 8)">
                        <circle cx="32" cy="32" r="30" fill="none" stroke="#5C2D91" stroke-width="4"/>
                        <circle cx="32" cy="32" r="8" fill="#5C2D91"/>
                        <path d="M32 6L22 32l10-8 10 8Z" fill="#5C2D91"/>
                    </g>
                    <text x="168" y="54" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-size="34" font-weight="500" letter-spacing="1" fill="#5C2D91">motorola</text>
                </svg>
            </a>
        </div>
    </div>
</section>



<!-- Promotional Deals Section -->
<section style="background: #F8FAFC; padding: 60px 0;">
    <div class="container" style="max-width: 1200px;">
        <div style="text-align: center; margin-bottom: 40px;">
            <h2 style="font-size: 2rem; font-weight: 700; color: #1F2937; margin-bottom: 8px;">Ưu Đãi Đặc Biệt</h2>
            <p style="color: #6b7280; font-size: 1.05rem;">Giảm giá lên đến 50% cho các sản phẩm được chọn lọc</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-6">
                <div style="background: linear-gradient(135deg, #2563EB 0%, #1d4ed8 100%); border-radius: 16px; padding: 48px 36px; color: white; position: relative; overflow: hidden; box-shadow: 0 10px 30px rgba(37,99,235,0.25);">
                    <i class="bi bi-lightning-fill" style="position: absolute; right: -30px; top: -30px; font-size: 14rem; opacity: 0.1;"></i>
                    <h3 style="font-size: 1.8rem; margin-bottom: 12px; position: relative; font-weight: 700;">Flash Sale</h3>
                    <p style="font-size: 1.05rem; opacity: 0.92; margin-bottom: 24px; position: relative;">Giảm giá sốc trong thời gian có hạn</p>
                    <a href="${pageContext.request.contextPath}/products?deals=true" 
                       style="display: inline-flex; align-items: center; gap: 8px; background: #fff; color: #2563EB; padding: 12px 28px; border-radius: 10px; font-weight: 600; text-decoration: none; position: relative;">
                        Mua Ngay <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <div style="background: linear-gradient(135deg, #F43F5E 0%, #dc2626 100%); border-radius: 16px; padding: 48px 36px; color: white; position: relative; overflow: hidden; box-shadow: 0 10px 30px rgba(244,63,94,0.25);">
                    <i class="bi bi-gift-fill" style="position: absolute; right: -30px; top: -30px; font-size: 14rem; opacity: 0.1;"></i>
                    <h3 style="font-size: 1.8rem; margin-bottom: 12px; position: relative; font-weight: 700;">Quà Tặng Hấp Dẫn</h3>
                    <p style="font-size: 1.05rem; opacity: 0.92; margin-bottom: 24px; position: relative;">Nhận ngay phụ kiện miễn phí khi mua hàng</p>
                    <a href="${pageContext.request.contextPath}/products" 
                       style="display: inline-flex; align-items: center; gap: 8px; background: #fff; color: #F43F5E; padding: 12px 28px; border-radius: 10px; font-weight: 600; text-decoration: none; position: relative;">
                        Khám Phá <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Customer Reviews Section -->
<section style="padding: 60px 0;">
    <div class="container" style="max-width: 1200px;">
        <div style="text-align: center; margin-bottom: 40px;">
            <h2 style="font-size: 2rem; font-weight: 700; color: #1F2937; margin-bottom: 8px;">Khách Hàng Nói Gì</h2>
            <p style="color: #6b7280; font-size: 1.05rem;">Đánh giá từ những khách hàng đã mua sắm tại Mobile Store</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div style="background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB; height: 100%;">
                    <div style="color: #f59e0b; margin-bottom: 14px; font-size: 1.1rem; display: flex; gap: 2px;">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <p style="color: #374151; line-height: 1.7; margin-bottom: 20px; font-size: 0.95rem;">
                        "Sản phẩm chính hãng, giá cả hợp lý, giao hàng nhanh. Tôi rất hài lòng với dịch vụ!"
                    </p>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background: linear-gradient(135deg, #2563EB, #60a5fa); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-person-fill" style="font-size: 1.3rem; color: white;"></i>
                        </div>
                        <div>
                            <strong style="color: #1F2937; font-size: 0.95rem;">Nguyễn Văn A</strong><br>
                            <small style="color: #6b7280;">Khách hàng thân thiết</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div style="background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB; height: 100%;">
                    <div style="color: #f59e0b; margin-bottom: 14px; font-size: 1.1rem; display: flex; gap: 2px;">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <p style="color: #374151; line-height: 1.7; margin-bottom: 20px; font-size: 0.95rem;">
                        "Tư vấn nhiệt tình, chuyên nghiệp. Đã mua nhiều lần và sẽ tiếp tục ủng hộ!"
                    </p>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background: linear-gradient(135deg, #2563EB, #60a5fa); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-person-fill" style="font-size: 1.3rem; color: white;"></i>
                        </div>
                        <div>
                            <strong style="color: #1F2937; font-size: 0.95rem;">Trần Thị B</strong><br>
                            <small style="color: #6b7280;">Khách hàng mới</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div style="background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB; height: 100%;">
                    <div style="color: #f59e0b; margin-bottom: 14px; font-size: 1.1rem; display: flex; gap: 2px;">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-half"></i>
                    </div>
                    <p style="color: #374151; line-height: 1.7; margin-bottom: 20px; font-size: 0.95rem;">
                        "Chất lượng tốt, bảo hành chu đáo. Rất đáng tin cậy!"
                    </p>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 48px; height: 48px; background: linear-gradient(135deg, #2563EB, #60a5fa); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-person-fill" style="font-size: 1.3rem; color: white;"></i>
                        </div>
                        <div>
                            <strong style="color: #1F2937; font-size: 0.95rem;">Lê Văn C</strong><br>
                            <small style="color: #6b7280;">Đã mua 3 lần</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
