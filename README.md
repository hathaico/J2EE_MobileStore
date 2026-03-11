# 🏪 Mobile Store - Hệ Thống Quản Lý Cửa Hàng Điện Thoại

Đồ án môn **Phát Triển Ứng Dụng với J2EE**

## 📋 Mô Tả Dự Án

Mobile Store là một hệ thống quản lý cửa hàng điện thoại hoàn chỉnh được xây dựng bằng J2EE (Java Enterprise Edition), sử dụng kiến trúc MVC với Servlet, JSP, và MySQL.

### Tính Năng Chính

#### 🔐 **Xác Thực & Bảo Mật**
- ✅ Đăng nhập/Đăng xuất với BCrypt password hashing
- ✅ Session management với timeout tự động
- ✅ Remember me functionality
- ✅ Authentication Filter bảo vệ admin routes
- ✅ Role-based access control (ADMIN/STAFF)
- ✅ Redirect to login với return URL

#### 📦 **Quản Lý Sản Phẩm**
- ✅ CRUD đầy đủ cho sản phẩm
- ✅ Upload và quản lý ảnh sản phẩm
- ✅ Quản lý danh mục sản phẩm
- ✅ Theo dõi tồn kho (stock quantity)
- ✅ Cảnh báo sản phẩm sắp hết hàng
- ✅ Active/Inactive products

#### 🛒 **Giỏ Hàng**
- ✅ Session-based shopping cart
- ✅ AJAX add to cart không reload trang
- ✅ Cập nhật số lượng real-time
- ✅ Kiểm tra tồn kho trước khi thêm
- ✅ Cart count badge trên header
- ✅ Refresh cart data trước checkout

#### 💳 **Đơn Hàng & Thanh Toán**
- ✅ Checkout flow hoàn chỉnh
- ✅ Nhiều phương thức thanh toán (COD/Bank Transfer/Credit Card)
- ✅ Order status tracking (PENDING → CONFIRMED → SHIPPING → DELIVERED)
- ✅ Payment status management (UNPAID/PAID)
- ✅ Order confirmation page
- ✅ Tự động cập nhật stock sau đặt hàng
- ✅ Hoàn stock khi hủy đơn

#### 📊 **Admin Dashboard**
- ✅ Thống kê tổng quan (sản phẩm, đơn hàng, doanh thu)
- ✅ Thống kê theo ngày (hôm nay)
- ✅ Breakdown đơn hàng theo status
- ✅ Danh sách đơn hàng gần đây
- ✅ Cảnh báo sản phẩm sắp hết/hết hàng
- ✅ Quick actions cho các tác vụ thường dùng

#### 🔧 **Quản Lý Admin**
- ✅ Quản lý đơn hàng với filter theo status
- ✅ Chi tiết đơn hàng với order items
- ✅ Cập nhật trạng thái đơn hàng
- ✅ Cập nhật trạng thái thanh toán
- ✅ Xem lịch sử đơn hàng

## 🛠️ Công Nghệ Sử Dụng

### Backend
- **Java 11** - Platform chính
- **Servlet 4.0 & JSP 2.3** - Web framework
- **JDBC 8.0.33** - Database connectivity (MySQL Connector)
- **JSTL 1.2** - JSP Standard Tag Library
- **jBCrypt 0.4** - Password hashing
- **Gson 2.10.1** - JSON serialization cho AJAX

### Frontend
- **JSP & JSTL** - Server-side rendering
- **Bootstrap 5.1.3** - Responsive UI framework
- **Bootstrap Icons 1.8.0** - Icon library
- **JavaScript ES6+** - Client-side logic
- **Fetch API** - AJAX requests

### Database
- **MySQL 8.0** - Relational database
- **PreparedStatement** - SQL injection prevention

### Build Tool
- **Maven 3.x** - Dependency management & build automation

### Server
- **Apache Tomcat 9.x/10.x** - Servlet container

## 📁 Cấu Trúc Project

