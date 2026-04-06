<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="activePage" value="chatbot-training" scope="request" />
<c:set var="pageTitle" value="Chatbot Training" scope="request" />
<%@ include file="/WEB-INF/views/admin/layout/header.jsp" %>

<div class="admin-page-header">
    <div>
        <div class="admin-breadcrumb">
            <a href="${ctx}/admin/dashboard">Admin</a>
            <i class="bi bi-chevron-right"></i>
            <span>Chatbot Training</span>
        </div>
    </div>
</div>

<div class="row g-4">
    <div class="col-xl-5">
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-robot"></i> Đồng bộ training</h5>
                <span class="admin-badge admin-badge-info">Live dataset</span>
            </div>
            <div class="admin-card-body">
                <p style="margin-bottom:16px;color:var(--admin-text-muted);line-height:1.65;">
                    Trang này lấy dataset từ backend hiện tại, gồm products, promotions và các intent đã nạp cho chatbot.
                    Bạn có thể làm mới cache, tải JSON snapshot hoặc tự động ghi đè file training gốc trong thư mục assets/data trước khi deploy.
                </p>

                <div class="d-flex flex-wrap gap-2 mb-3">
                    <button type="button" id="trainingRefreshBtn" class="btn btn-primary btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-arrow-clockwise"></i> Làm mới cache
                    </button>
                    <button type="button" id="trainingExportBtn" class="btn btn-outline-primary btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-download"></i> Xuất JSON
                    </button>
                    <button type="button" id="trainingSaveBtn" class="btn btn-success btn-sm rounded-3 d-flex align-items-center gap-2 px-3 py-2">
                        <i class="bi bi-cloud-arrow-down"></i> Ghi đè file gốc
                    </button>
                </div>
                    <div class="mb-3 d-flex flex-wrap align-items-end gap-2">
                        <div>
                            <label for="pruneDays" class="form-label mb-1">Prune versions older than (days)</label>
                            <input type="number" class="form-control" id="pruneDays" min="0" value="30" style="width: 200px;">
                        </div>
                        <button type="button" class="btn btn-warning" id="btnPruneHistory">Prune History</button>
                    </div>

                <div class="mb-3" style="font-size:0.9rem;color:var(--admin-text-muted);">
                    Trạng thái: <span id="trainingStatus" style="font-weight:600;color:var(--admin-primary);">Sẵn sàng</span>
                </div>

                <div class="admin-stat-card shadow-sm" style="border-radius:16px;padding:16px;margin-bottom:16px;">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h6 class="mb-1">Nguồn dữ liệu</h6>
                            <div style="font-size:0.9rem;color:var(--admin-text-muted);">Từ [chatbot-training-dataset.json] + dữ liệu live</div>
                        </div>
                        <div class="stat-icon bg-blue rounded-circle d-flex align-items-center justify-content-center" style="width:48px;height:48px;">
                            <i class="bi bi-database-fill"></i>
                        </div>
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;">
                    <div class="admin-stat-card shadow-sm" style="border-radius:16px;padding:14px;">
                        <h6 class="mb-1">Lưu ý</h6>
                        <div style="font-size:0.9rem;color:var(--admin-text-muted);line-height:1.6;">Nếu bạn đổi sản phẩm hoặc voucher, hãy làm mới cache để chatbot dùng dữ liệu mới. Khi ghi đè file gốc, hệ thống sẽ tự prune lịch sử cũ theo cấu hình retention.</div>
                    </div>
                    <div class="admin-stat-card shadow-sm" style="border-radius:16px;padding:14px;">
                        <h6 class="mb-1">Kết nối</h6>
                        <div style="font-size:0.9rem;color:var(--admin-text-muted);line-height:1.6;">Page này dùng cùng API `/api/chatbot/dataset`, `/api/chatbot/dataset/refresh` và `/api/chatbot/dataset/save` để ghi đè file gốc.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-7">
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-filetype-json"></i> Dataset preview</h5>
                <span class="admin-badge admin-badge-success">Preview</span>
            </div>
            <div class="admin-card-body">
                <textarea id="trainingDatasetPreview" class="form-control" rows="22" readonly style="font-family: Consolas, 'Courier New', monospace; font-size: 0.82rem; background: #0f172a; color: #e5e7eb; border-radius: 12px; border: 1px solid rgba(148,163,184,0.25); resize: vertical;"><c:out value="${trainingDatasetJson}" /></textarea>
            </div>
        </div>
    </div>

    <div class="col-12">
        <div class="admin-card admin-animate-in">
            <div class="admin-card-header">
                <h5><i class="bi bi-clock-history"></i> Lịch sử auto-save</h5>
                <span class="admin-badge admin-badge-warning">Rollback</span>
            </div>
            <div class="admin-card-body">
                <div id="trainingHistoryStatus" style="font-size:0.9rem;color:var(--admin-text-muted);margin-bottom:12px;">Đang tải lịch sử phiên bản...</div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>File</th>
                                <th>Ngày sửa</th>
                                <th>Dung lượng</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="trainingHistoryBody">
                            <tr>
                                <td colspan="4">
                                    <div class="admin-empty-state py-4">
                                        <i class="bi bi-hourglass-split" style="font-size:1.5rem;"></i>
                                        <p class="mt-2 mb-0">Đang tải dữ liệu...</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
