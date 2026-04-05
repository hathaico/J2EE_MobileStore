## 🔗 INTEGRATION GUIDE - Tích Hợp Chatbot Vào Website

Hướng dẫn chi tiết cách tích hợp MobileStore Chatbot vào website của bạn.

---

## 📋 Mục Lục

1. [Tích Hợp Cơ Bản](#tích-hợp-cơ-bản)
2. [Iframe Embedding](#iframe-embedding)
3. [Advanced Configuration](#advanced-configuration)
4. [Styling Customization](#styling-customization)
5. [API Integration](#api-integration)
6. [Testing & Deployment](#testing--deployment)

---

## 🎯 Tích Hợp Cơ Bản

### Phương Pháp 1: Direct HTML Embedding (Recommended)

#### Step 1: Include CSS
```html
<head>
    <link rel="stylesheet" href="<your-domain>/assets/css/chatbot.css">
</head>
```

#### Step 2: Add HTML Widget
```html
<body>
    <!-- Your website content -->
    
    <!-- Chatbot Widget -->
    <div id="chatbot-widget" class="chatbot-container">
        <!-- Chat Header -->
        <div class="chat-header">
            <div class="header-left">
                <h3>🤖 MobileStore Bot</h3>
                <p>Trợ lý bán hàng ảo</p>
            </div>
            <button id="minimize-btn" class="header-btn">_</button>
            <button id="close-btn" class="header-btn">✕</button>
        </div>

        <!-- Chat Messages -->
        <div id="chat-messages" class="chat-messages">
            <div class="message bot-message">
                <div class="message-content">
                    👋 Xin chào! Tôi là trợ lý bán hàng ảo...
                </div>
            </div>
        </div>

        <!-- Suggested Questions -->
        <div id="suggested-questions" class="suggested-questions">
            <button class="suggestion-btn" onclick="sendMessage('Tư vấn theo ngân sách')">
                Tư vấn theo ngân sách
            </button>
            <button class="suggestion-btn" onclick="sendMessage('So sánh sản phẩm')">
                So sánh sản phẩm
            </button>
        </div>

        <!-- Chat Input -->
        <div class="chat-input-area">
            <input type="text" id="chat-input" placeholder="Nhập tin nhắn...">
            <button id="send-btn" class="send-btn">➤</button>
        </div>
    </div>

    <!-- Floating Toggle -->
    <button id="chatbot-toggle" class="chatbot-toggle" onclick="toggleChatbot()">
        💬 Chat
    </button>

    <!-- Include JavaScript -->
    <script src="<your-domain>/assets/js/chatbot.js"></script>
</body>
```

#### Step 3: Update API URL
```javascript
// In chatbot.js or in your page script:
const CHATBOT_API = 'http://your-api-domain:8080/api/chatbot';
// or if same domain:
const CHATBOT_API = '/api/chatbot';
```

---

## 🪟 Iframe Embedding

### Configuration

```html
<!-- Add to your HTML page -->
<iframe 
    id="chatbot-iframe"
    src="http://your-domain:8080/chatbot.html"
    style="width: 400px; height: 600px; border: none; border-radius: 12px;"
    allow="geolocation; microphone"
>
</iframe>
```

### Communication Between Pages

```javascript
// Parent page to iframe
const chatFrame = document.getElementById('chatbot-iframe');
chatFrame.contentWindow.postMessage({
    type: 'USER_INFO',
    userId: 'user_123',
    userName: 'John Doe'
}, '*');

// Iframe receives
window.addEventListener('message', (event) => {
    if (event.data.type === 'USER_INFO') {
        console.log('User:', event.data.userId);
    }
});
```

---

## ⚙️ Advanced Configuration

### Custom API Endpoint

```javascript
// Option 1: Update CHATBOT_API globally
window.CHATBOT_API = 'https://api.yoursite.com/chatbot';

// Option 2: Pass config to initChatbot
window.initChatbot({
    apiUrl: 'https://api.yoursite.com/chatbot',
    userId: 'user_' + Date.now(),
    theme: 'dark',
    language: 'vi'
});
```

### User Context

```javascript
// Set user info before initializing
window.chatbotConfig = {
    userId: 'user_12345',
    userName: 'Nguyễn Văn A',
    email: 'user@example.com',
    phone: '0123456789',
    preference: 'iphone'
};
```

### Custom Handlers

```javascript
// Before loading chatbot.js
window.chatbotHandlers = {
    onMessageSent: function(message) {
        console.log('User sent:', message);
        // Analytics tracking
        gtag('event', 'chatbot_message_sent');
    },
    
    onMessageReceived: function(response) {
        console.log('Bot responded:', response);
    },
    
    onProductSelected: function(product) {
        console.log('Product selected:', product);
        // Navigate to product page
        window.location.href = '/product/' + product.id;
    },
    
    onClosed: function() {
        console.log('Bot closed');
    }
};
```

---

## 🎨 Styling Customization

### Option 1: Override CSS Variables

```html
<style>
    :root {
        /* Primary Colors */
        --chatbot-primary: #667eea;
        --chatbot-secondary: #764ba2;
        
        /* Dimensions */
        --chatbot-width: 400px;
        --chatbot-height: 600px;
        
        /* Fonts */
        --chatbot-font: 'Segoe UI', sans-serif;
        --chatbot-font-size: 14px;
    }
    
    .chatbot-container {
        width: var(--chatbot-width) !important;
        height: var(--chatbot-height) !important;
        font-family: var(--chatbot-font) !important;
    }
    
    .chat-header {
        background: linear-gradient(135deg, var(--chatbot-primary), var(--chatbot-secondary)) !important;
    }
</style>
```

### Option 2: Custom Theme

```css
/* Dark Theme */
.chatbot-dark .chatbot-container {
    background: #2a2a2a;
    color: #fff;
}

.chatbot-dark .bot-message .message-content {
    background: #3a3a3a;
    color: #fff;
    border: 1px solid #555;
}

.chatbot-dark .chat-messages {
    background: #1a1a1a;
}

/* Light Theme (default) */
.chatbot-light .chatbot-container {
    background: white;
}

/* Compact Theme */
.chatbot-compact .chatbot-container {
    --chatbot-width: 300px;
    --chatbot-height: 400px;
}
```

---

## 🔌 API Integration

### Webhook Integration

```javascript
// Capture bot responses and send to your server
window.chatbotHandlers = {
    onMessageReceived: async function(response) {
        // Send to your analytics/CRM system
        await fetch('https://your-api.com/webhooks/chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId: window.chatbotConfig.userId,
                message: response.message,
                type: response.responseType,
                timestamp: new Date()
            })
        });
    }
};
```

### Product Selection Tracking

```javascript
// Track when user shows interest in product
window.chatbotHandlers = {
    onProductViewRequested: function(productId) {
        // Log analytics
        analytics.track('chatbot_product_viewed', {
            productId: productId,
            source: 'chatbot'
        });
        
        // Add to favorites
        fetch('/api/favorites/add', {
            method: 'POST',
            body: JSON.stringify({ productId: productId })
        });
    }
};
```

---

## ✅ Testing & Deployment

### Pre-Deployment Checklist

```
Functionality:
☐ Greeting message appears
☐ Text input works
☐ Send button works
☐ Chat history displays
☐ Minimize/Close buttons work
☐ Suggested questions clickable

API:
☐ /api/chatbot/message responds
☐ CORS headers correct
☐ JSON parsing works
☐ Error handling works

Styling:
☐ Widget looks good on desktop
☐ Widget looks good on mobile
☐ Colors match brand
☐ Fonts render correctly
☐ No overflow or layout issues

Performance:
☐ Page load time < 3s
☐ Chat response < 1s
☐ No memory leaks
☐ Browser console clean

Integration:
☐ Works on all pages
☐ No conflicting CSS
☐ No JavaScript conflicts
☐ Analytics tracking works
```

### Local Testing

```bash
# Start local server
npm install -g http-server
http-server

# Test endpoints
curl http://localhost:8080/api/chatbot/health
```

### Browser Testing

```
Chrome:     ✓ Full support
Firefox:    ✓ Full support
Safari:     ✓ Full support
Edge:       ✓ Full support
IE11:       ⚠ Partial (no ES6)
Mobile:     ✓ Full support
```

---

## 🚀 Deployment Scenarios

### Scenario 1: Same Server

```
If API and website on same server:
  
CHATBOT_API = '/api/chatbot'
```

### Scenario 2: Different Servers (Cross-Domain)

```
Website: https://mobilestore.vn
API: https://api.mobilestore.vn

CHATBOT_API = 'https://api.mobilestore.vn/api/chatbot'

Requirements:
- Enable CORS on API server
- Use HTTPS on both
```

### Scenario 3: Docker/Kubernetes

```yaml
# docker-compose.yml
version: '3'
services:
  web:
    image: mobilestore-web
    ports:
      - "80:80"
    environment:
      CHATBOT_API: "http://api:8080/api/chatbot"
  
  api:
    image: mobilestore-api
    ports:
      - "8080:8080"
```

### Scenario 4: CDN Deployment

```javascript
// Load CSS from CDN
<link rel="stylesheet" href="https://cdn.example.com/chatbot.css?v=1.0">

// Load JS from CDN
<script src="https://cdn.example.com/chatbot.js?v=1.0"></script>

// Update API endpoint
CHATBOT_API = 'https://api.mobilestore.vn/api/chatbot'
```

---

## 📱 Mobile Responsive

### Auto Adjust on Mobile

```javascript
// Detect device type
const isMobile = window.innerWidth < 768;

if (isMobile) {
    // Adjust chatbot dimensions
    document.documentElement.style.setProperty('--chatbot-width', '100vw');
    document.documentElement.style.setProperty('--chatbot-height', '100vh');
}
```

### Mobile CSS

```css
@media (max-width: 480px) {
    .chatbot-container {
        width: calc(100vw - 20px) !important;
        height: calc(100vh - 20px) !important;
        bottom: 10px !important;
        right: 10px !important;
    }
}
```

---

## 🔐 Security Considerations

### CORS Policy

```javascript
// Only allow specific origins
@CrossOrigin(origins = {"https://mobilestore.vn", "https://www.mobilestore.vn"})
```

### Input Sanitization

```javascript
// Already handled in chatbot.js with sanitizeHTML()
// But you can add additional validation:

function validateUserInput(message) {
    // Remove special characters
    if (!/^[a-zA-Z0-9\s\?\!\.\,\-éèêôûù]+$/i.test(message)) {
        return false;
    }
    // Check length
    if (message.length > 500) {
        return false;
    }
    return true;
}
```

### HTTPS Requirement

```
For production:
- Use HTTPS for all endpoints
- Set secure cookies
- Implement rate limiting
- Add authentication if needed
```

---

## 📊 Monitoring & Analytics

### Google Analytics Integration

```javascript
// Track chatbot events
window.chatbotHandlers = {
    onMessageSent: function(message) {
        gtag('event', 'chatbot_message_sent', {
            'message_length': message.length,
            'user_id': window.chatbotConfig.userId
        });
    },
    
    onProductViewRequested: function(productId) {
        gtag('event', 'chatbot_product_view', {
            'product_id': productId
        });
    }
};
```

### Custom Analytics

```javascript
// Send to your own backend
const trackEvent = (eventName, data) => {
    fetch('https://your-analytics.com/track', {
        method: 'POST',
        body: JSON.stringify({
            event: eventName,
            data: data,
            timestamp: Date.now()
        })
    });
};
```

---

## 🆘 Troubleshooting Integration

### Issue: Widget không hiển thị

```
Check:
1. CSS file loaded?
2. JavaScript file loaded?
3. Network errors in console?
4. Z-index conflict?

Fix:
.chatbot-container {
    z-index: 99999 !important;
}
```

### Issue: API 404 Error

```
Check:
1. API server running?
2. Correct URL?
3. CORS enabled?
4. Firewall blocking?

Test:
curl -i http://your-api:8080/api/chatbot/health
```

### Issue: Styling broken

```
Check:
1. CSS path correct?
2. File encoding UTF-8?
3. Media queries working?

Test in browser:
- Open chatbot-demo.html
- Check computed styles
- Check responsive breakpoints
```

---

## 📚 Example Implementation

```html
<!-- Complete Integration Example -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MobileStore Shop</title>
    <link rel="stylesheet" href="assets/css/chatbot.css">
</head>
<body>
    <!-- Main Website Content -->
    <div id="main-content">
        <!-- Your shop content here -->
    </div>

    <!-- Chatbot Widget -->
    <div id="chatbot-widget" class="chatbot-container">
        <!-- Widget HTML here -->
    </div>

    <!-- Scripts -->
    <script>
        // Configure chatbot
        window.CHATBOT_API = '/api/chatbot';
        window.chatbotConfig = {
            userId: localStorage.getItem('user_id') || 'user_guest',
            theme: 'light'
        };
    </script>
    <script src="assets/js/chatbot.js"></script>
    <script>
        // Analytics integration
        window.chatbotHandlers = {
            onMessageSent: (msg) => console.log('Sent:', msg),
            onMessageReceived: (res) => console.log('Received:', res)
        };
    </script>
</body>
</html>
```

---

## ✅ Checklist: Ready to Deploy

- [x] CSS included correctly
- [x] JavaScript loaded
- [x] HTML widget in place
- [x] API endpoint configured
- [x] CORS enabled
- [x] Mobile responsive
- [x] Analytics tracking
- [x] Error handling
- [x] Browser tested
- [x] Performance optimized

---

## 📞 Support

Nếu gặp vấn đề:
- 📖 Xem CHATBOT_README.md
- 🚀 Xem CHATBOT_QUICK_START.md
- 🌐 Demo: /chatbot-demo.html
- 📧 Contact: support@mobilestore.vn

---

**Happy Integration! 🎉**