```
MobileStore/
├── src/
│   ├── main/
│   │   ├── java/com/mobilestore/
│   │   │   ├── controller/      # Servlet controllers
│   │   │   ├── dao/             # Data Access Objects
│   │   │   ├── filter/          # Servlet filters
│   │   │   ├── listener/        # Application listeners
│   │   │   ├── model/           # Entity classes
│   │   │   ├── service/         # Business logic
│   │   │   └── util/            # Utility classes
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/       # JSP pages
│   │       │   └── web.xml      # Deployment descriptor
│   │       └── assets/
│   │           ├── css/         # Stylesheets
│   │           └── js/          # JavaScript files
│   │
│   └── test/                    # Unit tests
│
├── database/
│   └── schema.sql               # Database schema
│
├── pom.xml                      # Maven configuration
└── README.md                    # This file
```

## 🚀 Hướng Dẫn Cài Đặt

### 1. Yêu Cầu Hệ Thống

- JDK 11 hoặc cao hơn
- Apache Tomcat 9.x hoặc 10.x
- MySQL 8.0 hoặc cao hơn
- Maven 3.6+

### 2. Clone Project

```bash
git clone <repository-url>
cd MobileStore
```

### 3. Cấu Hình Database

#### Bước 1: Tạo database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE mobilestore_db;
```

#### Bước 2: Import schema

```bash
mysql -u root -p mobilestore_db < database/schema.sql
```

#### Bước 3: Cấu hình kết nối

Mở file `src/main/java/com/mobilestore/util/DBConnection.java` và cập nhật thông tin:

```java
private static final String URL = "jdbc:mysql://localhost:3306/mobilestore_db";
private static final String USER = "root";  // Thay đổi username
private static final String PASSWORD = "password";  // Thay đổi password
```

### 4. Build Project

```bash
mvn clean install
```

### 5. Deploy lên Tomcat

#### Cách 1: Manual Deploy
1. Copy file `target/MobileStore.war` vào thư mục `webapps` của Tomcat
2. Start Tomcat server
3. Truy cập: `http://localhost:8080/MobileStore`

#### Cách 2: IntelliJ IDEA
1. **Add Configuration** → **Tomcat Server** → **Local**
2. Chọn Tomcat installation directory
3. Add **Deployment** → **Artifact** → `MobileStore:war exploded`
4. Click **Run**

#### Cách 3: Maven Plugin
```bash
mvn tomcat7:run
```

## 👥 Tài Khoản Mặc Định

> **Lưu ý**: Tài khoản được tạo sẵn trong database schema

### Admin
- **Username**: `admin`
- **Password**: `admin123`
- **Role**: ADMIN (full access)

### Staff
- **Username**: `staff`
- **Password**: `staff123`
- **🔐 Authentication
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/login` | Hiển thị form đăng nhập | Public |
| POST | `/login` | Xử lý đăng nhập | Public |
| GET | `/logout` | Đăng xuất và xóa session | Authenticated |

### 📦 Products (Public)
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/products` | Danh sách sản phẩm | Public |
| GET | `/products?action=detail&id={id}` | Chi tiết sản phẩm | Public |

### 🛒 Shopping Cart
| Method | Endpoint | Description | Returns |
|--------|----------|-------------|---------|
| GET | `/cart` | Hiển thị giỏ hàng | JSP page |
| GET | `/cart?action=count` | Lấy số lượng items | JSON |
| GET | `/cart?action=data` | Lấy dữ liệu cart | JSON |
| POST | `/cart?action=add` | Thêm sản phẩm vào giỏ | JSON |
| POST | `/cart?action=update` | Cập nhật số lượng | JSON |
| POST | `/cart?action=remove` | Xóa item khỏi giỏ | JSON |
| POST | `/cart?action=clear` | Xóa toàn bộ giỏ hàng | JSON |

**AJAX Response Format**:
```json
{
  "success": true,
  "message": "Thêm vào giỏ hàng thành công",
  "cartCount": 3
}
```

