# 🚀 CHATBOT DEPLOYMENT GUIDE - Fix & Deploy

## ✅ Build Status
```
BUILD SUCCESS
[INFO] Building war: C:\Users\hatha\J2EE_MobileStore\target\MobileStore.war
[INFO] Tests: 19 Passed, 0 Failed
```

Tất cả lỗi biên dịch đã được sửa! Chatbot sẵn sàng deploy.

---

## 📦 Deployment Options

### Option 1: Simple Tomcat Deployment (Easiest)

```bash
# 1. Copy WAR to Tomcat
copy C:\Users\hatha\J2EE_MobileStore\target\MobileStore.war C:\apache-tomcat-10\webapps\

# 2. Start Tomcat
C:\apache-tomcat-10\bin\startup.bat

# 3. Wait 10-15 seconds for deployment

# 4. Access in browser
http://localhost:8080/MobileStore/chatbot-demo.html
http://localhost:8080/MobileStore/chatbot.html
```

### Option 2: Deploy using Maven Plugin

```bash
cd C:\Users\hatha\J2EE_MobileStore

# Build and deploy
mvn tomcat7:run

# Or run WAR directly
mvn -Dtomcat.home="C:\apache-tomcat-10" tomcat7:deploy

# Access
http://localhost:8080/MobileStore
```

---

## 🧪 Testing After Deployment

### Test 1: Health Check
```bash
# PowerShell
Invoke-WebRequest -Uri "http://localhost:8080/MobileStore/api/chatbot/health"

# Response should be:
# "Chatbot API is running!"
```

### Test 2: Send a Message
```bash
# PowerShell
$body = @{
    userMessage = "Xin chào"
    userId = "test_user"
} | ConvertTo-Json

(Invoke-WebRequest -Uri "http://localhost:8080/MobileStore/api/chatbot/message" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body).Content | ConvertFrom-Json | Format-List
```

### Test 3: Browser Test
Open in browser:
```
http://localhost:8080/MobileStore/chatbot-demo.html
```

**Expected:** See chatbot demo page with:
- Widget UI
- Conversation examples
- FAQs
- Integration guide

---

## 🔧 API Endpoints

All endpoints base: `http://localhost:8080/MobileStore/api/chatbot`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/health` | GET | Check API status |
| `/greeting` | GET | Get greeting message |
| `/message` | POST | Send chat message |

---

## 💬 API Request Examples

### POST /api/chatbot/message
```json
{
  "userMessage": "Tư vấn điện thoại ngân sách 10 triệu",
  "userId": "user_12345"
}
```

### Response Example
```json
{
  "message": "Dựa trên ngân sách của bạn...",
  "responseType": "PRODUCT_LIST",
  "products": [
    {
      "id": 1,
      "name": "OPPO Reno 11 Pro",
      "brand": "OPPO",
      "price": 10990000,
      "discountedPrice": 9990000,
      "cpu": "Snapdragon 8 Gen 2",
      "ram": 12,
      "storage": 256,
      "battery": 5000,
      "rearCamera": "50MP + 48MP + 32MP",
      "stock": 20
    }
  ],
  "suggestedQuestions": [
    "So sánh với các sản phẩm khác",
    "Có khuyến mãi không?",
    "Phí vận chuyển bao nhiêu?"
  ],
  "timestamp": "14:30:45"
}
```

---

## 🌐 Access URLs

| Purpose | URL |
|---------|-----|
| **Demo & Docs** | http://localhost:8080/MobileStore/chatbot-demo.html |
| **Chat Widget** | http://localhost:8080/MobileStore/chatbot.html |
| **API Health** | http://localhost:8080/MobileStore/api/chatbot/health |
| **Integration** | See CHATBOT_INTEGRATION.md |

---

## ❌ Troubleshooting

### Issue 1: 404 Not Found

**Problem:** `http://localhost:8080/chatbot-demo.html` → 404
**Solution:** Use correct context path: `http://localhost:8080/MobileStore/chatbot-demo.html`

