<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="activePage" value="products" scope="request" />
<c:set var="pageTitle" value="Thêm sản phẩm - Admin" scope="request" />
<c:set var="adminHideContentHeaderTitle" value="true" scope="request" />
<c:set var="adminHeaderBackHref" value="${pageContext.request.contextPath}/admin/products" scope="request" />
<c:set var="adminHeaderBackLabel" value="Danh sách sản phẩm" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<div class="admin-form-page">
<c:if test="${not empty errorMessage}">
    <div class="admin-alert admin-alert-danger mb-3" data-auto-dismiss>
        <i class="bi bi-exclamation-circle-fill"></i> ${errorMessage}
        <button type="button" class="alert-close"><i class="bi bi-x-lg"></i></button>
    </div>
</c:if>

<div class="admin-card shadow-sm">
    <div class="admin-card-header">
        <h5><i class="bi bi-box-seam-fill"></i> Thêm sản phẩm mới</h5>
    </div>
    <div class="admin-card-body">
        <form action="${ctx}/admin/products" method="post" enctype="multipart/form-data" id="productForm">
            <input type="hidden" name="action" value="create">

            <div class="row g-4 align-items-lg-start">
                <div class="col-lg-8">
                    <div class="admin-form-section admin-form-section--boxed">
                        <div class="admin-form-section__head">
                            <h6 class="admin-form-section__title"><i class="bi bi-info-circle"></i> Thông tin cơ bản</h6>
                        </div>
                        <div class="mb-3">
                            <label for="productName" class="admin-form-label">Tên sản phẩm <span class="admin-required">*</span></label>
                            <input type="text" class="admin-form-control" id="productName" name="productName" required maxlength="200" value="${param.productName}" placeholder="Ví dụ: iPhone 17e 128GB">
                            <div class="admin-field-error" id="errproductName"></div>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="admin-form-label" for="brand">Thương hiệu</label>
                                <c:choose>
                                    <c:when test="${not empty brands}">
                                        <select class="admin-form-select" id="brand" name="brand">
                                            <option value="">— Chọn thương hiệu —</option>
                                            <c:forEach var="b" items="${brands}">
                                                <option value="${b.name}" ${param.brand == b.name ? 'selected' : ''}>${b.name}</option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" class="admin-form-control" id="brand" name="brand" maxlength="100" value="${param.brand}" placeholder="Apple, Samsung…">
                                    </c:otherwise>
                                </c:choose>
                                <div class="admin-field-error" id="errbrand"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="model" class="admin-form-label">Model</label>
                                <input type="text" class="admin-form-control" id="model" name="model" maxlength="100" value="${param.model}" placeholder="Mã model hoặc cấu hình">
                            </div>
                        </div>
                        <div class="row g-3 mt-3">
                            <div class="col-md-6">
                                <label for="color" class="admin-form-label">Màu sắc</label>
                                <input type="text" class="admin-form-control" id="color" name="color" maxlength="50" value="${param.color}" placeholder="Ví dụ: Đen, Bạc, Xanh">
                                <div class="admin-color-preview" id="colorPreviewWrapper" style="display: ${empty param.color ? 'none' : 'flex'}; flex-wrap: wrap; gap:0.75rem; margin-top:0.75rem;">
                                    <div id="colorPreviewContainer" style="display:flex; flex-wrap: wrap; gap:0.75rem;"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="capacity" class="admin-form-label">Dung lượng</label>
                                <input type="text" class="admin-form-control" id="capacity" name="capacity" maxlength="50" value="${param.capacity}" placeholder="Ví dụ: 128GB, 256GB">
                            </div>
                        </div>
                    </div>

                    <div class="admin-form-section admin-form-section--boxed">
                        <div class="admin-form-section__head">
                            <h6 class="admin-form-section__title"><i class="bi bi-currency-dollar"></i> Giá &amp; tồn kho</h6>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="price" class="admin-form-label">Giá (VNĐ) <span class="admin-required">*</span></label>
                                <div class="d-flex flex-wrap align-items-center gap-2">
                                    <input type="number" class="admin-form-control" id="price" name="price" required min="0" step="1000" value="${param.price}" placeholder="19900000" style="min-width:140px;">
                                    <span id="pricePreview" class="admin-price-chip" aria-live="polite">&nbsp;</span>
                                </div>
                                <p class="admin-form-hint mb-0">Nhập số nguyên (đồng). Ví dụ 19&nbsp;900&nbsp;000 hiển thị đúng định dạng tiền Việt.</p>
                                <div class="admin-field-error" id="errprice"></div>
                            </div>
                            <div class="col-md-4">
                                <label for="stockQuantity" class="admin-form-label">Tồn kho <span class="admin-required">*</span></label>
                                <input type="number" class="admin-form-control" id="stockQuantity" name="stockQuantity" required min="0" value="${param.stockQuantity != null ? param.stockQuantity : 0}">
                                <div class="admin-field-error" id="errstockQuantity"></div>
                            </div>
                            <div class="col-md-4">
                                <label for="categoryId" class="admin-form-label">Danh mục <span class="admin-required">*</span></label>
                                <select class="admin-form-select" id="categoryId" name="categoryId" required>
                                    <option value="">— Chọn danh mục —</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" ${param.categoryId == category.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                                    </c:forEach>
                                </select>
                                <div class="admin-field-error" id="errcategoryId"></div>
                            </div>
                        </div>
                    </div>

                    <div class="admin-form-section admin-form-section--boxed mb-0">
                        <div class="admin-form-section__head">
                            <h6 class="admin-form-section__title"><i class="bi bi-list-check"></i> Thông số kỹ thuật</h6>
                        </div>
                        <p class="admin-form-hint mb-3">Nhập theo từng dòng thông số để hiển thị đúng bảng ở trang sản phẩm.</p>
                        <div id="specRows" class="d-flex flex-column gap-2 mb-3"></div>
                        <button type="button" class="admin-btn admin-btn-outline admin-btn-sm" id="addSpecRowBtn">
                            <i class="bi bi-plus-circle"></i> Thêm thông số
                        </button>
                        <label for="description" class="admin-form-label mt-3">Dữ liệu đồng bộ (tự tạo)</label>
                        <textarea class="admin-form-control" id="description" name="description" rows="6" readonly placeholder="Dữ liệu sẽ tự tạo từ danh sách thông số...">${param.description}</textarea>
                    </div>
                </div>

                <div class="col-lg-4 admin-form-sidebar-col">
                    <aside class="admin-media-panel">
                        <h6 class="admin-media-panel__title"><i class="bi bi-image"></i> Hình ảnh</h6>
                        <p class="admin-media-panel__subtitle">Kéo thả hoặc bấm vùng bên dưới để chọn ảnh (JPEG, PNG, WebP…)</p>

                        <div class="preview-overlay file-drop-area admin-avatar-preview add-preview" id="productDropArea" style="margin:0 auto; overflow:hidden; cursor:pointer; width:100%;">
                            <c:choose>
                                <c:when test="${not empty param.imageUrl}">
                                    <c:set var="productPreviewSrc" value="${ctx}/assets/images/products/${param.imageUrl}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="productPreviewSrc" value="" />
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${not empty productPreviewSrc}">
                                    <img id="productPreview" src="${productPreviewSrc}" alt="preview" style="width:100%;height:220px;object-fit:cover;border-radius:10px;"/>
                                </c:when>
                                <c:otherwise>
                                    <div id="productPreviewPlaceholder" class="admin-dropzone-inner d-flex flex-column align-items-center justify-content-center text-muted py-5 px-3" style="min-height:220px;">
                                        <i class="bi bi-cloud-arrow-up display-6 mb-2"></i>
                                        <span class="small text-center" style="max-width:14rem;line-height:1.5;">Chưa có ảnh — chọn file hoặc nhập tên file có sẵn trong thư mục ảnh.</span>
                                    </div>
                                    <img id="productPreview" src="" alt="" style="display:none;width:100%;height:220px;object-fit:cover;border-radius:10px;"/>
                                </c:otherwise>
                            </c:choose>
                            <div class="preview-badge" id="removePreviewBtn" style="cursor:pointer; display:none;">Xóa</div>
                        </div>

                        <div class="mt-3 d-flex flex-wrap align-items-center gap-2">
                            <label class="file-upload-btn mb-0" for="productImageFile" tabindex="0"><i class="bi bi-upload"></i> Chọn ảnh</label>
                            <span class="file-upload-filename text-truncate" style="max-width:100%;" id="productImageFilename">${param.imageUrl}</span>
                        </div>
                        <input type="file" id="productImageFile" name="productImageFile" accept="image/*" class="file-upload-input" />
                        <input type="hidden" id="imageUrl" name="imageUrl" value="${param.imageUrl}" />

                        <p class="admin-form-hint mb-0 mt-2">Nếu ảnh đã có trên server, chỉ cần nhập tên file (trong <code class="small">/assets/images/products/</code>).</p>

                        <hr class="my-4 opacity-25">

                        <div class="row g-2">
                            <div class="col-12">
                                <label class="admin-form-label">Trạng thái hiển thị</label>
                                <select class="admin-form-select" name="status">
                                    <option value="ACTIVE">Đang kinh doanh</option>
                                    <option value="INACTIVE">Tạm ngừng</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="admin-form-label">Sản phẩm nổi bật</label>
                                <select class="admin-form-select" name="featured">
                                    <option value="false">Không</option>
                                    <option value="true">Có</option>
                                </select>
                            </div>
                        </div>
                    </aside>
                </div>
            </div>

            <div class="admin-save-bar">
                <a href="${ctx}/admin/products" class="admin-btn admin-btn-outline admin-btn-sm">Hủy</a>
                <button type="submit" class="admin-btn admin-btn-primary admin-btn-sm"><i class="bi bi-check2-circle"></i> Lưu sản phẩm</button>
            </div>
        </form>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var specRows = document.getElementById('specRows');
        var addSpecRowBtn = document.getElementById('addSpecRowBtn');
        var descriptionInput = document.getElementById('description');
        var form = document.getElementById('productForm');
        var initialSpecs = descriptionInput ? descriptionInput.value : '';

        function createSpecRow(key, value) {
            var row = document.createElement('div');
            row.className = 'row g-2 align-items-center spec-row';
            row.innerHTML =
                '<div class="col-md-5">' +
                    '<input type="text" class="admin-form-control spec-key" placeholder="Tên thông số (VD: Camera sau)" />' +
                '</div>' +
                '<div class="col-md-6">' +
                    '<input type="text" class="admin-form-control spec-value" placeholder="Giá trị (VD: 50MP + 12MP)" />' +
                '</div>' +
                '<div class="col-md-1">' +
                    '<button type="button" class="admin-btn admin-btn-outline admin-btn-sm spec-remove" title="Xóa dòng"><i class="bi bi-trash"></i></button>' +
                '</div>';

            var keyInput = row.querySelector('.spec-key');
            var valueInput = row.querySelector('.spec-value');
            var removeBtn = row.querySelector('.spec-remove');

            keyInput.value = key || '';
            valueInput.value = value || '';

            keyInput.addEventListener('input', syncSpecsToDescription);
            valueInput.addEventListener('input', syncSpecsToDescription);
            removeBtn.addEventListener('click', function() {
                row.remove();
                if (specRows.children.length === 0) {
                    createSpecRow('', '');
                }
                syncSpecsToDescription();
            });

            specRows.appendChild(row);
        }

        function syncSpecsToDescription() {
            var lines = [];
            specRows.querySelectorAll('.spec-row').forEach(function(row) {
                var k = row.querySelector('.spec-key').value.trim();
                var v = row.querySelector('.spec-value').value.trim();
                if (!k && !v) return;
                if (k && v) lines.push(k + ': ' + v);
                else if (k) lines.push(k + ':');
                else lines.push(v);
            });
            descriptionInput.value = lines.join('\n');
        }

        function initSpecs() {
            if (initialSpecs && initialSpecs.trim().length > 0) {
                initialSpecs.split(/\r?\n/).forEach(function(line) {
                    var text = line.trim();
                    if (!text) return;
                    var idx = text.indexOf(':');
                    if (idx > -1) {
                        createSpecRow(text.substring(0, idx).trim(), text.substring(idx + 1).trim());
                    } else {
                        createSpecRow(text, '');
                    }
                });
            }

            if (specRows.children.length === 0) {
                createSpecRow('', '');
            }
            syncSpecsToDescription();
        }

        if (addSpecRowBtn) {
            addSpecRowBtn.addEventListener('click', function() {
                createSpecRow('', '');
            });
        }

        if (form) {
            form.addEventListener('submit', function() {
                syncSpecsToDescription();
            });
        }

        initSpecs();

        var colorInput = document.getElementById('color');
        var previewWrapper = document.getElementById('colorPreviewWrapper');
        var previewContainer = document.getElementById('colorPreviewContainer');

        var colorMap = {
            "đen": "#111827",
            "den": "#111827",
            "trắng": "#FFFFFF",
            "trang": "#FFFFFF",
            "bạc": "#C0C0C0",
            "bac": "#C0C0C0",
            "xám": "#6B7280",
            "xam": "#6B7280",
            "đỏ": "#EF4444",
            "do": "#EF4444",
            "xanh dương": "#2563EB",
            "xanh duong": "#2563EB",
            "xanh lá": "#10B981",
            "xanh la": "#10B981",
            "xanh lục": "#10B981",
            "xanh luc": "#10B981",
            "tím": "#8B5CF6",
            "tim": "#8B5CF6",
            "hồng": "#EC4899",
            "hong": "#EC4899",
            "vàng": "#F59E0B",
            "vang": "#F59E0B",
            "cam": "#FB923C",
            "nâu": "#92400E",
            "nau": "#92400E",
            "xanh ngọc": "#14B8A6",
            "xanh ngoc": "#14B8A6",
            "xanh rêu": "#65A30D",
            "xanh reu": "#65A30D",
            "hồng nhạt": "#F9A8D4",
            "hong nhat": "#F9A8D4",
            "xám đậm": "#374151",
            "xam dam": "#374151",
            "trắng sữa": "#F8FAFC",
            "trang sua": "#F8FAFC"
        };

        function getCssColor(label) {
            var normalized = label.trim().toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            normalized = normalized.replace(/[^a-z0-9 ]+/g, ' ').replace(/\s+/g, ' ').trim();
            return colorMap[normalized] || label;
        }

        function renderColorPreview() {
            var value = colorInput.value.trim();
            previewContainer.innerHTML = '';

            if (value.length === 0) {
                previewWrapper.style.display = 'none';
                return;
            }

            previewWrapper.style.display = 'flex';
            var colors = value.split(/[,;/]+/).map(function(token) { return token.trim(); }).filter(function(token) { return token.length > 0; });

            colors.forEach(function(colorLabel) {
                var cssColor = getCssColor(colorLabel);
                var option = document.createElement('div');
                option.className = 'product-color-option';
                option.title = colorLabel;

                var swatch = document.createElement('div');
                swatch.className = 'product-color-swatch';
                swatch.style.background = cssColor;
                swatch.style.border = cssColor === 'transparent' ? '1px solid #D1D5DB' : '1px solid rgba(0, 0, 0, 0.08)';

                var label = document.createElement('div');
                label.className = 'product-color-name';
                label.textContent = colorLabel;

                option.appendChild(swatch);
                option.appendChild(label);
                previewContainer.appendChild(option);
            });
        }

        colorInput.addEventListener('input', renderColorPreview);
        renderColorPreview();
    });
