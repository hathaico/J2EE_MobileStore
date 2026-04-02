/* Admin forms: client-side validation and save-bar behavior */
document.addEventListener('DOMContentLoaded', function(){
    function showAdminError(msg){
        // Create or find alerts container
        var container = document.getElementById('adminAlerts');
        if (!container){
            container = document.createElement('div');
            container.id = 'adminAlerts';
            container.className = 'admin-alerts';
            container.setAttribute('aria-live','polite');
            container.setAttribute('aria-atomic','true');
            document.body.appendChild(container);
        }
        var alertEl = document.createElement('div');
        alertEl.className = 'admin-alert admin-alert-error';
        alertEl.setAttribute('role','alert');
        var msgNode = document.createElement('div');
        msgNode.className = 'admin-alert-message';
        msgNode.appendChild(document.createTextNode(msg));
        var closeBtn = document.createElement('button');
        closeBtn.type = 'button';
        closeBtn.className = 'admin-alert-close';
        closeBtn.setAttribute('aria-label','Close');
        closeBtn.innerHTML = '\u00D7';
        alertEl.appendChild(msgNode);
        alertEl.appendChild(closeBtn);
        container.appendChild(alertEl);
        // trigger show animation
        requestAnimationFrame(function(){ alertEl.classList.add('show'); });
        // close handlers
        closeBtn.addEventListener('click', function(){ hideAlert(alertEl); });
        setTimeout(function(){ hideAlert(alertEl); }, 6000);
    }

    function showAdminSuccess(msg){
        var container = document.getElementById('adminAlerts');
        if (!container){
            container = document.createElement('div');
            container.id = 'adminAlerts';
            container.className = 'admin-alerts';
            container.setAttribute('aria-live','polite');
            container.setAttribute('aria-atomic','true');
            document.body.appendChild(container);
        }
        var alertEl = document.createElement('div');
        alertEl.className = 'admin-alert admin-alert-success';
        alertEl.setAttribute('role','status');
        var msgNode = document.createElement('div');
        msgNode.className = 'admin-alert-message';
        msgNode.appendChild(document.createTextNode(msg));
        var closeBtn = document.createElement('button');
        closeBtn.type = 'button';
        closeBtn.className = 'admin-alert-close';
        closeBtn.setAttribute('aria-label','Close');
        closeBtn.innerHTML = '\u00D7';
        alertEl.appendChild(msgNode);
        alertEl.appendChild(closeBtn);
        container.appendChild(alertEl);
        requestAnimationFrame(function(){ alertEl.classList.add('show'); });
        closeBtn.addEventListener('click', function(){ hideAlert(alertEl); });
        setTimeout(function(){ hideAlert(alertEl); }, 4500);
    }

    function hideAlert(el){
        if (!el) return;
        el.classList.remove('show');
        el.addEventListener('transitionend', function(){ if (el.parentNode) el.parentNode.removeChild(el); });
    }

    // expose helpers globally and provide backward-compatible showError
    window.showAdminError = showAdminError;
    window.showAdminSuccess = showAdminSuccess;
    var showError = window.showAdminError;

    // flush any queued alert() calls that happened before this script loaded
    if (window._adminAlertQueue && window._adminAlertQueue.length){
        window._adminAlertQueue.forEach(function(m){ window.showAdminError(m); });
        window._adminAlertQueue = [];
    }

    // Product form validation
    var productForm = document.getElementById('productForm');
    if (productForm){
        productForm.addEventListener('submit', function(e){
            var name = (productForm.querySelector('[name="productName"]')||{}).value;
            var price = (productForm.querySelector('[name="price"]')||{}).value;
            var stock = (productForm.querySelector('[name="stockQuantity"]')||{}).value;
            // clear previous inline errors
            ['productName','price','stockQuantity'].forEach(function(n){ var el = productForm.querySelector('[name="'+n+'"]'); if (el) el.classList.remove('invalid'); var err = document.getElementById('err'+n); if (err) err.style.display='none'; });
            if (!name || !name.trim()) { e.preventDefault(); var el = productForm.querySelector('[name="productName"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('errproductName'); if (err){ err.textContent='Tên sản phẩm là bắt buộc'; err.style.display='block'; } else { showError('Tên sản phẩm là bắt buộc'); } return; }
            if (!price || isNaN(price) || Number(price) <= 0) { e.preventDefault(); var el = productForm.querySelector('[name="price"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('errprice'); if (err){ err.textContent='Giá phải là số lớn hơn 0'; err.style.display='block'; } else { showError('Giá phải là số lớn hơn 0'); } return; }
            if (stock === '' || isNaN(stock) || Number(stock) < 0) { e.preventDefault(); var el = productForm.querySelector('[name="stockQuantity"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('errstockQuantity'); if (err){ err.textContent='Số lượng tồn kho phải >= 0'; err.style.display='block'; } else { showError('Số lượng tồn kho phải >= 0'); } return; }
        });
    }

    // User form validation
    var userForm = document.getElementById('userForm');
    if (userForm){
        userForm.addEventListener('submit', function(e){
            var username = (userForm.querySelector('[name="username"]')||{}).value;
            var fullName = (userForm.querySelector('[name="fullName"]')||{}).value;
            var email = (userForm.querySelector('[name="email"]')||{}).value;
            // clear previous inline errors
            ['username','fullName','email','new_password'].forEach(function(n){ var el = userForm.querySelector('[name="'+n+'"]'); if (el) el.classList.remove('invalid'); var err = document.getElementById('err'+n); if (err) err.style.display='none'; });
            if (!username || !username.trim()){ e.preventDefault(); var el = userForm.querySelector('[name="username"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('errusername'); if (err){ err.textContent='Tên đăng nhập không được để trống'; err.style.display='block'; } else { showError('Tên đăng nhập không được để trống'); } return; }
            if (!fullName || !fullName.trim()){ e.preventDefault(); var el = userForm.querySelector('[name="fullName"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('errfullName'); if (err){ err.textContent='Họ tên không được để trống'; err.style.display='block'; } else { showError('Họ tên không được để trống'); } return; }
            if (!email || !email.includes('@')){ e.preventDefault(); var el = userForm.querySelector('[name="email"]'); if (el) el.classList.add('invalid'); var err = document.getElementById('erremail'); if (err){ err.textContent='Email không hợp lệ'; err.style.display='block'; } else { showError('Email không hợp lệ'); } return; }
            var pwInput = userForm.querySelector('[name="new_password"]');
            if (pwInput && pwInput.required){
                var pw = pwInput.value || '';
                if (pw.length < 6){ e.preventDefault(); var el = pwInput; if (el) el.classList.add('invalid'); var err = document.getElementById('errnew_password'); if (err){ err.textContent='Mật khẩu cần ít nhất 6 ký tự'; err.style.display='block'; } else { showError('Mật khẩu cần ít nhất 6 ký tự'); } return; }
            }
        });
    }

    // Voucher form validation
    var voucherForm = document.getElementById('voucherForm');
    if (voucherForm){
        voucherForm.addEventListener('submit', function(e){
            var code = (voucherForm.querySelector('[name="code"]')||{}).value;
            var value = (voucherForm.querySelector('[name="discountValue"]')||{}).value;
            var start = (voucherForm.querySelector('[name="startDate"]')||{}).value;
            var end = (voucherForm.querySelector('[name="endDate"]')||{}).value;
            if (!code || !code.trim()){ e.preventDefault(); showError('Mã voucher là bắt buộc'); return; }
            if (!value || isNaN(value) || Number(value) <= 0){ e.preventDefault(); showError('Giá trị giảm phải lớn hơn 0'); return; }
            if (start && end){
                var ds = new Date(start), de = new Date(end);
                if (de < ds){ e.preventDefault(); showError('Ngày kết thúc phải sau ngày bắt đầu'); return; }
            }
        });
    }

    // Brand card selection (click or keyboard) - single select by brand name
    var brandHidden = document.getElementById('brand');
    if (brandHidden){
        function setSelectedBrand(val){
            document.querySelectorAll('.brand-card.selected').forEach(function(c){ c.classList.remove('selected'); });
            if (!val) return;
            var match = document.querySelector('.brand-card[data-brand="'+CSS.escape(val)+'"]');
            if (match) match.classList.add('selected');
            brandHidden.value = val;
        }
        // initialize from existing value
        if (brandHidden.value) setSelectedBrand(brandHidden.value);
        document.querySelectorAll('.brand-card').forEach(function(card){
            card.addEventListener('click', function(){
                var name = card.getAttribute('data-brand') || '';
                setSelectedBrand(name);
            });
            card.addEventListener('keydown', function(e){ if (e.key === 'Enter' || e.key === ' '){ e.preventDefault(); card.click(); } });
        });
    }

    // Enhance save-bar buttons to focus form and submit on Enter
    document.querySelectorAll('.admin-save-bar button[type="submit"]').forEach(function(btn){
        btn.addEventListener('click', function(){
            // minor visual feedback handled by ripple and CSS
        });
    });
});