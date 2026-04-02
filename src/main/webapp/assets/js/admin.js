/* ============================================
   ADMIN DASHBOARD - JavaScript
   ============================================ */

document.addEventListener('DOMContentLoaded', function () {

    // === Sidebar Toggle (Mobile) ===
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const toggleBtn = document.getElementById('sidebarToggle');

    if (toggleBtn && sidebar && overlay) {
        toggleBtn.addEventListener('click', function () {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('show');
        });

        overlay.addEventListener('click', function () {
            sidebar.classList.remove('open');
            overlay.classList.remove('show');
        });
    }

    // === Profile Dropdown ===
    const profileToggle = document.getElementById('profileToggle');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileToggle && profileDropdown) {
        profileToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            profileDropdown.classList.toggle('show');
        });

        document.addEventListener('click', function () {
            profileDropdown.classList.remove('show');
        });
    }

    // === Alert Auto-dismiss ===
    document.querySelectorAll('.admin-alert .alert-close').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var alert = this.closest('.admin-alert');
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () { alert.remove(); }, 200);
        });
    });

    // Auto-hide alerts after 5 seconds
    document.querySelectorAll('.admin-alert[data-auto-dismiss]').forEach(function (alert) {
        setTimeout(function () {
            var closeBtn = alert.querySelector('.alert-close');
            if (closeBtn) closeBtn.click();
        }, 5000);
    });

    // === Delete Confirmation Modal ===
    window.adminConfirmDelete = function (formId, itemName) {
        var modalOverlay = document.getElementById('deleteModal');
        var itemNameEl = document.getElementById('deleteItemName');
        var confirmBtn = document.getElementById('deleteConfirmBtn');

        if (!modalOverlay) return;

        if (itemNameEl && itemName) {
            itemNameEl.textContent = itemName;
        }

        modalOverlay.classList.add('show');

        confirmBtn.onclick = function () {
            if (formId) {
                var form = document.getElementById(formId);
                if (form) form.submit();
            }
            modalOverlay.classList.remove('show');
        };
    };

    window.adminCloseModal = function (modalId) {
        var modal = document.getElementById(modalId);
        if (modal) modal.classList.remove('show');
    };

    // Close modal on overlay click
    document.querySelectorAll('.admin-modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                overlay.classList.remove('show');
            }
        });
    });

    // === Table Search Filter ===
    document.querySelectorAll('[data-table-search]').forEach(function (input) {
        var tableId = input.getAttribute('data-table-search');
        input.addEventListener('input', function () {
            var query = this.value.toLowerCase();
            var table = document.getElementById(tableId);
            if (!table) return;
            var rows = table.querySelectorAll('tbody tr');
            rows.forEach(function (row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.indexOf(query) > -1 ? '' : 'none';
            });
        });
    });

    // === Animate elements on load ===
    document.querySelectorAll('.admin-animate-in').forEach(function (el, i) {
        el.style.animationDelay = (i * 0.05) + 's';
    });

    // === Button ripple effect ===
    document.querySelectorAll('.admin-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var circle = document.createElement('span');
            circle.classList.add('ripple');
            var rect = btn.getBoundingClientRect();
            var size = Math.max(rect.width, rect.height);
            circle.style.width = circle.style.height = size + 'px';
            circle.style.left = (e.clientX - rect.left - size/2) + 'px';
            circle.style.top = (e.clientY - rect.top - size/2) + 'px';
            btn.appendChild(circle);
            setTimeout(function(){ circle.remove(); }, 600);
        });
    });

});
