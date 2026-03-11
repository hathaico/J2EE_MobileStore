<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section style="padding: 48px 0 60px;">
    <div class="container" style="max-width: 900px;">

        <!-- Breadcrumb -->
        <nav style="margin-bottom: 28px;">
            <ol class="breadcrumb" style="font-size: 0.9rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color: #2563EB; text-decoration: none;">Trang Chủ</a></li>
                <li class="breadcrumb-item active" style="color: #6b7280;">Hướng Dẫn Mua Hàng</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div style="text-align: center; margin-bottom: 48px;">
            <div style="width: 72px; height: 72px; background: #F0FDF4; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                <i class="bi bi-bag-check" style="font-size: 2rem; color: #10b981;"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 700; color: #1F2937; margin-bottom: 10px;">Hướng Dẫn Mua Hàng</h1>
            <p style="color: #6b7280; font-size: 1.05rem;">Mua sắm trực tuyến tại Mobile Store chỉ với vài bước đơn giản</p>
        </div>

        <!-- Content -->
        <div style="background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">

            <!-- Step 1 -->
            <div style="margin-bottom: 40px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">1</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Tìm Kiếm Sản Phẩm</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem; margin-bottom: 12px;">
                        Truy cập trang web Mobile Store và tìm sản phẩm bạn muốn mua bằng các cách:
                    </p>
                    <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                        <li><strong>Thanh tìm kiếm:</strong> Nhập tên sản phẩm, thương hiệu, hoặc mã sản phẩm.</li>
                        <li><strong>Danh mục:</strong> Duyệt theo thương hiệu (Apple, Samsung, Xiaomi...).</li>
                        <li><strong>Bộ lọc:</strong> Lọc theo giá, thương hiệu, đánh giá, tính năng.</li>
                    </ul>
                </div>
            </div>

            <!-- Step 2 -->
            <div style="margin-bottom: 40px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">2</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Xem Chi Tiết & Thêm Vào Giỏ Hàng</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                        Nhấn vào sản phẩm để xem thông tin chi tiết: hình ảnh, thông số kỹ thuật, đánh giá từ khách hàng khác. Khi đã quyết định, nhấn nút <strong style="color: #2563EB;">"Thêm Vào Giỏ"</strong> để đưa sản phẩm vào giỏ hàng. Bạn có thể tiếp tục mua thêm sản phẩm khác.
                    </p>
                </div>
            </div>

            <!-- Step 3 -->
            <div style="margin-bottom: 40px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">3</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Kiểm Tra Giỏ Hàng</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                        Nhấn vào biểu tượng <i class="bi bi-cart3" style="color: #2563EB;"></i> giỏ hàng ở góc trên bên phải để xem lại sản phẩm đã chọn. Tại đây bạn có thể:
                    </p>
                    <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                        <li>Thay đổi số lượng sản phẩm.</li>
                        <li>Xóa sản phẩm không mong muốn.</li>
                        <li>Xem tổng tiền đơn hàng.</li>
                        <li>Áp dụng mã giảm giá (nếu có).</li>
                    </ul>
                </div>
            </div>

            <!-- Step 4 -->
            <div style="margin-bottom: 40px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">4</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Đăng Nhập / Đăng Ký Tài Khoản</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                        Để tiến hành thanh toán, bạn cần đăng nhập vào tài khoản. Nếu chưa có tài khoản, nhấn <strong style="color: #2563EB;">"Đăng Ký"</strong> và điền thông tin: họ tên, email, số điện thoại và mật khẩu. Quá trình đăng ký chỉ mất khoảng 1 phút.
                    </p>
                </div>
            </div>

            <!-- Step 5 -->
            <div style="margin-bottom: 40px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">5</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Điền Thông Tin Giao Hàng & Thanh Toán</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem; margin-bottom: 12px;">
                        Nhấn <strong style="color: #2563EB;">"Thanh Toán"</strong> và điền đầy đủ thông tin:
                    </p>
                    <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                        <li><strong>Thông tin người nhận:</strong> Họ tên, số điện thoại.</li>
                        <li><strong>Địa chỉ giao hàng:</strong> Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành.</li>
                        <li><strong>Phương thức thanh toán:</strong> Thanh toán khi nhận hàng (COD) hoặc chuyển khoản ngân hàng.</li>
                        <li><strong>Ghi chú:</strong> Yêu cầu đặc biệt (nếu có).</li>
                    </ul>
                </div>
            </div>

            <!-- Step 6 -->
            <div style="margin-bottom: 36px; display: flex; gap: 20px;">
                <div style="flex-shrink: 0;">
                    <div style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #059669); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.4rem; font-weight: 700;">6</div>
                </div>
                <div style="flex: 1;">
                    <h2 style="font-size: 1.3rem; font-weight: 600; color: #1F2937; margin-bottom: 10px;">Xác Nhận & Nhận Hàng</h2>
                    <p style="color: #374151; line-height: 1.8; font-size: 0.95rem;">
                        Kiểm tra lại đơn hàng và nhấn <strong style="color: #10b981;">"Đặt Hàng"</strong>. Bạn sẽ nhận được email xác nhận đơn hàng. Đơn hàng sẽ được giao trong vòng <strong>1-3 ngày</strong> (nội thành) hoặc <strong>3-5 ngày</strong> (ngoại thành, tỉnh). Khi nhận hàng, hãy kiểm tra sản phẩm trước khi ký nhận.
                    </p>
                </div>
            </div>

            <!-- Payment Methods -->
            <div style="margin-bottom: 36px; padding: 28px; background: #F8FAFC; border-radius: 10px;">
                <h3 style="font-size: 1.2rem; font-weight: 600; color: #1F2937; margin-bottom: 16px;">
                    <i class="bi bi-credit-card" style="color: #10b981; margin-right: 8px;"></i>Phương Thức Thanh Toán
                </h3>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #fff; border-radius: 8px; border: 1px solid #E5E7EB;">
                            <i class="bi bi-cash-coin" style="font-size: 1.5rem; color: #10b981;"></i>
                            <div>
                                <strong style="font-size: 0.9rem; color: #1F2937;">Thanh toán khi nhận hàng (COD)</strong>
                                <div style="font-size: 0.8rem; color: #6b7280;">Trả tiền mặt khi shipper giao hàng</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #fff; border-radius: 8px; border: 1px solid #E5E7EB;">
                            <i class="bi bi-bank" style="font-size: 1.5rem; color: #2563EB;"></i>
                            <div>
                                <strong style="font-size: 0.9rem; color: #1F2937;">Chuyển khoản ngân hàng</strong>
                                <div style="font-size: 0.8rem; color: #6b7280;">Thanh toán trước qua tài khoản ngân hàng</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Note -->
            <div style="background: #F0FDF4; border-radius: 10px; padding: 24px; border-left: 4px solid #10b981;">
                <div style="display: flex; align-items: flex-start; gap: 12px;">
                    <i class="bi bi-headset" style="color: #10b981; font-size: 1.3rem; margin-top: 2px;"></i>
                    <div>
                        <strong style="color: #1F2937;">Cần hỗ trợ mua hàng?</strong>
                        <p style="color: #374151; margin: 6px 0 0; font-size: 0.95rem;">
                            Gọi ngay hotline <strong style="color: #10b981;">1900-xxxx</strong> (8h - 21h hàng ngày) để được tư vấn miễn phí. Đội ngũ tư vấn viên luôn sẵn sàng hỗ trợ bạn!
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
