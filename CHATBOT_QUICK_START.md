## 🚀 QUICK START - CHATBOT SETUP GUIDE

Hướng dẫn nhanh để chạy Chatbot trong 5 phút!

---

### ✅ Điều Kiện Tiên Quyết

- Java 8+ hoặc Java 11
- Maven 3.6+
- Spring Boot 2.5+
- Modern Browser (Chrome, Firefox, Safari, Edge)

---

### 🔧 Bước 1: Kiểm Tra/Copy Files

Đảm bảo tất cả files sau đã được copy vào đúng thư mục:

```
✓ src/main/java/com/mobilestore/model/
  - ChatMessage.java
  - ChatRequest.java
  - ChatResponse.java
  - ChatProductSpec.java
  - ShippingInfo.java

✓ src/main/java/com/mobilestore/dao/
  - ChatProductDAO.java
  - ShippingDAO.java

✓ src/main/java/com/mobilestore/service/
  - ChatBotService.java

✓ src/main/java/com/mobilestore/springcontroller/
  - ChatBotController.java

✓ src/main/webapp/
  - chatbot.html
  - chatbot-demo.html

✓ src/main/webapp/assets/css/
  - chatbot.css

✓ src/main/webapp/assets/js/
  - chatbot.js

✓ Root directory
  - CHATBOT_README.md
  - chatbot.properties
  - CHATBOT_QUICK_START.md (this file)
```

---

### 🏗️ Bước 2: Build Project

#### Dùng Maven:
```bash
cd c:\Users\hatha\J2EE_MobileStore

# Clean and build
mvn clean install

# Hoặc chỉ compile
mvn clean compile
```

#### Dùng IDE (Eclipse/IntelliJ):
```
1. Right-click on project
2. Select "Maven" → "Update Project"
3. Select "Maven" → "Run As" → "Maven Build"
4. Input: clean install
```

---

### 🚀 Bước 3: Chạy Server

#### Option A: Deploy lên Tomcat
```bash
# WAR file đã được tạo tại:
C:\Users\hatha\J2EE_MobileStore\target\MobileStore.war

# Copy vào Tomcat
cp target/MobileStore.war $TOMCAT_HOME/webapps/

# Restart Tomcat
$TOMCAT_HOME/bin/startup.bat

# Access: http://localhost:8080/MobileStore
```

#### Option B: Chạy với Maven Plugin
```bash
mvn tomcat7:run
# Hoặc
mvn tomcat7:run-war
```

**Kết quả thành công:**
```
[INFO] Building MobileStore 1.0-SNAPSHOT
...
[INFO] Tests run: 19, Failures: 0, Errors: 0, Skipped: 0
[INFO] Building war: C:\Users\hatha\J2EE_MobileStore\target\MobileStore.war     
[INFO] BUILD SUCCESS
```

Sau đó Tomcat startup message:
```
INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 2500 ms
```

---

### ✅ Bước 4: Test Backend API

Mở terminal/PowerShell và test API:

```bash
# 1. Health check
curl http://localhost:8080/MobileStore/api/chatbot/health

# 2. Get greeting
curl http://localhost:8080/MobileStore/api/chatbot/greeting

# 3. Send message
curl -X POST http://localhost:8080/MobileStore/api/chatbot/message ^
  -H "Content-Type: application/json" ^
  -d "{\"userMessage\":\"Xin chào\"}"
```

**Nếu bạn dùng PowerShell:**
```powershell
# Health check
Invoke-WebRequest -Uri "http://localhost:8080/MobileStore/api/chatbot/health"

# Send message
$body = @{
    userMessage = "Xin chào"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8080/MobileStore/api/chatbot/message" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

---

### 🌐 Bước 5: Truy Cập Chatbot UI

#### Option A: Demo Page (Full Documentation)
```
URL: http://localhost:8080/MobileStore/chatbot-demo.html

Trang này chứa:
- Ví dụ hội thoại
- Danh sách FAQs
- Hướng dẫn tích hợp
- Chi tiết kiến trúc
- Lộ trình nâng cấp
```

#### Option B: Standalone Widget
```
URL: http://localhost:8080/MobileStore/chatbot.html

Trang widget chatbot đơn giản
```

#### Option C: Tích Hợp vào Website
```html
<!-- Thêm vào bất kỳ HTML page nào -->
<link rel="stylesheet" href="assets/css/chatbot.css">

<!-- Widget HTML -->
<div id="chatbot-widget" class="chatbot-container">
  <!-- Copy nội dung từ chatbot.html -->
</div>

<!-- Script -->
<script src="assets/js/chatbot.js"></script>
<script>
  // Configure API endpoint for your context path
  const CHATBOT_API = '/MobileStore/api/chatbot';
