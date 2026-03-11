<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!-- Modern Footer -->
    <footer style="background: #1F2937; color: #fff; padding: 60px 0 30px; margin-top: 60px;">
        <div class="container" style="max-width: 1200px;">
            <!-- Footer Grid: 4 columns using Bootstrap -->
            <div class="row g-4" style="margin-bottom: 40px;">
                <!-- Company Info -->
                <div class="col-lg-3 col-md-6">
                    <h5 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 20px; color: #fff;">
                        <i class="bi bi-phone-fill" style="color: #60a5fa;"></i> Mobile Store
                    </h5>
                    <p style="color: rgba(255,255,255,0.75); line-height: 1.8; font-size: 0.95rem;">
                        Hệ thống bán lẻ điện thoại uy tín, chuyên nghiệp với đa dạng sản phẩm từ các thương hiệu hàng đầu thế giới.
                    </p>
                    <div style="display: flex; gap: 16px; margin-top: 20px;">
                        <a href="#" style="color: rgba(255,255,255,0.75); font-size: 1.35rem; transition: color 0.2s;"><i class="bi bi-facebook"></i></a>
                        <a href="#" style="color: rgba(255,255,255,0.75); font-size: 1.35rem; transition: color 0.2s;"><i class="bi bi-instagram"></i></a>
                        <a href="#" style="color: rgba(255,255,255,0.75); font-size: 1.35rem; transition: color 0.2s;"><i class="bi bi-twitter-x"></i></a>
                        <a href="#" style="color: rgba(255,255,255,0.75); font-size: 1.35rem; transition: color 0.2s;"><i class="bi bi-youtube"></i></a>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="col-lg-3 col-md-6">
                    <h5 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 20px; color: #fff;">Danh Mục</h5>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Trang Chủ</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/products" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Sản Phẩm</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/products?deals=true" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Ưu Đãi</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/about" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Giới Thiệu</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Liên Hệ</a></li>
                    </ul>
                </div>
                
                <!-- Customer Service -->
                <div class="col-lg-3 col-md-6">
                    <h5 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 20px; color: #fff;">Hỗ Trợ Khách Hàng</h5>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/page/warranty" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Chính Sách Bảo Hành</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/page/return-policy" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Chính Sách Đổi Trả</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/page/shopping-guide" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Hướng Dẫn Mua Hàng</a></li>
                        <li style="margin-bottom: 10px;"><a href="${pageContext.request.contextPath}/page/faq" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Câu Hỏi Thường Gặp</a></li>
                        <li><a href="${pageContext.request.contextPath}/page/terms" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.95rem; display: flex; align-items: center; gap: 6px;"><i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i> Điều Khoản Sử Dụng</a></li>
                    </ul>
                </div>
                
                <!-- Contact Info -->
                <div class="col-lg-3 col-md-6">
                    <h5 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 20px; color: #fff;">Liên Hệ</h5>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        <li style="margin-bottom: 16px; display: flex; align-items: flex-start; gap: 10px;">
                            <i class="bi bi-geo-alt-fill" style="color: #60a5fa; font-size: 1.1rem; margin-top: 2px;"></i>
                            <div>
                                <strong style="color: #fff; font-size: 0.9rem;">Địa chỉ:</strong><br>
                                <span style="color: rgba(255,255,255,0.75); font-size: 0.9rem;">123 Đường ABC, Quận 1, TP.HCM</span>
                            </div>
                        </li>
                        <li style="margin-bottom: 16px; display: flex; align-items: flex-start; gap: 10px;">
                            <i class="bi bi-telephone-fill" style="color: #60a5fa; font-size: 1.1rem; margin-top: 2px;"></i>
                            <div>
                                <strong style="color: #fff; font-size: 0.9rem;">Hotline:</strong><br>
                                <a href="tel:1900xxxx" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.9rem;">1900-xxxx</a>
                            </div>
                        </li>
                        <li style="display: flex; align-items: flex-start; gap: 10px;">
                            <i class="bi bi-envelope-fill" style="color: #60a5fa; font-size: 1.1rem; margin-top: 2px;"></i>
                            <div>
                                <strong style="color: #fff; font-size: 0.9rem;">Email:</strong><br>
                                <a href="mailto:support@mobilestore.com" style="color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.9rem;">support@mobilestore.com</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Newsletter Section -->
            <div style="margin-top: 20px; padding: 32px; background: rgba(255,255,255,0.06); border-radius: 12px; text-align: center; margin-bottom: 30px;">
                <h5 style="color: #fff; font-weight: 600; margin-bottom: 8px; font-size: 1.15rem;">Đăng Ký Nhận Tin Khuyến Mãi</h5>
                <p style="color: rgba(255,255,255,0.7); margin-bottom: 20px; font-size: 0.95rem;">Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt</p>
                <form style="max-width: 480px; margin: 0 auto; display: flex; gap: 10px;">
                    <input type="email" placeholder="Nhập email của bạn..." required
                           style="flex: 1; padding: 12px 16px; border-radius: 8px; border: none; font-size: 0.95rem; outline: none;">
                    <button type="submit" class="btn btn-primary" style="white-space: nowrap; padding: 12px 24px; border-radius: 8px; font-weight: 500;">Đăng Ký</button>
                </form>
            </div>
            
            <!-- Footer Bottom -->
            <div style="text-align: center; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.5); font-size: 0.9rem;">
                <p style="margin: 0;">&copy; 2026 Mobile Store. All Rights Reserved. | Designed with <i class="bi bi-heart-fill" style="color: #ea4335;"></i> by Mobile Store Team</p>
            </div>
        </div>
    </footer>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop" aria-label="Back to top">
        <i class="bi bi-arrow-up"></i>
    </button>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
