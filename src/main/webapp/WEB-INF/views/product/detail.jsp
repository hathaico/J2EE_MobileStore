<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mobilestore.util.ProductColorUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="ms" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="${product.productName} - Mobile Store" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="margin-top: 2rem; margin-bottom: 4rem;">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" style="margin-bottom: 2rem;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Sản Phẩm</a></li>
            <li class="breadcrumb-item active">${product.productName}</li>
        </ol>
    </nav>

    <div class="row" style="margin-bottom: 4rem;">
        <!-- Product Gallery -->
        <div class="col-lg-6 mb-4">
            <div style="position: sticky; top: 100px;">
                <!-- Main Image -->
                <div class="product-detail-gallery">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <div class="product-detail-gallery__frame">
                                <img src="<ms:productImageSrc url="${product.imageUrl}" />"
                                     alt="${product.productName}">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="product-detail-gallery__frame product-detail-gallery__frame--empty">
                                <i class="bi bi-phone"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Trust Badges -->
                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem;">
                    <div style="background: white; padding: 1rem; border-radius: 12px; text-align: center; box-shadow: var(--shadow-sm);">
                        <i class="bi bi-shield-check" style="font-size: 2rem; color: var(--primary-color); margin-bottom: 0.5rem;"></i>
                        <div style="font-size: 0.875rem; font-weight: 600;">Bảo hành 12 tháng</div>
                    </div>
                    <div style="background: white; padding: 1rem; border-radius: 12px; text-align: center; box-shadow: var(--shadow-sm);">
                        <i class="bi bi-arrow-repeat" style="font-size: 2rem; color: var(--primary-color); margin-bottom: 0.5rem;"></i>
                        <div style="font-size: 0.875rem; font-weight: 600;">Đổi trả 7 ngày</div>
                    </div>
                    <div style="background: white; padding: 1rem; border-radius: 12px; text-align: center; box-shadow: var(--shadow-sm);">
                        <i class="bi bi-truck" style="font-size: 2rem; color: var(--primary-color); margin-bottom: 0.5rem;"></i>
                        <div style="font-size: 0.875rem; font-weight: 600;">Miễn phí vận chuyển</div>
                    </div>
                    <div style="background: white; padding: 1rem; border-radius: 12px; text-align: center; box-shadow: var(--shadow-sm);">
                        <i class="bi bi-credit-card" style="font-size: 2rem; color: var(--primary-color); margin-bottom: 0.5rem;"></i>
                        <div style="font-size: 0.875rem; font-weight: 600;">Trả góp 0%</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Info -->
        <div class="col-lg-6">
            <div style="background: white; border-radius: 16px; padding: 2.5rem; box-shadow: var(--shadow-md);">
                <!-- Brand -->
                <div style="color: var(--gray-600); font-size: 0.875rem; font-weight: 600; 
                            text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem;">
                    ${product.brand}
                    <c:if test="${not empty product.model}">
                        · ${product.model}
                    </c:if>
                </div>
                
                <!-- Product Title -->
                <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 1rem; line-height: 1.2;">
                    ${product.productName}
                </h1>

                <!-- Rating & Reviews -->
                <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem; 
                            padding-bottom: 1.5rem; border-bottom: 1px solid var(--gray-200);">
                    <div style="display: flex; align-items: center; gap: 0.25rem;">
                        <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 1.2rem;"></i>
                        <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 1.2rem;"></i>
                        <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 1.2rem;"></i>
                        <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 1.2rem;"></i>
                        <i class="bi bi-star-half" style="color: var(--warning-color); font-size: 1.2rem;"></i>
                        <span style="margin-left: 0.5rem; font-weight: 600;">4.5</span>
                    </div>
                    <div style="color: var(--gray-600);">
                        <i class="bi bi-chat-dots"></i> 128 đánh giá
                    </div>
                    <div style="color: var(--gray-600);">
                        <i class="bi bi-bag-check"></i> 856 đã bán
                    </div>
                </div>

                <!-- Price -->
                <div style="margin-bottom: 2rem;">
                    <div style="font-size: 2.5rem; font-weight: 700; color: var(--primary-color); margin-bottom: 0.5rem;">
                        <fmt:formatNumber value="${product.price}" pattern="#,##0₫"/>
                    </div>
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <!-- Stock Status -->
                        <c:choose>
                            <c:when test="${product.stockQuantity == 0}">
                                <span style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; 
                                              background: var(--gray-100); color: var(--gray-700); border-radius: 8px; 
                                              font-weight: 600; font-size: 0.875rem;">
                                    <i class="bi bi-x-circle"></i> Hết hàng
                                </span>
                            </c:when>
                            <c:when test="${product.stockQuantity < 10}">
                                <span style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; 
                                              background: rgba(255, 193, 7, 0.1); color: var(--warning-color); border-radius: 8px; 
                                              font-weight: 600; font-size: 0.875rem;">
                                    <i class="bi bi-exclamation-triangle"></i> Chỉ còn ${product.stockQuantity} sản phẩm
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; 
                                              background: rgba(34, 197, 94, 0.1); color: var(--success-color); border-radius: 8px; 
                                              font-weight: 600; font-size: 0.875rem;">
                                    <i class="bi bi-check-circle"></i> Còn hàng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Color Selection -->
                <div style="margin-bottom: 2rem;">
                    <div style="font-weight: 600; margin-bottom: 0.75rem;">Màu sắc:</div>
                    <c:choose>
                        <c:when test="${not empty product.color}">
                            <%
                                com.mobilestore.model.Product productModel = (com.mobilestore.model.Product) request.getAttribute("product");
                                java.util.List<String> colors = ProductColorUtil.splitColors(productModel != null ? productModel.getColor() : null);
                            %>
                            <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
                                <%
                                    for (String colorLabel : colors) {
                                        String cssColor = ProductColorUtil.resolveCssColor(colorLabel);
                                        boolean unknownColor = "transparent".equals(cssColor);
                                %>
                                    <button type="button" class="product-color-option product-option-btn" data-option-group="color" data-option-value="<%= colorLabel %>" title="<%= colorLabel %>">
                                        <div class="product-color-swatch" style="background: <%= cssColor %>; border: <%= unknownColor ? "1px solid #D1D5DB" : "1px solid rgba(0, 0, 0, 0.08)" %>;"></div>
                                        <div class="product-color-name"><%= colorLabel %></div>
                                    </button>
                                <%
                                    }
                                %>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="color: var(--gray-500);">Chưa có thông tin màu sắc</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Storage Selection -->
                <div style="margin-bottom: 2rem;">
                    <div style="font-weight: 600; margin-bottom: 0.75rem;">Dung lượng:</div>
                    <c:choose>
                        <c:when test="${not empty product.capacity}">
                            <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                                <%
                                    com.mobilestore.model.Product capacityProduct = (com.mobilestore.model.Product) request.getAttribute("product");
                                    String capacityRaw = capacityProduct != null ? capacityProduct.getCapacity() : null;
                                    if (capacityRaw != null) {
                                        String[] capacities = capacityRaw.split(",");
                                        for (String capacityLabelRaw : capacities) {
                                            String capacityLabel = capacityLabelRaw != null ? capacityLabelRaw.trim() : "";
                                            if (!capacityLabel.isEmpty()) {
                                %>
                                    <button type="button" class="product-option-btn" data-option-group="capacity" data-option-value="<%= capacityLabel %>" style="min-width: 90px; padding: 0.85rem 1rem; border-radius: 14px; border: 1px solid #E5E7EB; background: #F8FAFC; display: inline-flex; align-items: center; justify-content: center; font-weight: 600; color: #111827;">
                                        <%= capacityLabel %>
                                    </button>
                                <%
                                            }
                                        }
                                    }
                                %>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="color: var(--gray-500);">Chưa có thông tin dung lượng</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Quantity Selector -->
                <c:if test="${product.stockQuantity > 0}">
                    <div style="margin-bottom: 2rem;">
                        <div style="font-weight: 600; margin-bottom: 0.75rem;">Số lượng:</div>
                        <div style="display: flex; align-items: center; gap: 0.5rem; width: fit-content;">
                            <button onclick="decrementQuantity()" 
                                    style="width: 40px; height: 40px; border-radius: 8px; border: 1px solid var(--gray-300); 
                                           background: white; cursor: pointer; display: flex; align-items: center; 
                                           justify-content: center; transition: var(--transition-base);"
                                    onmouseover="this.style.background='var(--gray-100)'"
                                    onmouseout="this.style.background='white'">
                                <i class="bi bi-dash"></i>
                            </button>
                            <input type="number" id="quantity" value="1" min="1" max="${product.stockQuantity}" class="quantity-input"
                                style="width: 80px; height: 40px; text-align: center; padding: 0; line-height: 40px; 
                                    border: 1px solid var(--gray-300); border-radius: 8px; font-weight: 600; 
                                    font-size: 1rem; appearance: textfield; -moz-appearance: textfield;">
                            <button id="btn-increment" data-max-qty="${product.stockQuantity}"
                                    style="width: 40px; height: 40px; border-radius: 8px; border: 1px solid var(--gray-300); 
                                           background: white; cursor: pointer; display: flex; align-items: center; 
                                           justify-content: center; transition: var(--transition-base);">
                                <i class="bi bi-plus"></i>
                            </button>
                        </div>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div style="display: flex; gap: 1rem; margin-bottom: 2rem;">
                    <c:choose>
                        <c:when test="${product.stockQuantity > 0}">
                            <input type="hidden" id="selected-color" value="">
                            <input type="hidden" id="selected-capacity" value="">
                            <button id="btn-add-to-cart" data-product-id="${product.productId}" 
                                    class="btn btn-primary" 
                                    style="flex: 1; height: 56px; font-size: 1.1rem; font-weight: 600;">
                                <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ
                            </button>
                            <button id="btn-buy-now" data-product-id="${product.productId}" class="btn btn-success" 
                                    style="flex: 1; height: 56px; font-size: 1.1rem; font-weight: 600;">
                                <i class="bi bi-bag-check"></i> Mua Ngay
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-outline" disabled style="flex: 1; height: 56px; font-size: 1.1rem;">
                                <i class="bi bi-x-circle"></i> Hết Hàng
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Additional Actions -->
                <div style="display: flex; gap: 1rem; padding-top: 1.5rem; border-top: 1px solid var(--gray-200);">
                    <button class="btn btn-outline" style="flex: 1;">
                        <i class="bi bi-heart"></i> Yêu thích
                    </button>
                    <button class="btn btn-outline" style="flex: 1;">
                        <i class="bi bi-share"></i> Chia sẻ
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Product Details Tabs -->
    <div style="margin-bottom: 4rem;">
        <ul class="nav nav-tabs" style="border-bottom: 2px solid var(--gray-200);">
            <li class="nav-item">
                <a class="nav-link active" data-bs-toggle="tab" href="#specs" 
                   style="font-weight: 600; padding: 1rem 1.5rem;">
                    <i class="bi bi-list-check"></i> Thông số kỹ thuật
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#reviews" 
                   style="font-weight: 600; padding: 1rem 1.5rem;">
                    <i class="bi bi-star"></i> Đánh giá (128)
                </a>
            </li>
        </ul>

        <div class="tab-content" style="background: white; padding: 2rem; border-radius: 0 0 12px 12px; box-shadow: var(--shadow-md);">
            <!-- Specifications Tab -->
            <div class="tab-pane fade show active" id="specs">
                <div style="max-width: 900px; margin: 0 auto;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                        <h4 style="margin: 0; font-size: 1.8rem; font-weight: 700; color: #1F2937;">Thông số kỹ thuật</h4>
                        <a href="#reviews" data-bs-toggle="tab" class="nav-link" style="padding: 0; color: #2563EB; font-weight: 600; font-size: 0.95rem;">
                            Xem tất cả <i class="bi bi-chevron-right" style="font-size: 0.85rem;"></i>
                        </a>
                    </div>

                    <div style="border: 1px solid #D1D5DB; border-radius: 12px; overflow: hidden; background: #FFFFFF;">
                        <table style="width: 100%; border-collapse: collapse; font-size: 1.02rem; color: #374151;">
                            <tbody>
                                <tr>
                                    <th style="width: 31%; padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">Thương hiệu</th>
                                    <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB;">${product.brand}</td>
                                </tr>
                                <c:if test="${not empty product.model}">
                                    <tr>
                                        <th style="padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">Model</th>
                                        <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB;">${product.model}</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty product.categoryName}">
                                    <tr>
                                        <th style="padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">Danh mục</th>
                                        <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB;">${product.categoryName}</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty product.color}">
                                    <tr>
                                        <th style="padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">Màu sắc</th>
                                        <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB;">${product.color}</td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <th style="padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">Dung lượng trong</th>
                                    <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB;"><c:choose><c:when test="${not empty product.capacity}">${product.capacity}</c:when><c:otherwise>Chưa có dữ liệu</c:otherwise></c:choose></td>
                                </tr>
                                <c:if test="${not empty product.description}">
                                    <c:set var="normalizedDescription" value="${fn:replace(product.description, '&#13;', '')}" />
                                    <c:set var="specLines" value="${fn:split(normalizedDescription, '&#10;')}" />
                                    <c:forEach var="lineRaw" items="${specLines}">
                                        <c:set var="line" value="${fn:trim(lineRaw)}" />
                                        <c:if test="${not empty line}">
                                            <c:set var="colonIndex" value="${fn:indexOf(line, ':')}" />
                                            <c:if test="${colonIndex gt 0}">
                                                <c:set var="specName" value="${fn:trim(fn:substring(line, 0, colonIndex))}" />
                                                <c:set var="specValue" value="${fn:trim(fn:substring(line, colonIndex + 1, fn:length(line)))}" />
                                                <c:if test="${not empty specName and not empty specValue}">
                                                    <tr>
                                                        <th style="padding: 10px 14px; background: #F3F4F6; border-right: 1px solid #D1D5DB; border-bottom: 1px solid #D1D5DB; font-weight: 500; text-align: left;">${specName}</th>
                                                        <td style="padding: 10px 14px; border-bottom: 1px solid #D1D5DB; line-height: 1.45;">${specValue}</td>
                                                    </tr>
                                                </c:if>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Reviews Tab -->
            <div class="tab-pane fade" id="reviews">
                <div id="review-summary" style="margin-bottom: 2rem; padding: 2rem; background: var(--gray-50); border-radius: 12px;">
                    <div style="display: flex; align-items: center; gap: 2rem; margin-bottom: 1rem;">
                        <div style="text-align: center;">
                            <div id="avg-rating" style="font-size: 3rem; font-weight: 700; color: var(--primary-color);">...</div>
                            <div id="avg-stars" style="display: flex; gap: 0.25rem; justify-content: center; margin-bottom: 0.5rem;"></div>
                            <div id="review-count" style="color: var(--gray-600);">...</div>
                        </div>
                        <div style="flex: 1;">
                            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 0.5rem;">
                                <span>5★</span>
                                <div style="flex: 1; height: 8px; background: var(--gray-200); border-radius: 4px; overflow: hidden;">
                                    <div style="width: 75%; height: 100%; background: var(--warning-color);"></div>
                                </div>
                                <span style="color: var(--gray-600);">96</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 0.5rem;">
                                <span>4★</span>
                                <div style="flex: 1; height: 8px; background: var(--gray-200); border-radius: 4px; overflow: hidden;">
                                    <div style="width: 20%; height: 100%; background: var(--warning-color);"></div>
                                </div>
                                <span style="color: var(--gray-600);">25</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 0.5rem;">
                                <span>3★</span>
                                <div style="flex: 1; height: 8px; background: var(--gray-200); border-radius: 4px; overflow: hidden;">
                                    <div style="width: 5%; height: 100%; background: var(--warning-color);"></div>
                                </div>
                                <span style="color: var(--gray-600);">5</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 0.5rem;">
                                <span>2★</span>
                                <div style="flex: 1; height: 8px; background: var(--gray-200); border-radius: 4px;"></div>
                                <span style="color: var(--gray-600);">1</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 1rem;">
                                <span>1★</span>
                                <div style="flex: 1; height: 8px; background: var(--gray-200); border-radius: 4px;"></div>
                                <span style="color: var(--gray-600);">1</span>
                            </div>
                        </div>
                    </div>
                                </div>
                                <!-- Form gửi đánh giá -->
                                <c:if test="${not empty sessionScope.user}">
                                <form id="review-form" style="margin-bottom: 2rem; background: #fffbe6; padding: 1.5rem; border-radius: 12px;">
                                        <div style="font-weight: 600; margin-bottom: 0.5rem;">Đánh giá của bạn:</div>
                                        <div id="star-input" style="font-size: 2rem; color: var(--warning-color); margin-bottom: 1rem; cursor: pointer;"></div>
                                        <input type="hidden" name="rating" id="rating-value" value="5" />
                                        <textarea name="comment" id="review-comment" rows="3" class="form-control" placeholder="Nhận xét của bạn..." style="margin-bottom: 1rem;"></textarea>
                                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                        <span id="review-msg" style="margin-left: 1rem; color: var(--success-color);"></span>
                                </form>
                                </c:if>
                                <!-- Danh sách đánh giá -->
                                <div id="review-list"></div>
                                <script>
                                // Hiển thị sao trung bình
                                function renderStars(container, rating) {
                                    let html = '';
                                    for (let i = 1; i <= 5; i++) {
                                        if (rating >= i) html += '<i class="bi bi-star-fill"></i>';
                                        else if (rating >= i - 0.5) html += '<i class="bi bi-star-half"></i>';
                                        else html += '<i class="bi bi-star"></i>';
                                    }
                                    container.innerHTML = html;
                                }
                                // Lấy đánh giá từ API
                                function loadReviews() {
                                    fetch('${pageContext.request.contextPath}/api/product-review?productId=${product.productId}')
                                        .then(res => res.json())
                                        .then(data => {
                                            document.getElementById('avg-rating').textContent = data.averageRating.toFixed(1);
                                            renderStars(document.getElementById('avg-stars'), data.averageRating);
                                            document.getElementById('review-count').textContent = data.reviews.length + ' đánh giá';
                                            let html = '';
                                            if (data.reviews.length === 0) html = '<div style="color:var(--gray-500)">Chưa có đánh giá nào.</div>';
                                            else data.reviews.forEach(r => {
                                                html += `<div style="border-bottom:1px solid #eee;padding:1rem 0;">
                                                    <div style="display:flex;align-items:center;gap:0.5rem;">
                                                        <span style="font-weight:600;">Người dùng #${r.userId}</span>
                                                        <span>`;
                                                for (let i = 1; i <= 5; i++) html += i <= r.rating ? '<i class=\'bi bi-star-fill\' style=\'color:var(--warning-color)\'></i>' : '<i class=\'bi bi-star\' style=\'color:var(--gray-300)\'></i>';
                                                html += `</span>
                                                        <span style="color:var(--gray-500);font-size:0.9em;">${r.createdAt ? r.createdAt.substring(0,10) : ''}</span>
                                                    </div>
                                                    <div style="margin-top:0.5rem;">${r.comment ? r.comment : ''}</div>
                                                </div>`;
                                            });
                                            document.getElementById('review-list').innerHTML = html;
                                        });
                                }
                                loadReviews();
                                // Form gửi đánh giá
                                const form = document.getElementById('review-form');
                                if (form) {
                                    // Sao chọn rating
                                    const starInput = document.getElementById('star-input');
                                    let curRating = 5;
                                    function renderStarInput(val) {
                                        let html = '';
                                        for (let i = 1; i <= 5; i++) {
                                            html += `<i class='bi bi-star${i <= val ? '-fill' : ''}' data-val='${i}'></i>`;
                                        }
                                        starInput.innerHTML = html;
                                    }
                                    renderStarInput(curRating);
                                    starInput.addEventListener('mouseover', e => {
                                        if (e.target.dataset.val) renderStarInput(Number(e.target.dataset.val));
                                    });
                                    starInput.addEventListener('mouseout', () => renderStarInput(curRating));
                                    starInput.addEventListener('click', e => {
                                        if (e.target.dataset.val) {
                                            curRating = Number(e.target.dataset.val);
                                            document.getElementById('rating-value').value = curRating;
                                            renderStarInput(curRating);
                                        }
                                    });
                                    form.onsubmit = function(ev) {
                                        ev.preventDefault();
                                        const rating = document.getElementById('rating-value').value;
                                        const comment = document.getElementById('review-comment').value;
                                        fetch('${pageContext.request.contextPath}/api/product-review', {
                                            method: 'POST',
                                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                            body: "productId=" + encodeURIComponent(${product.productId}) +
                                                        "&userId=" + encodeURIComponent(${sessionScope.user.userId}) +
                                                        "&rating=" + encodeURIComponent(rating) +
                                                        "&comment=" + encodeURIComponent(comment)
                                        }).then(res => res.text()).then(msg => {
                                            document.getElementById('review-msg').textContent = msg.includes('success') ? 'Đã gửi đánh giá!' : msg;
                                            loadReviews();
                                            form.reset();
                                            curRating = 5; renderStarInput(curRating);
                                        });
                                    }
                                }
                                </script>

                <!-- Sample Review -->
                <div style="padding: 1.5rem; border-bottom: 1px solid var(--gray-200);">
                    <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--primary-gradient); 
                                    display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                            NT
                        </div>
                        <div style="flex: 1;">
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Nguyễn Văn Thành</div>
                            <div style="display: flex; gap: 0.25rem; margin-bottom: 0.5rem;">
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                            </div>
                            <div style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 0.75rem;">
                                2 ngày trước · <span style="color: var(--success-color);">Đã mua hàng</span>
                            </div>
                            <p style="color: var(--gray-700); line-height: 1.6;">
                                Sản phẩm rất tốt, đúng như mô tả. Màn hình đẹp, camera chất lượng, pin trâu. 
                                Shop giao hàng nhanh, đóng gói cẩn thận. Recommend!
                            </p>
                        </div>
                    </div>
                </div>

                <div style="padding: 1.5rem; border-bottom: 1px solid var(--gray-200);">
                    <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
                        <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--primary-gradient); 
                                    display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
                            HL
                        </div>
                        <div style="flex: 1;">
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Hoàng Minh Long</div>
                            <div style="display: flex; gap: 0.25rem; margin-bottom: 0.5rem;">
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star-fill" style="color: var(--warning-color); font-size: 0.875rem;"></i>
                                <i class="bi bi-star" style="color: var(--gray-300); font-size: 0.875rem;"></i>
                            </div>
                            <div style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 0.75rem;">
                                1 tuần trước · <span style="color: var(--success-color);">Đã mua hàng</span>
                            </div>
                            <p style="color: var(--gray-700); line-height: 1.6;">
                                Máy chạy mượt, cấu hình khá tốt. Tuy nhiên giá hơi cao so với mặt bằng chung. 
                                Nhưng nhìn chung vẫn ok, đáng đồng tiền.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Back Button -->
    <div style="text-align: center;">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
            <i class="bi bi-arrow-left"></i> Quay Lại Danh Sách
        </a>
    </div>