</script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var fileInput = document.getElementById('productImageFile');
    var preview = document.getElementById('productPreview');
    var placeholder = document.getElementById('productPreviewPlaceholder');
    var imageUrlInput = document.getElementById('imageUrl');
    var filenameSpan = document.getElementById('productImageFilename');
    var dropArea = document.getElementById('productDropArea');
    var removeBtn = document.getElementById('removePreviewBtn');
    var priceInput = document.getElementById('price');
    var pricePreview = document.getElementById('pricePreview');

    function showFile(file){
        var reader = new FileReader();
        reader.onload = function(evt){
            if (placeholder) placeholder.style.display = 'none';
            if (preview) {
                preview.style.display = 'block';
                preview.src = evt.target.result;
            }
            if (removeBtn) removeBtn.style.display = 'block';
        };
        reader.readAsDataURL(file);
        if (imageUrlInput) imageUrlInput.value = file.name;
        if (filenameSpan) filenameSpan.textContent = file.name;
    }

    if (fileInput) {
        fileInput.addEventListener('change', function(e){
            var f = e.target.files && e.target.files[0]; if (!f) return; showFile(f);
        });
    }

    if (dropArea){
        dropArea.addEventListener('click', function(ev){
            if (ev.target === removeBtn) return;
            if (fileInput) fileInput.click();
        });
        ['dragenter','dragover'].forEach(function(ev){ dropArea.addEventListener(ev, function(e){ e.preventDefault(); e.stopPropagation(); dropArea.classList.add('dragover'); }); });
        ['dragleave','drop'].forEach(function(ev){ dropArea.addEventListener(ev, function(e){ e.preventDefault(); e.stopPropagation(); dropArea.classList.remove('dragover'); }); });
        dropArea.addEventListener('drop', function(e){
            var dt = e.dataTransfer; if (!dt) return; var f = dt.files && dt.files[0]; if (!f) return; if (fileInput) fileInput.files = dt.files; showFile(f);
        });
    }

    if (removeBtn){
        removeBtn.addEventListener('click', function(e){
            e.stopPropagation();
            if (fileInput) fileInput.value = '';
            if (imageUrlInput) imageUrlInput.value = '';
            if (filenameSpan) filenameSpan.textContent = '';
            if (preview) { preview.src = ''; preview.style.display = 'none'; }
            if (placeholder) placeholder.style.display = 'flex';
            removeBtn.style.display = 'none';
        });
    }

    function formatPrice(val){
        try{
            var n = Number(val);
            if (!isFinite(n) || n <= 0) { pricePreview.textContent = ''; return; }
            pricePreview.textContent = new Intl.NumberFormat('vi-VN').format(n) + ' \u20ab';
        }catch(e){ pricePreview.textContent = ''; }
    }
    if (priceInput && pricePreview){
        priceInput.addEventListener('input', function(){ formatPrice(this.value); });
        formatPrice(priceInput.value);
    }
});
</script>
<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