</script>
```

---

### 🧪 Bước 6: Test Chatbot (Recommended Messages)

Thử các tin nhắn này để kiểm tra từng tính năng:

#### 1️⃣ Greeting
```
Message: "Xin chào"
Response: Lời chào + các option gợi ý
```

#### 2️⃣ Product Recommendation
```
Message: "Tư vấn giúp tôi với ngân sách 10 triệu"
Response: Danh sách 3-5 sản phẩm phù hợp
```

#### 3️⃣ Brand Search
```
Message: "Tôi muốn mua iPhone"
Response: Danh sách iPhone có sẵn
```

#### 4️⃣ Comparison
```
Message: "So sánh iPhone 15 và Samsung S24"
Response: Bảng so sánh chi tiết
```

#### 5️⃣ Price Check
```
Message: "Giá của các sản phẩm bao nhiêu?"
Response: Bảng giá tất cả sản phẩm
```

#### 6️⃣ Stock Check
```
Message: "Còn hàng không?"
Response: Tình trạng tồn kho của tất cả sản phẩm
```

#### 7️⃣ Shipping Info
```
Message: "Phí vận chuyển là bao nhiêu?"
Response: Phí vận chuyển theo khu vực
```

#### 8️⃣ Promotion
```
Message: "Có khuyến mãi nào không?"
Response: Chi tiết các chương trình ưu đãi
```

#### 9️⃣ Technical FAQ
```
Message: "Chống nước IP68 là gì?"
Message: "Sạc nhanh bao nhiêu W?"
Message: "Pin bao nhiêu mAh?"
Response: Thông tin kỹ thuật chi tiết
```

---

### ⚙️ Configuration (Optional)

Nếu cần thay đổi cấu hình:

```bash
# 1. Mở file: chatbot.properties
# 2. Cập nhật settings

# Ví dụ:
chatbot.response.max-products-to-show=10
chatbot.response.typing-delay-ms=1000

# 3. Build lại
mvn clean install
```

---

### 🔌 Tích Hợp vào JSP/HTML (Main Website)

Thêm vào `index.jsp` hoặc trang chính:

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MobileStore</title>
    
    <!-- Chatbot CSS -->
    <link rel="stylesheet" href="assets/css/chatbot.css">
</head>
<body>
    <!-- Main website content -->
    <div id="main-content">
        <!-- Your website content here -->
    </div>

    <!-- Chatbot Widget -->
    <div id="chatbot-widget" class="chatbot-container">
        <!-- Widget HTML from chatbot.html -->
    </div>

    <!-- Chatbot JavaScript -->
    <script src="assets/js/chatbot.js"></script>
    <script>
        // Optional: Initialize with custom settings
        const CHATBOT_API = '<%= request.getContextPath() %>/api/chatbot';
    </script>
</body>
</html>
```

---

### 🛠️ Troubleshooting

#### ❌ Problem: Port 8080 đang sử dụng

**Solution:**
```bash
# Change port in application.properties
server.port=8888

# Hoặc kill process chiếm port 8080
taskkill /PID <pid> /F  # Windows

# Check nào chiếm port
netstat -ano | findstr :8080  # Windows
```

#### ❌ Problem: CORS Error trong Browser

**Solution:**
```
Error: Cross-Origin Request Blocked

Fix: CORS đã enable trong ChatBotController
Kiểm tra: @CrossOrigin(origins = "*")
```

#### ❌ Problem: Maven không tìm được dependency

**Solution:**
```bash
# Delete .m2 cache
rmdir /s "%USERPROFILE%\.m2\repository\com\mobilestore"

# Rebuild
mvn clean install -U
```

#### ❌ Problem: API trả về 404

**Solution:**
```
1. Kiểm tra URL: http://localhost:8080/api/chatbot/message
2. Kiểm tra Spring Boot log có error?
3. Kiểm tra @Controller annotation?
4. Kiểm tra @RequestMapping path?
```

---

### 📊 Project Structure (sau khi setup)

```
J2EE_MobileStore/
├── src/
│   ├── main/
│   │   ├── java/com/mobilestore/
│   │   │   ├── model/
│   │   │   │   ├── ChatMessage.java
│   │   │   │   ├── ChatRequest.java
│   │   │   │   ├── ChatResponse.java
│   │   │   │   ├── ChatProductSpec.java
│   │   │   │   └── ShippingInfo.java
│   │   │   ├── dao/
│   │   │   │   ├── ChatProductDAO.java
│   │   │   │   └── ShippingDAO.java
│   │   │   ├── service/
│   │   │   │   └── ChatBotService.java
│   │   │   └── springcontroller/
│   │   │       └── ChatBotController.java
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/
│   │       ├── chatbot.html
│   │       ├── chatbot-demo.html
│   │       ├── assets/
│   │       │   ├── css/chatbot.css
│   │       │   └── js/chatbot.js
│   │       └── WEB-INF/web.xml
│   └── test/
├── pom.xml
├── CHATBOT_README.md
├── chatbot.properties
├── CHATBOT_QUICK_START.md
└── target/ (sau build)
```

---

### 📈 Performance Tips

1. **Enable Compression:**
```properties
server.compression.enabled=true
server.compression.min-response-size=1024
```

2. **Cache Responses:**
```properties
chatbot.cache.enabled=true
chatbot.cache.ttl-minutes=30
```

3. **Connection Pool:**
```properties
spring.datasource.hikari.maximum-pool-size=20
```

---

### 🚀 Next Steps (sau khi chạy thành công)

1. ✅ **Setup Database:** Kết nối MySQL/PostgreSQL
2. ✅ **Integrate Payment:** VNPAY, Momo
3. ✅ **AI Enhancement:** OpenAI API
4. ✅ **Mobile App:** React Native hoặc Flutter
5. ✅ **Analytics:** Google Analytics, Mixpanel

---

### 📞 Support

- 📧 Email: support@mobilestore.vn
- 📖 Full Doc: CHATBOT_README.md
- 🌐 Demo: http://localhost:8080/chatbot-demo.html

---

## ✨ Chúc mừng! Bạn đã setup hành công! 🎉

Bot của bạn bây giờ đã sẵn sàng phục vụ khách hàng 24/7!

**Tiếp theo:** Truy cập `/chatbot-demo.html` để xem tất cả tính năng.