</div>

<script>
var detailContextPath = '${pageContext.request.contextPath}';
var selectedVariantState = {
    color: '',
    capacity: ''
};

function addVariantToCartWithQuantity(productId, redirectToCheckout) {
    var quantity = document.getElementById('quantity').value;
    var selectedColor = selectedVariantState.color || (document.getElementById('selected-color') ? document.getElementById('selected-color').value : '');
    var selectedCapacity = selectedVariantState.capacity || (document.getElementById('selected-capacity') ? document.getElementById('selected-capacity').value : '');

    var payload = 'productId=' + encodeURIComponent(productId) +
                  '&quantity=' + encodeURIComponent(quantity) +
                  '&selectedColor=' + encodeURIComponent(selectedColor) +
                  '&selectedCapacity=' + encodeURIComponent(selectedCapacity);

    fetch(detailContextPath + '/cart?action=add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: payload
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            if (typeof updateCartBadge === 'function') {
                updateCartBadge(data.cartCount || 0);
            }
            if (redirectToCheckout) {
                window.location.href = detailContextPath + '/checkout';
                return;
            }
            alert('Đã thêm sản phẩm vào giỏ hàng!');
        }
        else alert('Có lỗi xảy ra: ' + data.message);
    })
    .catch(function() { alert('Có lỗi xảy ra khi thêm vào giỏ hàng'); });
}

