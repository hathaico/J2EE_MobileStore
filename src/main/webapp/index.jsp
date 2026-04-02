<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Mobile Store - Cửa Hàng Điện Thoại Uy Tín" scope="request"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

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
            <a href="${pageContext.request.contextPath}/products?brand=Apple" class="brand-card brand-card--apple"><span class="brand-wordmark brand-wordmark--apple">Apple</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Samsung" class="brand-card brand-card--samsung"><span class="brand-wordmark brand-wordmark--samsung">SAMSUNG</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Xiaomi" class="brand-card brand-card--xiaomi"><span class="brand-wordmark brand-wordmark--xiaomi">xiaomi</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Oppo" class="brand-card brand-card--oppo"><span class="brand-wordmark brand-wordmark--oppo">OPPO</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Vivo" class="brand-card brand-card--vivo"><span class="brand-wordmark brand-wordmark--vivo">vivo</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Realme" class="brand-card brand-card--realme"><span class="brand-wordmark brand-wordmark--realme">realme</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Huawei" class="brand-card brand-card--huawei"><span class="brand-wordmark brand-wordmark--huawei">HUAWEI</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=OnePlus" class="brand-card brand-card--oneplus"><span class="brand-wordmark brand-wordmark--oneplus">OnePlus</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Google" class="brand-card brand-card--google"><span class="brand-wordmark brand-wordmark--google">Google</span></a>
            <a href="${pageContext.request.contextPath}/products?brand=Motorola" class="brand-card brand-card--motorola"><span class="brand-wordmark brand-wordmark--motorola">motorola</span></a>
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