### 💳 Checkout & Orders
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/checkout` | Form thanh toán | Authenticated |
| POST | `/checkout` | Xử lý đặt hàng | Authenticated |
| GET | `/checkout/success?orderId={id}` | Xác nhận đơn hàng | Authenticated |

### 🔧 Admin - Products
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/admin/products` | Danh sách sản phẩm admin | Admin/Staff |
| GET | `/admin/products?action=add` | Form thêm sản phẩm | Admin/Staff |
| POST | `/admin/products?action=create` | Tạo sản phẩm mới | Admin/Staff |
| GET | `/admin/products?action=edit&id={id}` | Form sửa sản phẩm | Admin/Staff |
| POST | `/admin/products?action=update` | Cập nhật sản phẩm | Admin/Staff |
| POST | `/admin/products?action=delete&id={id}` | Xóa sản phẩm | Admin/Staff |

### 📊 Admin - Dashboard
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/admin/dashboard` | Trang thống kê tổng quan | Admin/Staff |

### 📋 Admin - Orders
| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/admin/orders` | Danh sách đơn hàng | Admin/Staff |
| GET | `/admin/orders?status={status}` | Filter theo status | Admin/Staff |
| GET | `/admin/orders?action=detail&id={id}` | Chi tiết đơn hàng | Admin/Staff |
| POST | `/admin/orders?action=updateStatus` | Cập nhật trạng thái đơn | Admin/Staff |
| POST | `/admin/orders?action=updatePayment` | Cập nhật trạng thái TT | Admin/Staff |oán
- `POST /checkout?action=place` - Đặt hàng

### Authentication
- `GET /login` - Trang đăng nhập
- `POST /login` - Xử lý đăng nhập
- `GET /logout` - Đăng xuất

## 🧪 Testing

Chạy unit tests:

```bash
mvn test
```

## 📊 Database Schema

[Xem file schema.sql đầy đủ](database/schema.sql)

### Các bảng chính:

#### 📂 `categories`
Danh mục sản phẩm (Smartphone, Tablet, Accessories, ...)
```sql
- category_id (PK)
- category_name
- description
- created_at, updated_at
```

#### 📦 `products`
Sản phẩm điện thoại
```sql
- product_id (PK)
- category_id (FK → categories)
- product_name
- description
- price, discount_percentage
- stock_quantity (inventory tracking)
- image_url
- is_active (soft delete)
- created_at, updated_at
```

#### 👤 `users`
Tài khoản admin và staff
```sql
- user_id (PK)
- username (UNIQUE)
- password_hash (BCrypt)
- full_name
- email (UNIQUE)
- role (ADMIN/STAFF)
- is_active
- created_at, updated_at
```

#### 📋 `orders`
Đơn hàng của khách hàng
```sql
- order_id (PK)
- customer_name, customer_phone, customer_email
- shipping_address
- total_amount
- status (PENDING/CONFIRMED/SHIPPING/DELIVERED/CANCELLED)
- payment_method (COD/BANK_TRANSFER/CREDIT_CARD)
- payment_status (UNPAID/PAID)
- notes
- created_at, updated_at
```

#### 📄 `order_items`
Chi tiết đơn hàng (line items)
```sql
- order_item_id (PK)
- order_id (FK → orders, CASCADE DELETE)
- product_id (FK → products)
- product_name (snapshot)
- price (snapshot)
- quantity
- subtotal
```

### Relationships:
- `products.category_id` → `categories.category_id` (Many-to-One)
- `orders` → `order_items` (One-to-Many, CASCADE DELETE)
- `order_items.product_id` → `products.product_id` (Many-to-One)

### Indexes:
- `categories(category_name)`
- `products(category_id, is_active)`
- `users(username, email)`
- `orders(status, created_at)`
- `order_items(order_id, product_id)`

## 🔒 Bảo Mật

- ✅ **Password Security**: BCrypt hashing với salt tự động
- ✅ **Authentication Filter**: Bảo vệ tất cả `/admin/*` routes
- ✅ **SQL Injection Prevention**: PreparedStatement cho tất cả queries
- ✅ **XSS Prevention**: Input sanitization và JSTL escaping
- ✅ **Session Management**: Timeout 30 phút, remember me 7 ngày
- ✅ **Role-Based Access**: Kiểm tra ADMIN/STAFF role trước khi cho phép
- ✅ **Redirect Protection**: URL encoding cho return URLs
- ✅ **Transaction Safety**: Rollback support cho critical operations

## 📖 User Workflows