function setSelectedOption(groupName, value) {
    var normalizedValue = value || '';

    document.querySelectorAll('.product-option-btn[data-option-group="' + groupName + '"]').forEach(function(btn) {
        btn.classList.toggle('is-selected', btn.getAttribute('data-option-value') === normalizedValue);
    });

    if (groupName === 'color' && document.getElementById('selected-color')) {
        document.getElementById('selected-color').value = normalizedValue;
        selectedVariantState.color = normalizedValue;
    }
    if (groupName === 'capacity' && document.getElementById('selected-capacity')) {
        document.getElementById('selected-capacity').value = normalizedValue;
        selectedVariantState.capacity = normalizedValue;
    }

    updateActionButtonsState();
}

function updateActionButtonsState() {
    var btnAddToCart = document.getElementById('btn-add-to-cart');
    var btnBuyNow = document.getElementById('btn-buy-now');

    var hasColorOptions = document.querySelectorAll('.product-option-btn[data-option-group="color"]').length > 0;
    var hasCapacityOptions = document.querySelectorAll('.product-option-btn[data-option-group="capacity"]').length > 0;

    var selectedColor = document.getElementById('selected-color') ? document.getElementById('selected-color').value.trim() : '';
    var selectedCapacity = document.getElementById('selected-capacity') ? document.getElementById('selected-capacity').value.trim() : '';

    var colorReady = !hasColorOptions || selectedColor.length > 0;
    var capacityReady = !hasCapacityOptions || selectedCapacity.length > 0;
    var isReady = colorReady && capacityReady;

    [btnAddToCart, btnBuyNow].forEach(function(btn) {
        if (!btn) return;
        btn.disabled = !isReady;
        btn.classList.toggle('is-disabled-state', !isReady);
    });
}

