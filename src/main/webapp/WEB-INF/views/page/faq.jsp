<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section style="padding: 48px 0 60px;">
    <div class="container" style="max-width: 900px;">

        <!-- Breadcrumb -->
        <nav style="margin-bottom: 28px;">
            <ol class="breadcrumb" style="font-size: 0.9rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color: #2563EB; text-decoration: none;">Trang Chủ</a></li>
                <li class="breadcrumb-item active" style="color: #6b7280;">Câu Hỏi Thường Gặp</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div style="text-align: center; margin-bottom: 48px;">
            <div style="width: 72px; height: 72px; background: #FFFBEB; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                <i class="bi bi-question-circle" style="font-size: 2rem; color: #f59e0b;"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 700; color: #1F2937; margin-bottom: 10px;">Câu Hỏi Thường Gặp</h1>
            <p style="color: #6b7280; font-size: 1.05rem;">Giải đáp nhanh những thắc mắc phổ biến của khách hàng</p>
        </div>

        <!-- Content -->
        <div style="background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">

            <!-- Category: Đặt Hàng & Thanh Toán -->
            <h2 style="font-size: 1.25rem; font-weight: 600; color: #2563EB; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <i class="bi bi-cart-check"></i> Đặt Hàng & Thanh Toán
            </h2>

            <div class="accordion" id="faqOrdering" style="margin-bottom: 32px;">
                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Làm thế nào để đặt hàng tại Mobile Store?
                        </button>
                    </h3>
                    <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqOrdering">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Bạn chỉ cần chọn sản phẩm, thêm vào giỏ hàng, điền thông tin giao hàng và xác nhận đơn hàng. Chi tiết vui lòng xem 
                            <a href="${pageContext.request.contextPath}/page/shopping-guide" style="color: #2563EB;">Hướng Dẫn Mua Hàng</a>.
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Mobile Store hỗ trợ những phương thức thanh toán nào?
                        </button>
                    </h3>
                    <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqOrdering">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Hiện tại chúng tôi hỗ trợ 2 phương thức thanh toán:
                            <ul style="margin-top: 8px;">
                                <li><strong>Thanh toán khi nhận hàng (COD):</strong> Trả tiền mặt cho shipper.</li>
                                <li><strong>Chuyển khoản ngân hàng:</strong> Thanh toán trước qua tài khoản ngân hàng của Mobile Store.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Tôi có thể hủy đơn hàng sau khi đặt không?
                        </button>
                    </h3>
                    <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqOrdering">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Bạn có thể hủy đơn hàng khi đơn chưa được giao cho đơn vị vận chuyển. Hãy liên hệ hotline <strong>1900-xxxx</strong> hoặc vào mục "Đơn hàng của tôi" để yêu cầu hủy. Nếu đã thanh toán trước, tiền sẽ được hoàn lại trong 3-5 ngày làm việc.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Category: Vận Chuyển -->
            <h2 style="font-size: 1.25rem; font-weight: 600; color: #2563EB; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <i class="bi bi-truck"></i> Vận Chuyển & Giao Hàng
            </h2>

            <div class="accordion" id="faqShipping" style="margin-bottom: 32px;">
                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq4" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Thời gian giao hàng là bao lâu?
                        </button>
                    </h3>
                    <div id="faq4" class="accordion-collapse collapse" data-bs-parent="#faqShipping">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            <ul>
                                <li><strong>Nội thành TP.HCM, Hà Nội:</strong> 1-2 ngày làm việc.</li>
                                <li><strong>Các tỉnh thành khác:</strong> 3-5 ngày làm việc.</li>
                                <li><strong>Vùng sâu, vùng xa:</strong> 5-7 ngày làm việc.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq5" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Phí vận chuyển là bao nhiêu?
                        </button>
                    </h3>
                    <div id="faq5" class="accordion-collapse collapse" data-bs-parent="#faqShipping">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Mobile Store <strong style="color: #10b981;">MIỄN PHÍ vận chuyển</strong> cho tất cả đơn hàng điện thoại trên toàn quốc. Đối với phụ kiện, miễn phí vận chuyển cho đơn từ 500.000₫ trở lên.
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq6" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Tôi có thể theo dõi đơn hàng không?
                        </button>
                    </h3>
                    <div id="faq6" class="accordion-collapse collapse" data-bs-parent="#faqShipping">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Có. Sau khi đơn hàng được giao cho đơn vị vận chuyển, bạn sẽ nhận được mã vận đơn qua email/SMS. Bạn cũng có thể theo dõi trạng thái đơn hàng trong mục "Đơn hàng của tôi" sau khi đăng nhập.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Category: Bảo Hành & Đổi Trả -->
            <h2 style="font-size: 1.25rem; font-weight: 600; color: #2563EB; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <i class="bi bi-shield-check"></i> Bảo Hành & Đổi Trả
            </h2>

            <div class="accordion" id="faqWarranty" style="margin-bottom: 32px;">
                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq7" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Sản phẩm tại Mobile Store có được bảo hành không?
                        </button>
                    </h3>
                    <div id="faq7" class="accordion-collapse collapse" data-bs-parent="#faqWarranty">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Tất cả sản phẩm tại Mobile Store đều là hàng chính hãng và được bảo hành theo chính sách của nhà sản xuất. Điện thoại được bảo hành <strong>12 tháng</strong>, phụ kiện <strong>3-6 tháng</strong>. Chi tiết xem tại 
                            <a href="${pageContext.request.contextPath}/page/warranty" style="color: #2563EB;">Chính Sách Bảo Hành</a>.
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq8" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Tôi muốn đổi sản phẩm thì làm thế nào?
                        </button>
                    </h3>
                    <div id="faq8" class="accordion-collapse collapse" data-bs-parent="#faqWarranty">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Trong vòng 7 ngày kể từ ngày nhận hàng, bạn có thể đổi sản phẩm nếu sản phẩm bị lỗi hoặc giao sai. Liên hệ hotline <strong>1900-xxxx</strong> và chuẩn bị hóa đơn mua hàng. Xem thêm tại 
                            <a href="${pageContext.request.contextPath}/page/return-policy" style="color: #2563EB;">Chính Sách Đổi Trả</a>.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Category: Tài Khoản -->
            <h2 style="font-size: 1.25rem; font-weight: 600; color: #2563EB; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <i class="bi bi-person-circle"></i> Tài Khoản & Bảo Mật
            </h2>

            <div class="accordion" id="faqAccount">
                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq9" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Tôi quên mật khẩu thì phải làm sao?
                        </button>
                    </h3>
                    <div id="faq9" class="accordion-collapse collapse" data-bs-parent="#faqAccount">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Tại trang đăng nhập, nhấn vào "Quên mật khẩu". Nhập email đã đăng ký, hệ thống sẽ gửi link đặt lại mật khẩu. Nếu vẫn gặp khó khăn, hãy liên hệ hotline <strong>1900-xxxx</strong>.
                        </div>
                    </div>
                </div>

                <div class="accordion-item" style="border: 1px solid #E5E7EB; border-radius: 8px; margin-bottom: 10px; overflow: hidden;">
                    <h3 class="accordion-header">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq10" style="font-weight: 600; font-size: 0.95rem; color: #1F2937;">
                            Thông tin cá nhân của tôi có được bảo mật không?
                        </button>
                    </h3>
                    <div id="faq10" class="accordion-collapse collapse" data-bs-parent="#faqAccount">
                        <div class="accordion-body" style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                            Mobile Store cam kết bảo mật tuyệt đối thông tin cá nhân của khách hàng. Chúng tôi sử dụng mã hóa dữ liệu và không chia sẻ thông tin với bên thứ ba nếu không có sự đồng ý của bạn. Chi tiết xem tại 
                            <a href="${pageContext.request.contextPath}/page/terms" style="color: #2563EB;">Điều Khoản Sử Dụng</a>.
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Still need help -->
        <div style="text-align: center; margin-top: 40px; padding: 36px; background: #fff; border-radius: 12px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">
            <i class="bi bi-headset" style="font-size: 2.5rem; color: #2563EB; display: block; margin-bottom: 12px;"></i>
            <h3 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 8px;">Vẫn Cần Hỗ Trợ?</h3>
            <p style="color: #6b7280; margin-bottom: 20px; font-size: 0.95rem;">Liên hệ đội ngũ chăm sóc khách hàng của chúng tôi</p>
            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <a href="tel:1900xxxx" style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: #2563EB; color: #fff; border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 0.95rem;">
                    <i class="bi bi-telephone"></i> 1900-xxxx
                </a>
                <a href="mailto:support@mobilestore.com" style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; border: 2px solid #2563EB; color: #2563EB; border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 0.95rem;">
                    <i class="bi bi-envelope"></i> Email Hỗ Trợ
                </a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
