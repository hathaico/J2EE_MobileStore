<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section style="padding: 48px 0 60px;">
    <div class="container" style="max-width: 900px;">

        <!-- Breadcrumb -->
        <nav style="margin-bottom: 28px;">
            <ol class="breadcrumb" style="font-size: 0.9rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color: #2563EB; text-decoration: none;">Trang Chủ</a></li>
                <li class="breadcrumb-item active" style="color: #6b7280;">Chính Sách Đổi Trả</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div style="text-align: center; margin-bottom: 48px;">
            <div style="width: 72px; height: 72px; background: #FEF2F2; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                <i class="bi bi-arrow-repeat" style="font-size: 2rem; color: #EF4444;"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 700; color: #1F2937; margin-bottom: 10px;">Chính Sách Đổi Trả</h1>
            <p style="color: #6b7280; font-size: 1.05rem;">Đổi trả dễ dàng, an tâm mua sắm tại Mobile Store</p>
        </div>

        <!-- Content -->
        <div style="background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">

            <!-- Highlight Box -->
            <div class="row g-3" style="margin-bottom: 36px;">
                <div class="col-md-4">
                    <div style="text-align: center; padding: 24px 16px; background: #FEF2F2; border-radius: 10px;">
                        <i class="bi bi-arrow-left-right" style="font-size: 2rem; color: #EF4444; display: block; margin-bottom: 8px;"></i>
                        <strong style="color: #1F2937; font-size: 1rem;">Đổi hàng</strong>
                        <div style="color: #6b7280; font-size: 0.85rem; margin-top: 4px;">Trong vòng 7 ngày</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div style="text-align: center; padding: 24px 16px; background: #F0FDF4; border-radius: 10px;">
                        <i class="bi bi-cash-stack" style="font-size: 2rem; color: #10b981; display: block; margin-bottom: 8px;"></i>
                        <strong style="color: #1F2937; font-size: 1rem;">Hoàn tiền</strong>
                        <div style="color: #6b7280; font-size: 0.85rem; margin-top: 4px;">Trong vòng 3 ngày</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div style="text-align: center; padding: 24px 16px; background: #EFF6FF; border-radius: 10px;">
                        <i class="bi bi-truck" style="font-size: 2rem; color: #2563EB; display: block; margin-bottom: 8px;"></i>
                        <strong style="color: #1F2937; font-size: 1rem;">Miễn phí vận chuyển</strong>
                        <div style="color: #6b7280; font-size: 0.85rem; margin-top: 4px;">Cho đơn đổi trả</div>
                    </div>
                </div>
            </div>

            <!-- Section 1 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #EF4444; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">1</span>
                    Chính Sách Đổi Sản Phẩm (7 ngày)
                </h2>
                <p style="color: #374151; line-height: 1.8; font-size: 0.95rem; margin-bottom: 12px;">
                    Trong vòng <strong>7 ngày</strong> kể từ ngày nhận hàng, quý khách được đổi sang sản phẩm cùng loại hoặc sản phẩm khác có giá trị tương đương/cao hơn (bù thêm chênh lệch) khi:
                </p>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sản phẩm bị lỗi kỹ thuật do nhà sản xuất.</li>
                    <li>Sản phẩm không đúng model, màu sắc, cấu hình như đơn hàng.</li>
                    <li>Sản phẩm còn nguyên hộp, đầy đủ phụ kiện, tem niêm phong.</li>
                    <li>Sản phẩm chưa kích hoạt bảo hành điện tử (với Apple).</li>
                </ul>
            </div>

            <!-- Section 2 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #EF4444; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">2</span>
                    Chính Sách Hoàn Tiền (3 ngày)
                </h2>
                <p style="color: #374151; line-height: 1.8; font-size: 0.95rem; margin-bottom: 12px;">
                    Trong vòng <strong>3 ngày</strong> kể từ ngày nhận hàng, quý khách được hoàn tiền 100% khi:
                </p>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sản phẩm bị lỗi nặng do nhà sản xuất, không thể sửa chữa hoặc đổi mới.</li>
                    <li>Sản phẩm giao sai hoàn toàn so với đơn đặt hàng.</li>
                    <li>Sản phẩm còn nguyên seal, chưa qua sử dụng.</li>
                </ul>
                <p style="color: #374151; font-size: 0.95rem;">
                    <strong>Hình thức hoàn tiền:</strong> Chuyển khoản ngân hàng trong vòng 3-5 ngày làm việc sau khi tiếp nhận yêu cầu.
                </p>
            </div>

            <!-- Section 3 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #EF4444; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">3</span>
                    Trường Hợp Không Áp Dụng Đổi Trả
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sản phẩm đã quá thời hạn đổi trả (7 ngày).</li>
                    <li>Sản phẩm bị hư hỏng vật lý do người dùng: rơi, vỡ, vào nước, cong vênh.</li>
                    <li>Sản phẩm đã bị root, jailbreak hoặc cài đặt phần mềm không chính thức.</li>
                    <li>Phụ kiện khuyến mãi đi kèm không đầy đủ hoặc bị hư hỏng.</li>
                    <li>Sản phẩm mua trong chương trình Flash Sale, Clearance (trừ lỗi do nhà sản xuất).</li>
                </ul>
            </div>

            <!-- Section 4 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #EF4444; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">4</span>
                    Quy Trình Đổi Trả
                </h2>
                <div class="row g-3">
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #FEF2F2; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-1-circle-fill" style="font-size: 1.4rem; color: #EF4444;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Liên hệ</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Gọi hotline hoặc chat</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #FEF2F2; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-2-circle-fill" style="font-size: 1.4rem; color: #EF4444;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Gửi hàng</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Mang đến CH hoặc gửi bưu điện</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #FEF2F2; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-3-circle-fill" style="font-size: 1.4rem; color: #EF4444;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Kiểm tra</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Xác nhận tình trạng SP</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #FEF2F2; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-4-circle-fill" style="font-size: 1.4rem; color: #EF4444;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Hoàn tất</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Đổi mới hoặc hoàn tiền</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Note -->
            <div style="background: #FEF2F2; border-radius: 10px; padding: 24px; border-left: 4px solid #EF4444;">
                <div style="display: flex; align-items: flex-start; gap: 12px;">
                    <i class="bi bi-info-circle-fill" style="color: #EF4444; font-size: 1.3rem; margin-top: 2px;"></i>
                    <div>
                        <strong style="color: #1F2937;">Yêu cầu đổi trả?</strong>
                        <p style="color: #374151; margin: 6px 0 0; font-size: 0.95rem;">
                            Liên hệ hotline <strong style="color: #EF4444;">1900-xxxx</strong> hoặc email <strong>support@mobilestore.com</strong> để được hỗ trợ nhanh nhất. Vui lòng chuẩn bị hóa đơn và hình ảnh sản phẩm.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
