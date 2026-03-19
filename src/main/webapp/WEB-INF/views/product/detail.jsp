<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
                <div style="background: white; border-radius: 16px; padding: 2rem; 
                            box-shadow: var(--shadow-md); margin-bottom: 1rem; text-align: center;">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${pageContext.request.contextPath}/assets/images/products/${product.imageUrl}" 
                                 alt="${product.productName}" 
                                 style="max-width: 100%; height: auto; max-height: 500px; object-fit: contain;">
                        </c:when>
                        <c:otherwise>
                            <div style="height: 500px; display: flex; align-items: center; justify-content: center;">
                                <i class="bi bi-phone" style="font-size: 10rem; color: var(--gray-300);"></i>
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

                <!-- Color Selection (placeholder) -->
                <div style="margin-bottom: 2rem;">
                    <div style="font-weight: 600; margin-bottom: 0.75rem;">Màu sắc:</div>
                    <div style="display: flex; gap: 0.75rem;">
                        <button style="width: 50px; height: 50px; border-radius: 12px; border: 2px solid var(--primary-color); 
                                       background: linear-gradient(135deg, #1e293b 0%, #334155 100%); cursor: pointer; 
                                       box-shadow: var(--shadow-sm); transition: var(--transition-base);"
                                onclick="this.style.transform='scale(0.95)'"></button>
                        <button style="width: 50px; height: 50px; border-radius: 12px; border: 2px solid transparent; 
                                       background: linear-gradient(135deg, #e8eef5 0%, #f5f7fa 100%); cursor: pointer; 
                                       box-shadow: var(--shadow-sm); transition: var(--transition-base);"
                                onclick="this.style.border='2px solid var(--primary-color)'"></button>
                        <button style="width: 50px; height: 50px; border-radius: 12px; border: 2px solid transparent; 
                                       background: linear-gradient(135deg, #fecaca 0%, #dc2626 100%); cursor: pointer; 
                                       box-shadow: var(--shadow-sm); transition: var(--transition-base);"
                                onclick="this.style.border='2px solid var(--primary-color)'"></button>
                    </div>
                </div>

                <!-- Storage Selection (placeholder) -->
                <div style="margin-bottom: 2rem;">
                    <div style="font-weight: 600; margin-bottom: 0.75rem;">Bộ nhớ:</div>
                    <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
                        <button class="btn btn-outline" style="border: 2px solid var(--primary-color); color: var(--primary-color);">
                            128GB
                        </button>
                        <button class="btn btn-outline">256GB</button>
                        <button class="btn btn-outline">512GB</button>
                        <button class="btn btn-outline">1TB</button>
                    </div>
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
                            <input type="number" id="quantity" value="1" min="1" max="${product.stockQuantity}"
                                   style="width: 80px; height: 40px; text-align: center; border: 1px solid var(--gray-300); 
                                          border-radius: 8px; font-weight: 600; font-size: 1rem;">
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
                            <button id="btn-add-to-cart" data-product-id="${product.productId}" 
                                    class="btn btn-primary" 
                                    style="flex: 1; height: 56px; font-size: 1.1rem; font-weight: 600;">
                                <i class="bi bi-cart-plus"></i> Thêm Vào Giỏ
                            </button>
                            <button class="btn btn-success" 
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
                <a class="nav-link active" data-bs-toggle="tab" href="#description" 
                   style="font-weight: 600; padding: 1rem 1.5rem;">
                    <i class="bi bi-file-text"></i> Mô tả
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-bs-toggle="tab" href="#specs" 
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
            <!-- Description Tab -->
            <div class="tab-pane fade show active" id="description">
                <c:choose>
                    <c:when test="${not empty product.description}">
                        <p style="font-size: 1.05rem; line-height: 1.7; color: var(--gray-700);">
                            ${product.description}
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p style="color: var(--gray-500);">Chưa có mô tả chi tiết cho sản phẩm này.</p>
                    </c:otherwise>
                </c:choose>

                <h4 style="margin-top: 2rem; margin-bottom: 1rem;">Tính năng nổi bật</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem;">
                    <div style="display: flex; gap: 1rem;">
                        <i class="bi bi-phone" style="font-size: 2rem; color: var(--primary-color);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Màn hình OLED</div>
                            <div style="color: var(--gray-600); font-size: 0.875rem;">6.7 inch, Super Retina XDR</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 1rem;">
                        <i class="bi bi-camera" style="font-size: 2rem; color: var(--primary-color);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Camera Pro</div>
                            <div style="color: var(--gray-600); font-size: 0.875rem;">48MP chính, 12MP góc rộng</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 1rem;">
                        <i class="bi bi-battery-charging" style="font-size: 2rem; color: var(--primary-color);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Pin khủng</div>
                            <div style="color: var(--gray-600); font-size: 0.875rem;">Sử dụng cả ngày, sạc nhanh</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 1rem;">
                        <i class="bi bi-cpu" style="font-size: 2rem; color: var(--primary-color);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Vi xử lý mạnh mẽ</div>
                            <div style="color: var(--gray-600); font-size: 0.875rem;">Hiệu năng vượt trội</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Specifications Tab -->
            <div class="tab-pane fade" id="specs">
                <table class="table">
                    <tbody>
                        <tr>
                            <th style="width: 30%; color: var(--gray-600); font-weight: 600;">Thương hiệu</th>
                            <td>${product.brand}</td>
                        </tr>
                        <c:if test="${not empty product.model}">
                            <tr>
                                <th style="color: var(--gray-600); font-weight: 600;">Model</th>
                                <td>${product.model}</td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty product.categoryName}">
                            <tr>
                                <th style="color: var(--gray-600); font-weight: 600;">Danh mục</th>
                                <td>${product.categoryName}</td>
                            </tr>
                        </c:if>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Màn hình</th>
                            <td>6.7 inch, OLED, 120Hz</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Chip xử lý</th>
                            <td>Snapdragon 8 Gen 2</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">RAM</th>
                            <td>8GB / 12GB</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Bộ nhớ trong</th>
                            <td>128GB / 256GB / 512GB</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Camera sau</th>
                            <td>Chính 48MP, Góc rộng 12MP, Tele 12MP</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Camera trước</th>
                            <td>12MP</td>
                        </tr>
                        <tr>
                            <th style="color: var(--gray-600); font-weight: 600;">Pin</th>
                            <td>5000mAh, sạc nhanh 67W</td>
                        </tr>
                    </tbody>
                </table>
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

function addToCartWithQuantity(productId) {
    var quantity = document.getElementById('quantity').value;
    fetch(detailContextPath + '/cart?action=add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + productId + '&quantity=' + quantity
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) { alert('Đã thêm sản phẩm vào giỏ hàng!'); location.reload(); }
        else alert('Có lỗi xảy ra: ' + data.message);
    })
    .catch(function() { alert('Có lỗi xảy ra khi thêm vào giỏ hàng'); });
}

document.addEventListener('DOMContentLoaded', function() {
    var btnDecrement = document.querySelector('button[onclick="decrementQuantity()"]') || document.getElementById('btn-decrement');
    var btnIncrement = document.getElementById('btn-increment');
    var btnAddToCart = document.getElementById('btn-add-to-cart');

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
            addToCartWithQuantity(this.getAttribute('data-product-id'));
        });
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>