(function () {
    var ctxPath = '${ctx}';
    var refreshBtn = document.getElementById('trainingRefreshBtn');
    var exportBtn = document.getElementById('trainingExportBtn');
    var saveBtn = document.getElementById('trainingSaveBtn');
        var btnPruneHistory = document.getElementById('btnPruneHistory');
        var pruneDaysInput = document.getElementById('pruneDays');
    var statusEl = document.getElementById('trainingStatus');
    var previewEl = document.getElementById('trainingDatasetPreview');
    var historyBody = document.getElementById('trainingHistoryBody');
    var historyStatus = document.getElementById('trainingHistoryStatus');

    function setStatus(text, tone) {
        if (!statusEl) {
            return;
        }
        statusEl.textContent = text;
        statusEl.style.color = tone === 'error' ? 'var(--admin-danger)' : tone === 'success' ? 'var(--admin-success)' : 'var(--admin-primary)';
    }

    async function refreshDataset() {
        if (!refreshBtn) {
            return;
        }

        refreshBtn.disabled = true;
        refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Đang làm mới...';
        setStatus('Đang đồng bộ cache', 'info');

        try {
            var response = await fetch(ctxPath + '/api/chatbot/dataset/refresh', {
                method: 'POST',
                headers: { 'Accept': 'application/json' }
            });
            var text = await response.text();
            if (!response.ok) {
                throw new Error(text || 'Refresh failed');
            }
            setStatus('Đã làm mới cache', 'success');
            if (window.showAdminSuccess) {
                window.showAdminSuccess('Chatbot dataset cache đã được làm mới.');
            }
        } catch (error) {
            setStatus('Lỗi đồng bộ', 'error');
            if (window.showAdminError) {
                window.showAdminError('Không thể làm mới cache chatbot: ' + error.message);
            }
        } finally {
            refreshBtn.disabled = false;
            refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Làm mới cache';
        }
    }

    async function exportDataset() {
        if (!exportBtn || !previewEl) {
            return;
        }

        exportBtn.disabled = true;
        exportBtn.innerHTML = '<i class="bi bi-download"></i> Đang tải...';
        setStatus('Đang xuất JSON', 'info');

        try {
            var response = await fetch(ctxPath + '/api/chatbot/dataset', {
                headers: { 'Accept': 'application/json' }
            });
            var text = await response.text();
            if (!response.ok) {
                throw new Error(text || 'Export failed');
            }
            previewEl.value = text;
            setStatus('Đã xuất dataset', 'success');

            var blob = new Blob([text], { type: 'application/json;charset=utf-8' });
            var url = window.URL.createObjectURL(blob);
            var link = document.createElement('a');
            link.href = url;
            link.download = 'chatbot-training-dataset.snapshot.json';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            window.URL.revokeObjectURL(url);

            if (window.showAdminSuccess) {
                window.showAdminSuccess('Đã xuất bản sao dataset chatbot hiện tại.');
            }
        } catch (error) {
            setStatus('Lỗi xuất JSON', 'error');
            if (window.showAdminError) {
                window.showAdminError('Không thể xuất dataset chatbot: ' + error.message);
            }
        } finally {
            exportBtn.disabled = false;
            exportBtn.innerHTML = '<i class="bi bi-download"></i> Xuất JSON';
        }
    }

    async function saveDataset() {
        if (!saveBtn) {
            return;
        }

        saveBtn.disabled = true;
        saveBtn.innerHTML = '<i class="bi bi-cloud-arrow-down"></i> Đang ghi...';
        setStatus('Đang ghi đè file gốc', 'info');

        try {
            var response = await fetch(ctxPath + '/api/chatbot/dataset/save', {
                method: 'POST',
                headers: { 'Accept': 'application/json' }
            });

            var text = await response.text();
            if (!response.ok) {
                throw new Error(text || 'Save failed');
            }

            try {
                var payload = JSON.parse(text);
                setStatus('Đã ghi file gốc: ' + (payload.path || 'snapshot'), 'success');
                if (previewEl && payload.path) {
                    previewEl.value = payload.path + '\n\n' + previewEl.value;
                }
                if (window.showAdminSuccess) {
                    window.showAdminSuccess('Đã ghi đè file training gốc của chatbot.');
                }
            } catch (_parseError) {
                setStatus('Đã ghi file gốc', 'success');
            }
        } catch (error) {
            setStatus('Lỗi ghi file', 'error');
            if (window.showAdminError) {
                window.showAdminError('Không thể tự động ghi file snapshot: ' + error.message);
            }
        } finally {
            saveBtn.disabled = false;
            saveBtn.innerHTML = '<i class="bi bi-cloud-arrow-down"></i> Ghi đè file gốc';
        }
    }

    function formatDateTime(value) {
        var date = new Date(Number(value || 0));
        if (isNaN(date.getTime())) {
            return '-';
        }
        return date.toLocaleString('vi-VN');
    }

    function formatBytes(bytes) {
        var value = Number(bytes || 0);
        if (!value) {
            return '0 KB';
        }
        var units = ['B', 'KB', 'MB', 'GB'];
        var index = 0;
        while (value >= 1024 && index < units.length - 1) {
            value = value / 1024;
            index += 1;
        }
        return value.toFixed(index === 0 ? 0 : 1) + ' ' + units[index];
    }

    function escapeHtml(value) {
        return String(value == null ? '' : value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function escapeHtmlAttr(value) {
        return escapeHtml(value).replace(/`/g, '&#96;');
    }

    async function loadHistory() {
        if (!historyBody || !historyStatus) {
            return;
        }

        historyStatus.textContent = 'Đang tải lịch sử phiên bản...';

        try {
            var response = await fetch(ctxPath + '/api/chatbot/dataset/history', {
                headers: { 'Accept': 'application/json' }
            });
            if (!response.ok) {
                throw new Error('History HTTP ' + response.status);
            }

            var items = await response.json();
            if (!Array.isArray(items) || items.length === 0) {
                historyBody.innerHTML = '<tr><td colspan="4"><div class="admin-empty-state py-4"><i class="bi bi-inbox" style="font-size:1.5rem;"></i><p class="mt-2 mb-0">Chưa có bản lưu nào</p></div></td></tr>';
                historyStatus.textContent = 'Chưa có lịch sử auto-save';
                return;
            }

            historyStatus.textContent = 'Tìm thấy ' + items.length + ' bản lưu gần nhất';
            historyBody.innerHTML = items.map(function (item) {
                var fileName = item && item.fileName ? item.fileName : '-';
                var restorable = !!(item && item.restorable);
                return '<tr>' +
                    '<td><strong>' + escapeHtml(fileName) + '</strong></td>' +
                    '<td>' + formatDateTime(item && item.lastModified) + '</td>' +
                    '<td>' + formatBytes(item && item.sizeBytes) + '</td>' +
                    '<td class="text-end">' +
                        '<button type="button" class="btn btn-outline-warning btn-sm rounded-3 d-inline-flex align-items-center gap-2 px-3 py-2 training-restore-btn" data-file-name="' + escapeHtmlAttr(fileName) + '"' + (restorable ? '' : ' disabled') + '>' +
                            '<i class="bi bi-arrow-counterclockwise"></i> Khôi phục' +
                        '</button>' +
                    '</td>' +
                '</tr>';
            }).join('');

            historyBody.querySelectorAll('.training-restore-btn').forEach(function (button) {
                button.addEventListener('click', async function () {
                    var fileName = button.getAttribute('data-file-name');
                    if (!fileName) {
                        return;
                    }

                    if (!window.confirm('Khôi phục từ bản lưu ' + fileName + '?')) {
                        return;
                    }

                    button.disabled = true;
                    button.innerHTML = '<i class="bi bi-arrow-counterclockwise"></i> Đang khôi phục...';

                    try {
                        var response = await fetch(ctxPath + '/api/chatbot/dataset/restore?fileName=' + encodeURIComponent(fileName), {
                            method: 'POST',
                            headers: { 'Accept': 'application/json' }
                        });
                        var text = await response.text();
                        if (!response.ok) {
                            throw new Error(text || 'Restore failed');
                        }

                        setStatus('Đã khôi phục từ ' + fileName, 'success');
                        if (window.showAdminSuccess) {
                            window.showAdminSuccess('Đã khôi phục chatbot training từ ' + fileName + '.');
                        }
                        await loadHistory();
                        if (previewEl) {
                            await exportDataset();
                        }
                    } catch (error) {
                        setStatus('Lỗi khôi phục', 'error');
                        if (window.showAdminError) {
                            window.showAdminError('Không thể khôi phục dataset: ' + error.message);
                        }
                    } finally {
                        button.disabled = false;
                        button.innerHTML = '<i class="bi bi-arrow-counterclockwise"></i> Khôi phục';
                    }
                });
            });
        } catch (error) {
            historyStatus.textContent = 'Không tải được lịch sử phiên bản';
            historyBody.innerHTML = '<tr><td colspan="4"><div class="admin-empty-state py-4"><i class="bi bi-exclamation-triangle" style="font-size:1.5rem;color:var(--admin-danger);"></i><p class="mt-2 mb-0">Không thể tải lịch sử auto-save</p></div></td></tr>';
            if (window.showAdminError) {
                window.showAdminError('Không thể tải lịch sử auto-save: ' + error.message);
            }
        }
    }

    if (refreshBtn) {
        refreshBtn.addEventListener('click', refreshDataset);
    }

    if (exportBtn) {
        exportBtn.addEventListener('click', exportDataset);
    }

    if (saveBtn) {
        saveBtn.addEventListener('click', saveDataset);
    }

        if (btnPruneHistory) {
            btnPruneHistory.addEventListener('click', async () => {
                const days = Number.parseInt((pruneDaysInput && pruneDaysInput.value ? pruneDaysInput.value : '30'), 10);
                if (Number.isNaN(days) || days < 0) {
                    setStatus('Days must be a number >= 0', 'error');
                    return;
                }

                await postAction(`/api/chatbot/dataset/prune?days=${days}`, btnPruneHistory);
                await loadHistory();
            });
        }

    loadHistory();
})();
</script>

<%@ include file="/WEB-INF/views/admin/layout/footer.jsp" %>