function validateVariantSelectionOnSubmit() {
    var hasColorOptions = document.querySelectorAll('.product-option-btn[data-option-group="color"]').length > 0;
    var hasCapacityOptions = document.querySelectorAll('.product-option-btn[data-option-group="capacity"]').length > 0;
    var selectedColor = (selectedVariantState.color || (document.getElementById('selected-color') ? document.getElementById('selected-color').value : '')).trim();
    var selectedCapacity = (selectedVariantState.capacity || (document.getElementById('selected-capacity') ? document.getElementById('selected-capacity').value : '')).trim();

    if (hasColorOptions && !selectedColor) {
        alert('Vui lòng chọn màu sắc trước khi tiếp tục.');
        return false;
    }
    if (hasCapacityOptions && !selectedCapacity) {
        alert('Vui lòng chọn dung lượng trước khi tiếp tục.');
        return false;
    }
    return true;
}

function decrementQuantity() {
    var input = document.getElementById('quantity');
    if (!input) return;
    var current = parseInt(input.value || '1', 10);
    if (current > 1) {
        input.value = current - 1;
    }
}

document.addEventListener('DOMContentLoaded', function() {
    var btnDecrement = document.querySelector('button[onclick="decrementQuantity()"]') || document.getElementById('btn-decrement');
    var btnIncrement = document.getElementById('btn-increment');
    var btnAddToCart = document.getElementById('btn-add-to-cart');
    var btnBuyNow = document.getElementById('btn-buy-now');

    document.querySelectorAll('.product-option-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var groupName = this.getAttribute('data-option-group');
            var value = this.getAttribute('data-option-value');
            setSelectedOption(groupName, value);
        });
    });

    var preselectedColorButton = document.querySelector('.product-option-btn[data-option-group="color"].is-selected');
    if (preselectedColorButton) {
        selectedVariantState.color = preselectedColorButton.getAttribute('data-option-value') || '';
    }

    var preselectedCapacityButton = document.querySelector('.product-option-btn[data-option-group="capacity"].is-selected');
    if (preselectedCapacityButton) {
        selectedVariantState.capacity = preselectedCapacityButton.getAttribute('data-option-value') || '';
    }

    updateActionButtonsState();

    if (btnDecrement) {
        btnDecrement.addEventListener('click', function() {
            var input = document.getElementById('quantity');
            if (!input) return;
            var current = parseInt(input.value || '1', 10);
            if (current > 1) {
                input.value = current - 1;
            }
        });
    }

    if (btnIncrement) {
        var maxQty = parseInt(btnIncrement.getAttribute('data-max-qty'));
        btnIncrement.addEventListener('click', function() {
            var input = document.getElementById('quantity');
            if (parseInt(input.value) < maxQty) input.value = parseInt(input.value) + 1;
        });
        btnIncrement.addEventListener('mouseover', function() { this.style.background = 'var(--gray-100)'; });
        btnIncrement.addEventListener('mouseout', function() { this.style.background = 'white'; });
    }
    if (btnAddToCart) {
        btnAddToCart.addEventListener('click', function() {
            if (!validateVariantSelectionOnSubmit()) return;
            addVariantToCartWithQuantity(this.getAttribute('data-product-id'), false);
        });
    }

    if (btnBuyNow) {
        btnBuyNow.addEventListener('click', function() {
            if (!validateVariantSelectionOnSubmit()) return;
            addVariantToCartWithQuantity(this.getAttribute('data-product-id'), true);
        });
    }
});
</script>

<style>
.product-option-btn {
    cursor: pointer;
    transition: all 0.2s ease;
}

.product-option-btn.is-selected {
    border-color: #2563EB !important;
    box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
    background: rgba(37, 99, 235, 0.06) !important;
}

.is-disabled-state {
    opacity: 0.55;
    cursor: not-allowed;
}
</style>

<jsp:include page="../common/footer.jsp"/>