### 🛍️ Customer Shopping Flow
```
1. Browse products → View product details
2. Add to cart (AJAX) → Cart count badge updates
3. View cart → Update quantities or remove items
4. Checkout → Fill shipping info + choose payment method
5. Place order → Stock auto-decreases
6. Order confirmation → View order details
```

### 👨‍💼 Admin Management Flow
```
1. Login with admin/staff account
2. Dashboard → View statistics (products, orders, revenue)
3. Manage Products:
   - Add/Edit/Delete products
   - Upload images
   - Track stock
4. Manage Orders:
   - View all orders (filter by status)
   - Update order status (PENDING → DELIVERED)
   - Update payment status
   - View order details
5. Alerts:
   - Low stock warnings
   - Pending orders count
```

## 🎨 Frontend Features

### Responsive Design
- ✅ Bootstrap 5 responsive grid system
- ✅ Mobile-friendly navigation
- ✅ Adaptive cards và tables

### User Experience
- ✅ Real-time cart updates without page reload
- ✅ Success/Error messages với Bootstrap alerts
- ✅ Loading states cho AJAX operations
- ✅ Empty state designs (empty cart, no orders)
- ✅ Badge indicators (cart count, order status)
- ✅ Icon library (Bootstrap Icons)

### Admin Interface
- ✅ Sidebar navigation
- ✅ Statistics cards với hover effects
- ✅ Color-coded status badges
- ✅ Quick action buttons
- ✅ Filterable tables

## 📝 TODO List

### Đã Hoàn Thành ✅
- [x] Authentication module (Login/Logout)
- [x] Session-based shopping cart với AJAX
- [x] Order checkout flow
- [x] Admin dashboard với statistics
- [x] Product management (CRUD)
- [x] Order management cho admin
- [x] Stock tracking và low stock alerts
- [x] Transaction support cho order creation
- [x] Role-based access control

### Đang Phát Triển 🚧
- [ ] Customer registration (hiện tại guest checkout)
- [ ] Customer order history tracking

### Tính Năng Tương Lai 💡
- [ ] Product search functionality
- [ ] Pagination cho danh sách sản phẩm
- [ ] Product filters (giá, brand, rating)
- [ ] Email notification cho đơn hàng
- [ ] Export báo cáo Excel/PDF
- [ ] Product reviews và ratings
- [ ] Forgot password feature
- [ ] Advanced analytics với charts (Chart.js)
- [ ] Wishlist functionality
- [ ] Coupon/Discount codes

## 🤝 Đóng Góp

Đây là project đồ án học tập về J2EE. Project bao gồm:
- ✅ Kiến trúc MVC chuẩn
- ✅ DAO pattern với BaseDAO
- ✅ Service layer cho business logic
- ✅ Filter và Listener
- ✅ Session management
- ✅ Transaction handling
- ✅ AJAX integration
- ✅ Responsive UI

## 🎓 Kiến Thức Áp Dụng

### J2EE Core
- Servlet lifecycle và request handling
- JSP với JSTL tags (c:forEach, c:if, fmt:formatNumber)
- Filter chain (EncodingFilter, AuthenticationFilter, CartCountFilter)
- Session management và attributes
- ServletContext và ServletConfig

### Design Patterns
- **MVC Pattern**: Tách biệt Model-View-Controller
- **DAO Pattern**: Data access abstraction với BaseDAO
- **Service Layer Pattern**: Business logic separation
- **Singleton Pattern**: DBConnection pool
- **Factory Pattern**: DAO creation

### Database
- JDBC Connection pooling
- PreparedStatement với parameter binding
- Transaction management (commit/rollback)
- Foreign key constraints
- Cascade delete operations

### Security
- Password hashing với BCrypt
- Session-based authentication
- Role-based authorization
- SQL injection prevention
- Input validation

## 📄 License

MIT License - Free to use for educational purposes

## 👨‍💻 Tác Giả

Project được phát triển như đồ án J2EE

---

**Chúc bạn làm đồ án thành công! 🎉**

**Nếu cần hỗ trợ:**
1. Kiểm tra logs trong Tomcat `logs/catalina.out`
2. Verify database connection trong DBConnection.java
3. Đảm bảo MySQL server đang chạy
4. Check context path trong web.xml và Tomcat configuration
