(function () {
    'use strict';

    const CONTEXT_PATH = window.location.pathname.includes('/MobileStore') ? '/MobileStore' : '';
    const CHATBOT_API = CONTEXT_PATH + '/api/chatbot';
    const PRODUCT_DETAIL_PATH = CONTEXT_PATH + '/products?action=detail&id=';
    const CART_PATH = CONTEXT_PATH + '/cart';

    const STORAGE_KEYS = {
        apiKey: 'chatbot_deepseek_api_key',
        model: 'chatbot_deepseek_model',
        endpoint: 'chatbot_deepseek_endpoint'
    };

    const DEFAULT_AI = {
        model: 'deepseek-reasoner',
        endpoint: 'https://api.deepseek.com/chat/completions'
    };

    let ui = null;
    let isSending = false;
    let compareBuffer = [];
    let hasShownAiFallbackNotice = false;
    let conversationHistory = [];

    const QUICK_ACTIONS = {
        compare: 'So sánh iPhone 15 và Samsung S24',
        stock: 'Kiểm tra tồn kho sản phẩm',
        tech: 'Tư vấn thông số kỹ thuật',
        promo: 'Có khuyến mãi nào không?',
        budget: 'Tư vấn giúp tôi với ngân sách 10 triệu'
    };

    document.addEventListener('DOMContentLoaded', init);

    function init() {
        ui = {
            widget: document.getElementById('chatbot-widget'),
            toggle: document.getElementById('chatbot-toggle'),
            messages: document.getElementById('chat-messages'),
            quickActions: document.getElementById('quick-actions'),
            form: document.getElementById('chat-form'),
            input: document.getElementById('chat-input'),
            send: document.getElementById('send-btn'),
            minimize: document.getElementById('minimize-btn'),
            close: document.getElementById('close-btn'),
            aiModeBadge: document.getElementById('ai-mode-badge'),
            aiSettingsBtn: document.getElementById('ai-settings-btn'),
            aiSettingsPanel: document.getElementById('ai-settings-panel'),
            apiKeyInput: document.getElementById('deepseek-api-key'),
            modelInput: document.getElementById('deepseek-model'),
            endpointInput: document.getElementById('deepseek-endpoint'),
            saveAiSettingsBtn: document.getElementById('save-ai-settings'),
            clearAiSettingsBtn: document.getElementById('clear-ai-settings')
        };

        if (!ui.widget || !ui.messages || !ui.form || !ui.input) {
            return;
        }

        hydrateAiSettings();
        bindEvents();
        openChat();
        loadGreeting();
    }

    function bindEvents() {
        ui.form.addEventListener('submit', function (event) {
            event.preventDefault();
            const message = (ui.input.value || '').trim();
            if (!message) {
                ui.input.focus();
                return;
            }
            sendMessage(message);
            ui.input.value = '';
        });

        if (ui.quickActions) {
            ui.quickActions.addEventListener('click', function (event) {
                const btn = event.target.closest('.quick-chip');
                if (!btn || isSending) {
                    return;
                }
                const key = btn.getAttribute('data-quick');
                const text = QUICK_ACTIONS[key];
                if (text) {
                    sendMessage(text);
                }
            });
        }

        ui.messages.addEventListener('click', function (event) {
            const suggestion = event.target.closest('.suggestion-chip');
            if (suggestion && !isSending) {
                const message = suggestion.getAttribute('data-message') || suggestion.textContent || '';
                if (message.trim()) {
                    sendMessage(message.trim());
                }
                return;
            }

            const productBtn = event.target.closest('.product-btn');
            if (!productBtn) {
                return;
            }

            const action = productBtn.getAttribute('data-action');
            const productId = parseInt(productBtn.getAttribute('data-product-id') || '0', 10);
            const productName = productBtn.getAttribute('data-product-name') || 'sản phẩm';

            if (action === 'detail' && productId > 0) {
                window.location.href = PRODUCT_DETAIL_PATH + productId;
                return;
            }

            if (action === 'compare' && productName) {
                handleCompareAction(productName);
                return;
            }

            if (action === 'cart' && productId > 0) {
                addToCart(productId, productName);
            }
        });

        if (ui.aiSettingsBtn && ui.aiSettingsPanel) {
            ui.aiSettingsBtn.addEventListener('click', function () {
                const opened = ui.aiSettingsPanel.style.display !== 'none';
                ui.aiSettingsPanel.style.display = opened ? 'none' : 'block';
            });
        }

        if (ui.saveAiSettingsBtn) {
            ui.saveAiSettingsBtn.addEventListener('click', function () {
                persistAiSettings();
                appendBotText('Đã lưu cấu hình DeepSeek. Bot sẽ ưu tiên AI nếu key hợp lệ.', []);
            });
        }

        if (ui.clearAiSettingsBtn) {
            ui.clearAiSettingsBtn.addEventListener('click', function () {
                clearAiSettings();
                appendBotText('Đã xóa API key. Bot đang chạy ở chế độ dữ liệu trực tiếp từ MobileStore.', []);
            });
        }

        ui.minimize.addEventListener('click', minimizeChat);
        ui.close.addEventListener('click', closeChat);
        ui.toggle.addEventListener('click', openChat);
    }

    function hydrateAiSettings() {
        const cfg = getAiSettings();
        if (ui.apiKeyInput) {
            ui.apiKeyInput.value = cfg.apiKey || '';
        }
        if (ui.modelInput) {
            ui.modelInput.value = cfg.model;
        }
        if (ui.endpointInput) {
            ui.endpointInput.value = cfg.endpoint;
        }
        refreshAiBadge();
    }

    function getAiSettings() {
        const injected = window.MOBILESTORE_CHATBOT_CONFIG || {};
        const localApiKey = localStorage.getItem(STORAGE_KEYS.apiKey) || '';
        const localModel = localStorage.getItem(STORAGE_KEYS.model) || '';
        const localEndpoint = localStorage.getItem(STORAGE_KEYS.endpoint) || '';

        return {
            apiKey: (ui && ui.apiKeyInput && ui.apiKeyInput.value ? ui.apiKeyInput.value.trim() : '') ||
                localApiKey ||
                (injected.deepseekApiKey || '') ||
                '',
            model: (ui && ui.modelInput && ui.modelInput.value ? ui.modelInput.value.trim() : '') ||
                localModel ||
                (injected.deepseekModel || '') ||
                DEFAULT_AI.model,
            endpoint: (ui && ui.endpointInput && ui.endpointInput.value ? ui.endpointInput.value.trim() : '') ||
                localEndpoint ||
                (injected.deepseekEndpoint || '') ||
                DEFAULT_AI.endpoint
        };
    }

    function persistAiSettings() {
        const cfg = getAiSettings();
        if (cfg.apiKey) {
            localStorage.setItem(STORAGE_KEYS.apiKey, cfg.apiKey);
        } else {
            localStorage.removeItem(STORAGE_KEYS.apiKey);
        }
        localStorage.setItem(STORAGE_KEYS.model, cfg.model || DEFAULT_AI.model);
        localStorage.setItem(STORAGE_KEYS.endpoint, cfg.endpoint || DEFAULT_AI.endpoint);
        hasShownAiFallbackNotice = false;
        refreshAiBadge();
    }

    function clearAiSettings() {
        localStorage.removeItem(STORAGE_KEYS.apiKey);
        localStorage.removeItem(STORAGE_KEYS.model);
        localStorage.removeItem(STORAGE_KEYS.endpoint);

        if (ui.apiKeyInput) {
            ui.apiKeyInput.value = '';
        }
        if (ui.modelInput) {
            ui.modelInput.value = DEFAULT_AI.model;
        }
        if (ui.endpointInput) {
            ui.endpointInput.value = DEFAULT_AI.endpoint;
        }

        hasShownAiFallbackNotice = false;
        refreshAiBadge('AI OFF');
    }

    function isAiEnabled() {
        const cfg = getAiSettings();
        return !!cfg.apiKey;
    }

    function refreshAiBadge(modeText) {
        if (!ui.aiModeBadge) {
            return;
        }
        if (modeText) {
            ui.aiModeBadge.textContent = modeText;
            return;
        }
        ui.aiModeBadge.textContent = isAiEnabled() ? 'AI READY' : 'AI OFF';
    }

    async function loadGreeting() {
        ui.messages.innerHTML = '';
        try {
            const response = await fetch(CHATBOT_API + '/greeting', { headers: { Accept: 'application/json' } });
            if (!response.ok) {
                throw new Error('Greeting failed');
            }
            const data = await response.json();
            appendBotResponse(data);
            rememberConversation('assistant', data && data.message ? data.message : 'Xin chào!');
        } catch (_e) {
            appendBotText('Xin chào! Mình là MobileStore Bot. Bạn cần tư vấn sản phẩm nào?', []);
            rememberConversation('assistant', 'Xin chào! Mình là MobileStore Bot. Bạn cần tư vấn sản phẩm nào?');
        }
    }

    async function sendMessage(message) {
        if (isSending) {
            return;
        }

        appendUserMessage(message);
        rememberConversation('user', message);
        setSendingState(true);
        showTyping(isAiEnabled() ? 'DeepSeek R1 đang phân tích...' : 'MobileStore Bot đang nhập...');

        try {
            const backendData = await requestBackendMessageSafe(message);
            const aiData = await buildAiEnhancedResponse(message, backendData);
            const finalData = aiData || backendData;

            hideTyping();

            if (finalData) {
                appendBotResponse(finalData);
                rememberConversation('assistant', finalData.message || '');
                return;
            }

            throw new Error('Không nhận được dữ liệu phản hồi hợp lệ.');
        } catch (error) {
            hideTyping();
            appendBotText('Mình đang gặp lỗi kết nối tạm thời. Bạn thử lại sau vài giây nhé.', []);
            console.error('Chatbot error:', error);
        } finally {
            setSendingState(false);
        }
    }

    async function requestBackendMessageSafe(message) {
        try {
            const response = await fetch(CHATBOT_API + '/message', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json'
                },
                body: JSON.stringify({
                    userMessage: message,
                    userId: getUserId()
                })
            });

            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }

            return await response.json();
        } catch (error) {
            console.error('Backend chatbot error:', error);
            return null;
        }
    }

    async function buildAiEnhancedResponse(message, backendData) {
        if (!isAiEnabled()) {
            refreshAiBadge('AI OFF');
            return null;
        }

        const cfg = getAiSettings();

        try {
            const aiText = await requestDeepSeekReply(cfg, message, backendData);
            if (!aiText) {
                return null;
            }

            hasShownAiFallbackNotice = false;
            refreshAiBadge('AI ON');

            if (!backendData) {
                return {
                    message: aiText,
                    suggestedQuestions: [
                        'Bạn có thể gợi ý 3 mẫu phù hợp không?',
                        'Sản phẩm nào đang khuyến mãi tốt?',
                        'So sánh giúp mình 2 mẫu nổi bật'
                    ],
                    responseType: 'TEXT'
                };
            }

            return {
                message: aiText,
                suggestedQuestions: Array.isArray(backendData.suggestedQuestions) ? backendData.suggestedQuestions : [],
                responseType: 'TEXT',
                products: Array.isArray(backendData.products) ? backendData.products : []
            };
        } catch (error) {
            console.error('DeepSeek error:', error);
            refreshAiBadge('AI FALLBACK');

            if (backendData && !hasShownAiFallbackNotice) {
                hasShownAiFallbackNotice = true;
                backendData.message =
                    'DeepSeek đang tạm gián đoạn, mình chuyển sang dữ liệu trực tiếp từ MobileStore để bạn không bị gián đoạn.\n\n' +
                    (backendData.message || '');
            }

            return null;
        }
    }

    async function requestDeepSeekReply(cfg, message, backendData) {
        const payload = {
            model: cfg.model || DEFAULT_AI.model,
            temperature: 0.35,
            max_tokens: 700,
            messages: buildAiMessages(message, backendData)
        };

        const response = await fetch(cfg.endpoint || DEFAULT_AI.endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + cfg.apiKey
            },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            const text = await response.text();
            throw new Error('DeepSeek HTTP ' + response.status + ': ' + String(text || '').slice(0, 200));
        }

        const data = await response.json();
        const content = data && data.choices && data.choices[0] && data.choices[0].message
            ? data.choices[0].message.content
            : '';

        return String(content || '').trim();
    }

    function buildAiMessages(message, backendData) {
        const systemPrompt = [
            '=== MOBILESTORE CHATBOT TRAINING ===',
            '',
            'BẠN LÀ AI TRỢ LỢ BÁN HÀNG MOBILESTORE',
            '- Trả lời bằng tiếng Việt thân thiện, ngắn gọn (dưới 200 từ/chunk)',
            '- Ưu tiên dùng DỮ LIỆU THAM CHIẾU để tránh bịa thông tin',
            '- Nếu dữ liệu thiếu, nói rõ "cần kiểm tra thêm" + đề xuất hành động',
            '- KHÔNG trả lời ngoài: mua sắm, tồn kho, giá, so sánh, khuyến mãi, đơn hàng, bảo hành',
            '',
            'INTENT CHÍNH & CỬ CHỈ:',
            '1. GREETING: "Xin chào", "Hi", "Hì" → Chào lại + giới thiệu MobileStore (bán điện thoại di động)',
            '2. SEARCH PRODUCT: "Bạn có X không?", "Bán cái gì?" → Liệt kê sản phẩm, hỏi rõ model',
            '3. PRICE QUERY: "Giá bao nhiêu?" → Trả giá chính xác hoặc gợi ý theo budget (dùng DỮ LIỆU)',
            '4. STOCK CHECK: "Còn hàng không?", "Tồn kho bao nhiêu?" → Báo stock cụ thể (từ DỮ LIỆU)',
            '5. COMPARE: "So sánh iPhone vs Samsung" → Bảng so sánh CPU, RAM, ROM, pin, camera, giá, rating',
            '6. TECH SPECS: "RAM/pin/camera bao nhiêu?" → Trả spec + gợi ý phù hợp nhu cầu (gaming/photo)',
            '7. BUDGET: "Budget 15 triệu nên mua gì?" → 3–4 mẫu phù hợp, xếp hạng theo đặc điểm',
            '8. PROMOTION: "Có khuyến mãi?", "Trả góp?", "Bảo hành?" → Liệt kê khuyến mãi + hỗ trợ mua (từ DỮ LIỆU)',
            '9. ORDER STATUS: "Đơn hàng đâu?", "Giao khi nào?" → Hỏi Order ID → Tra cứu backend',
            '10. OUT-OF-SCOPE: Chính trị, tôn giáo, học tập → "Xin lỗi, chỉ giúp về bán điện thoại. Có gì khác?"',
            '',
            'TONE & VOICE:',
            '✓ NÊN: Thân thiện, chính xác, trích dẫn dữ liệu, hỏi lại nếu mơ hồ, đề xuất hành động tiếp',
            '✗ KHÔNG: Bịa giá, promise không vào, quá kỹ thuật, discount tự ý (dùng backend)',
            '',
            'EDGE CASES:',
            '- Thiếu dữ liệu? Nói thẳng "chưa cập nhật" + gợi ý tương tự + xin liên hệ',
            '- Không rõ câu hỏi? Hỏi lại 1–2 câu: "Bạn dùng cho gì ạ? (gaming/camera/văn phòng)"',
            '- Info nhạy cảm (phone, address)? Không lưu, hướng đến website/hotline',
            '',
            'QUICK ACTIONS & SUGGESTIONS:',
            '- Sau mỗi trả lời, gợi ý 2–3 câu hỏi tiếp: "So sánh?", "Kiểm tra tồn kho?", "Khuyến mãi?"',
            '- Nếu hỏi giá → "Muốn so sánh model khác?" hoặc "Kiểm tra tồn kho?"',
            '- Nếu hỏi khuyến mãi → "Trả góp 0% lãi?" hoặc "Trade-in?"',
            '',
            'MASTER DATA (Cập nhật từ Backend):',
            '- iPhone 15 Pro Max: 35,990,000 VND (⭐4.8, 15 cái), iPhone 14 Pro: 24,990,000 VND',
            '- Samsung S24 Ultra: 32,990,000 VND (⭐4.7, 23 cái), Samsung A54: 12,990,000 VND',
            '- Xiaomi 14 Ultra: 21,990,000 VND (⭐4.5, 30 cái), Xiaomi 13 Lite: 7,490,000 VND',
            '- Realme 12 Pro: 9,990,000 VND (⭐4.2, 50 cái)',
            '- Khuyến mãi: Mua iPhone → Tặng AirPods Pro, Trade-in 8M, Trả góp 0%, Miễn phí giao hàng, Bảo hành 12 tháng',
            '- Hotline: 1800-1234, Email: support@mobilestore.vn',
            '',
            'TRAINING EXAMPLES:',
            '[EX1] User: "iPhone 15 giá bao nhiêu?" → Bot: "iPhone 15 Pro Max hiện 35,990,000 VND (giảm từ 36,990K). Muốn so sánh Samsung S24 không?"',
            '[EX2] User: "Budget 10 triệu, nên mua gì?" → Bot: "3 lựa chọn tốt: 1) Realme 12 Pro (9.99M) – Chip mạnh, 2) Xiaomi 13 Lite (7.49M) – Rẻ, 3) Samsung A14 (4.99M) – Cơ bản. Cái nào quan tâm?"',
            '[EX3] User: "So sánh iPhone 15 và Samsung S24" → Bot: [Bảng so sánh 8 dòng: CPU, RAM, ROM, Pin, Camera, Giá, Rating]',
            '[EX4] User: "Còn hàng không?" → Bot: "Còn 15 chiếc iPhone 15 Pro Max. Còn model khác muốn kiểm tra?"',
            '[EX5] User: "Có khuyến mãi không?" → Bot: "Có! Mua iPhone → Tặng AirPods Pro (5.5M), Trade-in 8M, Trả góp 0% 12 tháng. Muốn biết thêm?"',
            '[EX6] User: "Học lập trình ở đâu?" → Bot: "Xin lỗi, mình chỉ giúp về bán điện thoại. Bạn muốn tư vấn smartphone nào không?"'
        ].join('\n');

        const history = conversationHistory.slice(-6);
        const groundedData = serializeBackendData(backendData);
        const userPrompt = groundedData
            ? message + '\n\nDỮ LIỆU THAM CHIẾU:\n' + groundedData
            : message;

        return [{ role: 'system', content: systemPrompt }]
            .concat(history)
            .concat([{ role: 'user', content: userPrompt }]);
    }

    function serializeBackendData(backendData) {
        if (!backendData) {
            return '';
        }

        const chunks = [];
        if (backendData.message) {
            chunks.push('Tom tat phan hoi he thong: ' + stripHtml(String(backendData.message)).slice(0, 900));
        }

        if (backendData.responseType) {
            chunks.push('Loai phan hoi: ' + backendData.responseType);
        }

        if (Array.isArray(backendData.products) && backendData.products.length > 0) {
            const lines = backendData.products.slice(0, 5).map(function (p, idx) {
                const name = p.name || p.productName || 'San pham';
                const price = formatPrice(Number(p.discountedPrice || p.price || 0));
                const stock = p.stockStatus || (Number(p.stock || 0) > 0 ? 'Con hang' : 'Het hang');
                return (idx + 1) + '. ' + name + ' - ' + price + ' - ' + stock;
            });
            chunks.push('San pham lien quan:\n' + lines.join('\n'));
        }

        return chunks.join('\n');
    }

    function stripHtml(html) {
        return String(html)
            .replace(/<[^>]+>/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();
    }

    function rememberConversation(role, content) {
        if (!content) {
            return;
        }
        conversationHistory.push({
            role: role,
            content: String(content).slice(0, 1200)
        });
        if (conversationHistory.length > 12) {
            conversationHistory = conversationHistory.slice(-12);
        }
    }

    function appendBotResponse(data) {
        const message = data && data.message ? String(data.message) : 'Mình đã nhận yêu cầu của bạn.';
        const suggestions = Array.isArray(data && data.suggestedQuestions) ? data.suggestedQuestions : [];

        if ((data && data.responseType === 'COMPARISON') || /<table/i.test(message)) {
            appendBotHtml(message, suggestions);
            return;
        }

        appendBotText(message, suggestions);

        if (data && data.responseType === 'PRODUCT_LIST' && Array.isArray(data.products) && data.products.length > 0) {
            appendProductCards(data.products);
        }
    }

    function appendBotText(text, suggestions) {
        const wrapper = createMessageWrapper('bot');
        wrapper.appendChild(createMeta('MobileStore Bot'));

        const content = document.createElement('div');
        content.className = 'message-content';
        content.innerHTML = nl2br(escapeHtml(text));

        if (suggestions && suggestions.length > 0) {
            content.appendChild(createSuggestionRow(suggestions));
        }

        wrapper.appendChild(content);
        ui.messages.appendChild(wrapper);
        scrollBottom();
    }

    function appendBotHtml(html, suggestions) {
        const wrapper = createMessageWrapper('bot');
        wrapper.appendChild(createMeta('MobileStore Bot'));

        const content = document.createElement('div');
        content.className = 'message-content';
        content.innerHTML = sanitizeLimitedHtml(html);

        if (suggestions && suggestions.length > 0) {
            content.appendChild(createSuggestionRow(suggestions));
        }

        wrapper.appendChild(content);
        ui.messages.appendChild(wrapper);
        scrollBottom();
    }

    function appendUserMessage(text) {
        const wrapper = createMessageWrapper('user');
        wrapper.appendChild(createMeta('Bạn'));

        const content = document.createElement('div');
        content.className = 'message-content';
        content.innerHTML = nl2br(escapeHtml(text));

        wrapper.appendChild(content);
        ui.messages.appendChild(wrapper);
        scrollBottom();
    }

    function appendProductCards(products) {
        const wrapper = createMessageWrapper('bot');
        wrapper.appendChild(createMeta('MobileStore Bot'));

        const content = document.createElement('div');
        content.className = 'message-content';

        products.forEach(function (product) {
            const p = mapProduct(product);
            const card = document.createElement('div');
            card.className = 'product-card';
            card.innerHTML = [
                '<div class="product-top">',
                '  <div class="product-image">🎧</div>',
                '  <div>',
                '    <div class="product-brand">' + escapeHtml((p.brand || 'N/A').toUpperCase()) + ' ⭐</div>',
                '    <div class="product-title">' + escapeHtml(p.name) + '</div>',
                '    <div class="product-rating">⭐ ' + p.rating + ' (128 đánh giá) • 856 đã bán</div>',
                '    <div class="product-price">' + p.priceText + '</div>',
                '    <span class="status-badge">' + escapeHtml(p.stockStatus) + '</span>',
                '  </div>',
                '</div>',
                '<div class="product-spec">CPU: ' + escapeHtml(p.cpu) + ' | RAM: ' + escapeHtml(p.ram + 'GB') + ' | ROM: ' + escapeHtml(p.storage + 'GB') + '</div>',
                '<span class="color-chip">' + escapeHtml(p.color) + '</span>',
                '<div class="product-benefits">',
                '  <span>🔧 Bảo hành 12 tháng</span>',
                '  <span>🔄 Đổi trả 7 ngày</span>',
                '  <span>🚚 Miễn phí vận chuyển</span>',
                '  <span>💰 Trả góp 0%</span>',
                '</div>',
                '<div class="product-actions">',
                '  <button type="button" class="product-btn" data-action="detail" data-product-id="' + p.id + '" data-product-name="' + escapeAttr(p.name) + '">Xem chi tiết</button>',
                '  <button type="button" class="product-btn" data-action="compare" data-product-id="' + p.id + '" data-product-name="' + escapeAttr(p.name) + '">So sánh</button>',
                '  <button type="button" class="product-btn primary" data-action="cart" data-product-id="' + p.id + '" data-product-name="' + escapeAttr(p.name) + '">Thêm vào giỏ</button>',
                '</div>'
            ].join('');

            content.appendChild(card);
        });

        wrapper.appendChild(content);
        ui.messages.appendChild(wrapper);
        scrollBottom();
    }

    function handleCompareAction(productName) {
        compareBuffer.push(productName);
        compareBuffer = compareBuffer.slice(-2);

        appendUserMessage('So sánh ' + productName);

        if (compareBuffer.length < 2) {
            appendBotText('Đã chọn ' + productName + '. Bạn hãy chọn thêm 1 sản phẩm nữa để so sánh.', []);
            return;
        }

        const query = 'So sánh ' + compareBuffer[0] + ' và ' + compareBuffer[1];
        compareBuffer = [];
        sendMessage(query);
    }

    async function addToCart(productId, productName) {
        try {
            const body = new URLSearchParams();
            body.append('action', 'add');
            body.append('productId', String(productId));
            body.append('quantity', '1');
            body.append('selectedColor', 'Trắng');
            body.append('selectedCapacity', '128GB');

            const response = await fetch(CART_PATH, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    Accept: 'application/json'
                },
                body: body.toString()
            });

            if (!response.ok) {
                throw new Error('Add cart failed');
            }

            const data = await response.json();
            if (data && data.success) {
                appendUserMessage('Thêm vào giỏ: ' + productName);
                appendBotText('Đã thêm vào giỏ hàng thành công.', []);
            } else {
                appendBotText((data && data.message) ? data.message : 'Không thể thêm vào giỏ hàng.', []);
            }
        } catch (error) {
            appendBotText('Không thể thêm vào giỏ lúc này. Bạn thử lại sau nhé.', []);
            console.error(error);
        }
    }

    function createSuggestionRow(items) {
        const row = document.createElement('div');
        row.className = 'suggestion-row';
        items.slice(0, 3).forEach(function (item) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'suggestion-chip';
            btn.setAttribute('data-message', item);
            btn.textContent = item;
            row.appendChild(btn);
        });
        return row;
    }

    function showTyping(text) {
        hideTyping();
        const wrapper = createMessageWrapper('bot');
        wrapper.id = 'typing-indicator';
        wrapper.appendChild(createMeta('MobileStore Bot'));

        const content = document.createElement('div');
        content.className = 'message-content';
        content.innerHTML =
            '<div class="typing-box">' +
            '  <div class="typing-dots"><span></span><span></span><span></span></div>' +
            '  <span>' + escapeHtml(text) + '</span>' +
            '</div>';

        wrapper.appendChild(content);
        ui.messages.appendChild(wrapper);
        scrollBottom();
    }

    function hideTyping() {
        const typing = document.getElementById('typing-indicator');
        if (typing) {
            typing.remove();
        }
    }

    function setSendingState(sending) {
        isSending = sending;
        if (ui.send) {
            ui.send.disabled = sending;
        }
    }

    function openChat() {
        ui.widget.classList.remove('is-hidden', 'is-minimized');
        ui.toggle.style.display = 'none';
        ui.input.focus();
        scrollBottom();
    }

    function minimizeChat() {
        ui.widget.classList.add('is-minimized');
        ui.toggle.style.display = 'block';
    }

    function closeChat() {
        ui.widget.classList.add('is-hidden');
        ui.toggle.style.display = 'block';
    }

    function createMessageWrapper(type) {
        const el = document.createElement('div');
        el.className = 'message ' + (type === 'user' ? 'user-message' : 'bot-message');
        return el;
    }

    function createMeta(name) {
        const meta = document.createElement('div');
        meta.className = 'message-meta';
        meta.textContent = name + ' • ' + formatTime(new Date());
        return meta;
    }

    function formatTime(date) {
        return String(date.getHours()).padStart(2, '0') + ':' + String(date.getMinutes()).padStart(2, '0');
    }

    function scrollBottom() {
        setTimeout(function () {
            ui.messages.scrollTop = ui.messages.scrollHeight;
        }, 0);
    }

    function mapProduct(raw) {
        return {
            id: Number(raw.id || raw.productId || 0),
            name: raw.name || raw.productName || 'Sản phẩm',
            brand: raw.brand || 'N/A',
            priceText: formatPrice(Number(raw.discountedPrice || raw.price || 0)),
            stockStatus: raw.stockStatus || (Number(raw.stock || 0) > 0 ? 'Còn hàng' : 'Hết hàng'),
            cpu: raw.cpu || 'Đang cập nhật',
            ram: Number(raw.ram || 8),
            storage: Number(raw.storage || 128),
            color: (raw.colors ? String(raw.colors).split(',')[0].trim() : 'Trắng') || 'Trắng',
            rating: Number(raw.rating || 4.5).toFixed(1)
        };
    }

    function formatPrice(v) {
        return new Intl.NumberFormat('vi-VN').format(v || 0) + '₫';
    }

    function sanitizeLimitedHtml(html) {
        return String(html)
            .replace(/<script[\s\S]*?>[\s\S]*?<\/script>/gi, '')
            .replace(/on\w+=/gi, '')
            .replace(/javascript:/gi, '');
    }

    function escapeHtml(s) {
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function escapeAttr(s) {
        return escapeHtml(s).replace(/`/g, '');
    }

    function nl2br(s) {
        return String(s).replace(/\n/g, '<br>');
    }

    function getUserId() {
        let userId = localStorage.getItem('chatbot_user_id');
        if (!userId) {
            userId = 'user_' + Math.random().toString(36).slice(2, 10);
            localStorage.setItem('chatbot_user_id', userId);
        }
        return userId;
    }
})();
