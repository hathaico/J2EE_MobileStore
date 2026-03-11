<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section style="padding: 48px 0 60px;">
    <div class="container" style="max-width: 900px;">

        <!-- Breadcrumb -->
        <nav style="margin-bottom: 28px;">
            <ol class="breadcrumb" style="font-size: 0.9rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color: #2563EB; text-decoration: none;">Trang Chủ</a></li>
                <li class="breadcrumb-item active" style="color: #6b7280;">Điều Khoản Sử Dụng</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div style="text-align: center; margin-bottom: 48px;">
            <div style="width: 72px; height: 72px; background: #F3E8FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                <i class="bi bi-file-earmark-text" style="font-size: 2rem; color: #8b5cf6;"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 700; color: #1F2937; margin-bottom: 10px;">Điều Khoản Sử Dụng</h1>
            <p style="color: #6b7280; font-size: 1.05rem;">Cập nhật lần cuối: 01/03/2026</p>
        </div>

        <!-- Content -->
        <div style="background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">

            <!-- Introduction -->
            <div style="margin-bottom: 36px;">
                <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                    Chào mừng bạn đến với Mobile Store. Bằng việc truy cập và sử dụng website <strong>mobilestore.com</strong>, bạn đồng ý tuân thủ các điều khoản và điều kiện được quy định dưới đây. Vui lòng đọc kỹ trước khi sử dụng dịch vụ của chúng tôi.
                </p>
            </div>

            <!-- Section 1 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    1. Giới Thiệu Chung
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Mobile Store là hệ thống bán lẻ điện thoại di động và phụ kiện trực tuyến.</li>
                    <li>Website cung cấp thông tin sản phẩm, dịch vụ mua sắm, hỗ trợ sau bán hàng.</li>
                    <li>Các điều khoản này áp dụng cho tất cả người dùng website, bao gồm khách truy cập, người đăng ký tài khoản và người mua hàng.</li>
                </ul>
            </div>

            <!-- Section 2 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    2. Tài Khoản Người Dùng
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Bạn cần đăng ký tài khoản để thực hiện mua hàng và sử dụng các dịch vụ trên website.</li>
                    <li>Thông tin đăng ký phải chính xác, đầy đủ và cập nhật. Bạn chịu trách nhiệm cho tính xác thực của thông tin.</li>
                    <li>Bạn có trách nhiệm bảo mật thông tin tài khoản (mật khẩu, email) và chịu trách nhiệm cho mọi hoạt động phát sinh từ tài khoản của mình.</li>
                    <li>Mobile Store có quyền khóa hoặc xóa tài khoản nếu phát hiện hành vi vi phạm điều khoản sử dụng.</li>
                </ul>
            </div>

            <!-- Section 3 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    3. Đặt Hàng & Thanh Toán
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Khi đặt hàng, bạn xác nhận rằng thông tin người nhận, địa chỉ giao hàng là chính xác.</li>
                    <li>Giá sản phẩm được niêm yết trên website đã bao gồm thuế VAT (trừ khi có ghi chú khác).</li>
                    <li>Mobile Store có quyền từ chối hoặc hủy đơn hàng nếu phát hiện lỗi về giá, thông tin sản phẩm, hoặc hành vi gian lận.</li>
                    <li>Đơn hàng chỉ được xác nhận khi bạn nhận được email/SMS xác nhận từ hệ thống.</li>
                </ul>
            </div>

            <!-- Section 4 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    4. Thông Tin Sản Phẩm
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Chúng tôi nỗ lực cung cấp thông tin sản phẩm chính xác nhất, bao gồm hình ảnh, mô tả, thông số kỹ thuật và giá.</li>
                    <li>Tuy nhiên, có thể xảy ra sai sót do nhà sản xuất thay đổi thông số hoặc lỗi cập nhật. Mobile Store không chịu trách nhiệm cho những sai sót ngoài ý muốn.</li>
                    <li>Màu sắc sản phẩm hiển thị có thể khác biệt nhỏ so với thực tế do màn hình thiết bị.</li>
                </ul>
            </div>

            <!-- Section 5 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    5. Bảo Mật Thông Tin
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Mobile Store cam kết bảo mật thông tin cá nhân của khách hàng theo quy định pháp luật Việt Nam.</li>
                    <li>Thông tin cá nhân chỉ được sử dụng cho mục đích xử lý đơn hàng, giao hàng và chăm sóc khách hàng.</li>
                    <li>Chúng tôi không bán, trao đổi hoặc cho thuê thông tin cá nhân cho bên thứ ba nếu không có sự đồng ý của bạn.</li>
                    <li>Mật khẩu tài khoản được mã hóa và lưu trữ an toàn. Mobile Store không có khả năng xem mật khẩu gốc của bạn.</li>
                    <li>Bạn có quyền yêu cầu xóa tài khoản và toàn bộ dữ liệu cá nhân bất cứ lúc nào.</li>
                </ul>
            </div>

            <!-- Section 6 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    6. Quyền Sở Hữu Trí Tuệ
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Toàn bộ nội dung trên website (văn bản, hình ảnh, logo, giao diện) thuộc quyền sở hữu của Mobile Store hoặc được cấp phép hợp pháp.</li>
                    <li>Nghiêm cấm sao chép, phân phối, sửa đổi nội dung website mà không có sự đồng ý bằng văn bản.</li>
                    <li>Các thương hiệu sản phẩm (Apple, Samsung, Xiaomi...) thuộc quyền sở hữu của các công ty tương ứng.</li>
                </ul>
            </div>

            <!-- Section 7 -->
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    7. Hành Vi Bị Nghiêm Cấm
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sử dụng website cho mục đích bất hợp pháp hoặc gian lận.</li>
                    <li>Cung cấp thông tin sai lệch khi đăng ký hoặc đặt hàng.</li>
                    <li>Gây ảnh hưởng đến hoạt động và hiệu suất của website (tấn công DDoS, spam, v.v.).</li>
                    <li>Thu thập thông tin cá nhân của người dùng khác mà không có sự cho phép.</li>
                </ul>
            </div>

            <!-- Section 8 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 12px; padding-bottom: 10px; border-bottom: 2px solid #E5E7EB;">
                    8. Thay Đổi Điều Khoản
                </h2>
                <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                    Mobile Store có quyền cập nhật, sửa đổi các điều khoản sử dụng bất cứ lúc nào mà không cần thông báo trước. Việc bạn tiếp tục sử dụng website sau khi thay đổi đồng nghĩa với việc bạn chấp nhận điều khoản mới. Chúng tôi khuyến khích bạn kiểm tra trang này định kỳ.
                </p>
            </div>

            <!-- Contact Note -->
            <div style="background: #F3E8FF; border-radius: 10px; padding: 24px; border-left: 4px solid #8b5cf6;">
                <div style="display: flex; align-items: flex-start; gap: 12px;">
                    <i class="bi bi-info-circle-fill" style="color: #8b5cf6; font-size: 1.3rem; margin-top: 2px;"></i>
                    <div>
                        <strong style="color: #1F2937;">Có thắc mắc về điều khoản?</strong>
                        <p style="color: #374151; margin: 6px 0 0; font-size: 0.95rem;">
                            Liên hệ email <strong style="color: #8b5cf6;">legal@mobilestore.com</strong> hoặc hotline <strong>1900-xxxx</strong> để được giải đáp. Chúng tôi luôn sẵn sàng lắng nghe ý kiến của bạn.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