### Issue 2: API Returns 404

**Problem:** Chatbot sends to `/api/chatbot/message` → 404
**Solution:** Check chatbot.js configuration:
```javascript
// Should auto-detect but can set manually:
const CHATBOT_API = '/MobileStore/api/chatbot';
```

### Issue 3: CORS Errors

**Problem:** `Cross-Origin Request Blocked`
**Solution:** 
- CORS is already enabled in ChatBotController servlet
- Check browser console for actual error
- For cross-domain: configure CORS in servlet

### Issue 4: Servlet Not Found

**Problem:** `No mapping found for HTTP request with URI [/api/chatbot/...]`
**Solution:**
- Check `@WebServlet("/api/chatbot/*")` annotation
- Ensure Tomcat has latest deployment
- Restart Tomcat completely

### Issue 5: JSON Parse Error

**Problem:** `Unexpected character`
**Solution:**
- Check request Content-Type: `application/json`
- Validate JSON with JSONLint
- Ensure UTF-8 encoding

---

## 📊 Architecture Summary

```
Request Flow:
1. Browser sends JSON to /api/chatbot/message
   ↓
2. ChatBotController servlet receives
   ↓
3. Parse JSON using Gson
   ↓
4. ChatBotService processes intent
   ↓
5. ChatProductDAO/ShippingDAO get data
   ↓
6. Return ChatResponse as JSON
   ↓
7. Browser displays in widget UI
```

---

## 📁 Important Files Location

| File | Path |
|------|------|
| WAR File | `target/MobileStore.war` |
| ChatBot Controller | `src/main/java/.../springcontroller/ChatBotController.java` |
| ChatBot Service | `src/main/java/.../service/ChatBotService.java` |
| Product Data | `src/main/java/.../dao/ChatProductDAO.java` |
| CSS | `src/main/webapp/assets/css/chatbot.css` |
| JavaScript | `src/main/webapp/assets/js/chatbot.js` |
| HTML Widget | `src/main/webapp/chatbot.html` |
| Demo Page | `src/main/webapp/chatbot-demo.html` |

---

## ✨ Features Recap

✅ **6 Core Features:**
1. Product recommendation
2. Product comparison
3. Price/stock checking
4. Shipping information
5. Promotion details
6. Technical FAQ

✅ **5 Sample Products:**
- iPhone 15 Pro
- Samsung S24 Ultra
- Xiaomi 14T Pro
- OPPO Reno 11 Pro
- Nothing Phone 2

✅ **Complete Documentation:**
- CHATBOT_README.md
- CHATBOT_QUICK_START.md
- CHATBOT_INTEGRATION.md
- Configuration: chatbot.properties

---

## 🎯 Next Steps

1. ✅ **Deploy:** Copy WAR to Tomcat & restart
2. ✅ **Test:** Visit chatbot-demo.html in browser
3. ✅ **Verify:** Send test messages via demo
4. ✅ **Integrate:** Add widget to main website
5. ✅ **Monitor:** Check browser console for errors

---

## 📞 Support Resources

| Resource | Location |
|----------|----------|
| Full Documentation | CHATBOT_README.md |
| Quick Start | CHATBOT_QUICK_START.md |
| Integration Guide | CHATBOT_INTEGRATION.md |
| Configuration | chatbot.properties |
| Demo Page | /MobileStore/chatbot-demo.html |

---

## 🎉 Success Checklist

- [x] Build Success (mvn clean install)
- [x] No compilation errors
- [x] All tests passed (19/19)
- [x] WAR file generated
- [x] Servlet configured correctly
- [ ] Tomcat deployed (Next step)
- [ ] Chatbot accessible in browser (Next step)
- [ ] API responding correctly (Next step)

---

**You're ready to deploy! 🚀**

Next: Copy MobileStore.war to Tomcat and restart!
