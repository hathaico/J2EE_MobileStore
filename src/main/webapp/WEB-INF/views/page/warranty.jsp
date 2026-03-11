<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<section style="padding: 48px 0 60px;">
    <div class="container" style="max-width: 900px;">

        <!-- Breadcrumb -->
        <nav style="margin-bottom: 28px;">
            <ol class="breadcrumb" style="font-size: 0.9rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color: #2563EB; text-decoration: none;">Trang Chủ</a></li>
                <li class="breadcrumb-item active" style="color: #6b7280;">Chính Sách Bảo Hành</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div style="text-align: center; margin-bottom: 48px;">
            <div style="width: 72px; height: 72px; background: #EFF6FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                <i class="bi bi-shield-check" style="font-size: 2rem; color: #2563EB;"></i>
            </div>
            <h1 style="font-size: 2.2rem; font-weight: 700; color: #1F2937; margin-bottom: 10px;">Chính Sách Bảo Hành</h1>
            <p style="color: #6b7280; font-size: 1.05rem;">Cam kết bảo hành chính hãng, tận tâm với khách hàng</p>
        </div>

        <!-- Content -->
        <div style="background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 4px 14px rgba(0,0,0,0.05); border: 1px solid #E5E7EB;">

            <!-- Section 1 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #2563EB; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">1</span>
                    Điều Kiện Bảo Hành
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sản phẩm được mua tại Mobile Store và còn trong thời hạn bảo hành.</li>
                    <li>Phiếu bảo hành hoặc hóa đơn mua hàng còn nguyên vẹn, không chỉnh sửa.</li>
                    <li>Tem bảo hành, seal (nếu có) trên sản phẩm còn nguyên, không bị rách hay tẩy xóa.</li>
                    <li>Sản phẩm bị lỗi kỹ thuật do nhà sản xuất (lỗi phần cứng, phần mềm gốc).</li>
                    <li>Số IMEI/Serial trên máy trùng khớp với phiếu bảo hành.</li>
                </ul>
            </div>

            <!-- Section 2 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #2563EB; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">2</span>
                    Thời Gian Bảo Hành
                </h2>
                <div class="table-responsive">
                    <table class="table" style="border: 1px solid #E5E7EB; border-radius: 8px; overflow: hidden; font-size: 0.95rem;">
                        <thead style="background: #F8FAFC;">
                            <tr>
                                <th style="padding: 14px 16px; color: #374151; font-weight: 600; border-bottom: 2px solid #E5E7EB;">Loại Sản Phẩm</th>
                                <th style="padding: 14px 16px; color: #374151; font-weight: 600; border-bottom: 2px solid #E5E7EB;">Thời Gian</th>
                                <th style="padding: 14px 16px; color: #374151; font-weight: 600; border-bottom: 2px solid #E5E7EB;">Hình Thức</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Điện thoại chính hãng</td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;"><strong style="color: #2563EB;">12 tháng</strong></td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Bảo hành hãng + Mobile Store</td>
                            </tr>
                            <tr>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Phụ kiện chính hãng</td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;"><strong style="color: #2563EB;">6 tháng</strong></td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Bảo hành Mobile Store</td>
                            </tr>
                            <tr>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Pin, sạc, cáp</td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;"><strong style="color: #2563EB;">6 tháng</strong></td>
                                <td style="padding: 12px 16px; border-bottom: 1px solid #F3F4F6;">Đổi mới</td>
                            </tr>
                            <tr>
                                <td style="padding: 12px 16px;">Tai nghe, ốp lưng</td>
                                <td style="padding: 12px 16px;"><strong style="color: #2563EB;">3 tháng</strong></td>
                                <td style="padding: 12px 16px;">Đổi mới</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Section 3 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #2563EB; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">3</span>
                    Trường Hợp Không Được Bảo Hành
                </h2>
                <ul style="color: #374151; line-height: 2; padding-left: 20px; font-size: 0.95rem;">
                    <li>Sản phẩm hết thời hạn bảo hành ghi trên phiếu.</li>
                    <li>Sản phẩm bị hư hỏng do tác động bên ngoài: rơi, va đập, vào nước, cháy nổ.</li>
                    <li>Sản phẩm đã bị sửa chữa, thay thế linh kiện bởi bên thứ ba không được ủy quyền.</li>
                    <li>Sản phẩm bị hư hỏng do sử dụng sai cách, không tuân thủ hướng dẫn sử dụng.</li>
                    <li>Tem bảo hành bị rách, mờ, hoặc không còn nguyên vẹn.</li>
                    <li>Hư hỏng do thiên tai, sét đánh, quá tải điện.</li>
                </ul>
            </div>

            <!-- Section 4 -->
            <div style="margin-bottom: 36px;">
                <h2 style="font-size: 1.4rem; font-weight: 600; color: #1F2937; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
                    <span style="width: 32px; height: 32px; background: #2563EB; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 700;">4</span>
                    Quy Trình Bảo Hành
                </h2>
                <div class="row g-3">
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #EFF6FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-1-circle-fill" style="font-size: 1.4rem; color: #2563EB;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Tiếp nhận</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Mang sản phẩm đến cửa hàng</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #EFF6FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-2-circle-fill" style="font-size: 1.4rem; color: #2563EB;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Kiểm tra</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Xác định lỗi và phương án</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #EFF6FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-3-circle-fill" style="font-size: 1.4rem; color: #2563EB;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Sửa chữa</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Xử lý trong 3-7 ngày</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div style="text-align: center; padding: 20px 12px; background: #F8FAFC; border-radius: 10px;">
                            <div style="width: 48px; height: 48px; background: #EFF6FF; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                <i class="bi bi-4-circle-fill" style="font-size: 1.4rem; color: #2563EB;"></i>
                            </div>
                            <div style="font-weight: 600; color: #1F2937; font-size: 0.9rem;">Trả máy</div>
                            <small style="color: #6b7280; font-size: 0.8rem;">Nhận lại sản phẩm</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Note -->
            <div style="background: #EFF6FF; border-radius: 10px; padding: 24px; border-left: 4px solid #2563EB;">
                <div style="display: flex; align-items: flex-start; gap: 12px;">
                    <i class="bi bi-info-circle-fill" style="color: #2563EB; font-size: 1.3rem; margin-top: 2px;"></i>
                    <div>
                        <strong style="color: #1F2937;">Cần hỗ trợ bảo hành?</strong>
                        <p style="color: #374151; margin: 6px 0 0; font-size: 0.95rem;">
                            Liên hệ hotline <strong style="color: #2563EB;">1900-xxxx</strong> hoặc mang sản phẩm đến trực tiếp cửa hàng Mobile Store gần nhất. Đội ngũ kỹ thuật sẵn sàng hỗ trợ bạn!
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
