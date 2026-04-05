# 🤖 HƯỚNG DẪN CHATBOT - MOBILESTORE

## 📋 MỤC LỤC
1. [Giới Thiệu](#giới-thiệu)
2. [Tính Năng Chính](#tính-năng-chính)
3. [Kiến Trúc Hệ Thống](#kiến-trúc-hệ-thống)
4. [Cài Đặt & Sử Dụng](#cài-đặt--sử-dụng)
5. [API Documentation](#api-documentation)
6. [Ví Dụ Sử Dụng](#ví-dụ-sử-dụng)
7. [Troubleshooting](#troubleshooting)
8. [Lộ Trình Nâng Cấp](#lộ-trình-nâng-cấp)

---

## 📖 Giới Thiệu

**MobileStore ChatBot** là một trợ lý bán hàng ảo (Virtual Sales Assistant) được thiết kế để:
- 💬 Tư vấn sản phẩm theo nhu cầu khách hàng
- 🔍 So sánh thông số kỹ thuật giữa các sản phẩm
- 💰 Kiểm tra giá, khuyến mãi và tồn kho
- 📦 Cung cấp thông tin vận chuyển
- ❓ Trả lời các câu hỏi kỹ thuật cơ bản
- 🎁 Giới thiệu các chương trình ưu đãi

### Công Nghệ Sử Dụng
- **Backend:** Java Spring Boot
- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Database:** Sample Data (In-Memory) - có thể mở rộng thành MySQL/PostgreSQL
- **API:** RESTful JSON
- **Deployment:** Tomcat / Spring Boot Embedded Server

---

## ✨ Tính Năng Chính

### 1. **Tư Vấn Sản Phẩm** 🎯
```
User: "Tư vấn giúp tôi với ngân sách 10 triệu"
Bot: Gợi ý 3-5 sản phẩm phù hợp với:
     - Thông số kỹ thuật chi tiết
     - Giá và chiết khấu hiện tại
     - Tình trạng kho hàng
     - Mô tả sản phẩm ngắn gọn
```

### 2. **So Sánh Sản Phẩm** 📊
```
User: "So sánh iPhone 15 và Samsung S24"
Bot: Hiển thị bảng so sánh:
     ✓ Giá
     ✓ CPU & Performance
     ✓ RAM & Storage
     ✓ Battery
     ✓ Camera
     ✓ Display
     ✓ Features
```

### 3. **Kiểm Tra Giá & Kho** 💰
```
User: "Giá iPhone 15 bao nhiêu?"
Bot: Hiển thị:
     - Giá gốc
     - Giá ưu đãi (nếu có)
     - Phần trăm giảm
     - Tình trạng tồn kho
```

### 4. **Vận Chuyển & Hỗ Trợ** 📦
```
User: "Phí vận chuyển bao nhiêu?"
Bot: Ước tính phí theo khu vực:
     - Hà Nội / TP.HCM: Miễn phí
     - Miền Bắc/Nam: 30,000 ₫
     - Miền Trung: 40,000 ₫
```

### 5. **Hỏi Đáp Kỹ Thuật** ❓
```
Keywords được hỗ trợ:
- "Chống nước" → IP68 Info
- "Sạc nhanh" → Charging Speeds
- "Camera" → Camera Info
- "Pin" → Battery Info
- "RAM" → Memory Info
```

### 6. **Khuyến Mãi & Combo** 🎉
```
Chương trình hiện tại:
✓ Trả góp 0% (12 tháng)
✓ Thu cũ - Đổi mới
✓ Combo tiết kiệm (điện thoại + phụ kiện)
✓ Ưu đãi thành viên (5-10% giảm)
```

---

## 🏗️ Kiến Trúc Hệ Thống

### Backend Structure
```
com.mobilestore/
├── model/
│   ├── ChatMessage.java           # Tin nhắn chat
│   ├── ChatRequest.java           # Yêu cầu từ user
│   ├── ChatResponse.java          # Phản hồi từ bot
│   ├── ChatProductSpec.java       # Thông số sản phẩm
│   └── ShippingInfo.java          # Thông tin vận chuyển
│
├── dao/
│   ├── ChatProductDAO.java        # Dữ liệu sản phẩm
│   └── ShippingDAO.java           # Dữ liệu vận chuyển
│
├── service/
│   └── ChatBotService.java        # Logic chính của bot
│
└── springcontroller/
    └── ChatBotController.java     # REST endpoints
```

### Frontend Structure
```
webapp/
├── chatbot.html               # HTML widget
├── chatbot-demo.html          # Demo & documentation
├── assets/
│   ├── css/
│   │   └── chatbot.css        # Styling
│   └── js/
│       └── chatbot.js         # Functionality
```

### Data Flow
```
User Input (Frontend)
        ↓
chatbot.js (Send Request)
        ↓
ChatBotController.java (/api/chatbot/message)
        ↓
ChatBotService.java (Process Intent)
        ↓
ChatProductDAO / ShippingDAO (Get Data)
        ↓
ChatResponse (Format Response)
        ↓
Frontend (Display)
```

---

## 🚀 Cài Đặt & Sử Dụng

### Bước 1: Copy Files
```bash
# Copy tất cả files vào dự án J2EE_MobileStore
src/main/java/com/mobilestore/model/ChatMessage.java
src/main/java/com/mobilestore/model/ChatRequest.java
src/main/java/com/mobilestore/model/ChatResponse.java
src/main/java/com/mobilestore/model/ChatProductSpec.java
src/main/java/com/mobilestore/model/ShippingInfo.java
src/main/java/com/mobilestore/dao/ChatProductDAO.java
src/main/java/com/mobilestore/dao/ShippingDAO.java
src/main/java/com/mobilestore/service/ChatBotService.java
src/main/java/com/mobilestore/springcontroller/ChatBotController.java
src/main/webapp/chatbot.html
src/main/webapp/chatbot-demo.html
src/main/webapp/assets/css/chatbot.css
src/main/webapp/assets/js/chatbot.js
```

### Bước 2: Build Project
```bash
# Maven
mvn clean install
mvn spring-boot:run

# hoặc Gradle
gradle build
gradle bootRun
```

### Bước 3: Test API
```bash
# Build first
mvn clean install

# Health check
curl http://localhost:8080/MobileStore/api/chatbot/health

# Send message
curl -X POST http://localhost:8080/MobileStore/api/chatbot/message \
  -H "Content-Type: application/json" \
  -d '{"userMessage":"Xin chào"}'
```

### Bước 4: Tích Hợp vào Website
```html
<!-- Include CSS -->
<link rel="stylesheet" href="assets/css/chatbot.css">

<!-- Include Widget HTML -->
<div id="chatbot-widget" class="chatbot-container">
  <!-- Nội dung từ chatbot.html -->
</div>

<!-- Include JavaScript -->
<script src="assets/js/chatbot.js"></script>
```

---

## 📡 API Documentation

### Endpoint: POST /api/chatbot/message

**Request:**
```json
{
  "userMessage": "Tư vấn giúp tôi với ngân sách 10 triệu",
  "userId": "user_12345"  // optional
}
```

**Response:**
```json
{
  "message": "Dựa trên ngân sách của bạn, tôi gợi ý 3-5 sản phẩm tốt nhất: ...",
  "responseType": "PRODUCT_LIST",
  "products": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "brand": "Apple",
      "price": 24990000,
      "discountedPrice": 23990000,
      "cpu": "Apple A17 Pro",
      "ram": 8,
      "storage": 256,
      "battery": 3200,
      "frontCamera": "12MP",
      "rearCamera": "48MP + 12MP + 12MP",
      "colors": "Đen, Trắng, Xanh, Vàng",
      "stock": 15,
      "description": "Flagship Apple với công nghệ A17 Pro...",
      "rating": 4.8
    }
  ],
  "suggestedQuestions": [
    "So sánh giữa các sản phẩm này",
    "Có combo nào không?",
    "Phí vận chuyển là bao nhiêu?"
  ],
  "timestamp": "14:30:45"
}
```

### Response Types
| Type | Purpose |
|------|---------|
| TEXT | Simple text response |
| PRODUCT_LIST | Product recommendations |
| COMPARISON | Product comparison table |
| COMBO | Bundle/combo suggestions |
| ORDER_INFO | Order status info |
| ERROR | Error message |

### Other Endpoints

**GET /api/chatbot/health**
- Check if API is running
- Response: `"Chatbot API is running!"`

**GET /api/chatbot/greeting**
- Get initial greeting message
- Response: ChatResponse object

---

## 💬 Ví Dụ Sử Dụng

### Ví Dụ 1: Tư Vấn Theo Ngân Sách
```
User: "Tôi có 15 triệu, muốn mua iPhone hoặc Samsung"
Bot: Dựa trên yêu cầu của anh/chị:
     1. iPhone 15 Pro - 23,990,000 ₫
     2. Samsung S24 Ultra - 22,490,000 ₫
     
     Anh/chị cần tư vấn thêm sản phẩm nào khác không ạ?
```

### Ví Dụ 2: So Sánh Chi Tiết
```
User: "So sánh Xiaomi 14T và Nothing Phone 2"
Bot: [Hiển thị bảng so sánh]
     Khuyến cáo:
     - Xiaomi 14T: Tốt cho game, có sạc nhanh 120W
     - Nothing Phone 2: Thiết kế độc đáo, giá rẻ hơn
```

### Ví Dụ 3: Hỏi Đáp Kỹ Thuật
```
User: "Có chống nước không? Sạc nhanh bao nhiêu?"
Bot: IP68 là tiêu chuẩn chống nước cao nhất:
     - Chịu được ngâm nước sâu 1.5m trong 30 phút
     
     Sạc nhanh: 20W-120W tùy model
     - iPhone: 20W
     - Samsung: 45W
     - Xiaomi: 120W
```

---

## 🔧 Troubleshooting

### Issue 1: CORS Error
```
Error: Cross-Origin Request Blocked
Solution: 
- Bot đã enable CORS: @CrossOrigin(origins = "*")
- Hoặc configure CORS filter trong Spring
```

### Issue 2: API Not Responding
```
Check:
1. Spring Boot server đang chạy?
2. Port 8080 có bị chiếm không?
3. API URL đúng không?

Fix:
mvn spring-boot:run
curl http://localhost:8080/api/chatbot/health
```

### Issue 3: Error 404
```
Issue: Endpoint not found
Fix:
- Kiểm tra URL path
- Kiểm tra @RequestMapping annotation
- Spring context load đầy đủ?
```

### Issue 4: JSON Parse Error
```
Check:
1. JSON format đúng?
2. Charset UTF-8?
3. Field name match?
```

---

## 🚀 Lộ Trình Nâng Cấp

### Phase 1: Cơ Bản (Hiện Tại) ✅
- [x] Intent detection
- [x] Product recommendation
- [x] Price/stock checking
- [x] Comparison
- [x] FAQ handling

### Phase 2: Tích Hợp Database (3-4 tuần) 📅
- [ ] MySQL/PostgreSQL integration
- [ ] Real-time product sync
- [ ] User session management
- [ ] Chat history storage

### Phase 3: AI & NLP (4-6 tuần) 🤖
- [ ] OpenAI/Gemini API integration
- [ ] Natural language understanding
- [ ] Sentiment analysis
- [ ] Personalization

### Phase 4: E-Commerce (6-8 tuần) 🛒
- [ ] Order placement
- [ ] Payment integration (VNPAY, Momo)
- [ ] Order tracking
- [ ] Inventory management

### Phase 5: Analytics & ML (8-10 tuần) 📊
- [ ] User behavior tracking
- [ ] Conversation analytics
- [ ] Recommendation engine
- [ ] A/B testing

### Phase 6: Mobile & Multi-language (10-12 tuần) 📱
- [ ] Native mobile app
- [ ] Push notifications
- [ ] Multi-language support
- [ ] Offline mode

---

## 📞 Support & Contact

| Channel | Info |
|---------|------|
| 📧 Email | support@mobilestore.vn |
| 📱 Hotline | 1900 xxxx |
| 💬 Chat | Qua bot trên website |
| 🌐 Website | mobilestore.vn |
| 📚 Documentation | /chatbot-demo.html |

---

## 📄 License & Version

- **Version:** 1.0
- **Last Updated:** April 2024
- **Author:** MobileStore Dev Team
- **License:** Private - For MobileStore Use Only

---

## 🎯 Key Points to Remember

1. ✅ Bot chỉ tư vấn, không lập đơn hàng trực tiếp
2. ✅ Luôn kết thúc bằng câu hỏi mở
3. ✅ Không bao giờ tự ý thay đổi giá
4. ✅ Nếu không biết → hướng dẫn liên hệ CSKH
5. ✅ Giọng điệu: Thân thiện, chuyên nghiệp, trẻ trung

---

**💡 Tip:** Demo đầy đủ tại `/chatbot-demo.html`

Chúc bạn sử dụng vui vẻ! 🎉
