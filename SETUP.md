# 🎉 Setup Instructions - Mobile Store

## Bước 1: Setup Database

### 1.1 Tạo Database
```bash
# Mở MySQL
mysql -u root -p

# Tạo database
CREATE DATABASE mobilestore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Thoát
exit;
```

### 1.2 Import Schema
```bash
# Import file schema.sql
mysql -u root -p mobilestore_db < database/schema.sql
```

### 1.3 Cấu hình Database Connection
Mở file `src/main/java/com/mobilestore/util/DBConnection.java` và cập nhật:
```java
private static final String PASSWORD = "your_mysql_password";  // Đổi password
```

---

## Bước 2: Build Project

### 2.1 Download Dependencies
```bash
mvn clean install
```

Hoặc trong IntelliJ IDEA:
- Click phải vào `pom.xml` → **Maven** → **Reload Project**

---

## Bước 3: Run Application

### Option A: IntelliJ IDEA (Khuyến nghị)

1. **Add Tomcat Configuration:**
   - Run → Edit Configurations
   - Click "+" → Tomcat Server → Local
   - Chọn Tomcat installation directory
   - Tab **Deployment** → Click "+" → Artifact → `MobileStore:war exploded`
   - **Application context:** `/MobileStore`
   - Click **OK**

2. **Run:**
   - Click nút **Run** (Shift + F10)
   - Trình duyệt tự động mở: `http://localhost:8080/MobileStore`

### Option B: Command Line

```bash
# Run với Maven Tomcat plugin
mvn tomcat7:run

# Hoặc package và deploy thủ công
mvn clean package
# Copy file target/MobileStore.war vào thư mục webapps của Tomcat
```

---

## Bước 4: Test Application

### 4.1 Truy cập ứng dụng
```
http://localhost:8080/MobileStore
```

### 4.2 Login Admin
- URL: `http://localhost:8080/MobileStore/login`
- Username: `admin`
- Password: `admin123`

### 4.3 Test các chức năng
- ✅ Xem danh sách sản phẩm: `/products`
- ✅ Chi tiết sản phẩm: `/products?action=detail&id=1`
- ✅ Tìm kiếm: `/products?action=search&keyword=iphone`
- ✅ Admin - Quản lý sản phẩm: `/admin/products`

---

## Bước 5: Common Issues & Solutions

### Issue 1: Database Connection Failed
```
✗ Error: Communications link failure
```
**Solution:**
- Check MySQL service đang chạy
- Verify username/password trong `DBConnection.java`
- Check port MySQL (default: 3306)

### Issue 2: 404 Not Found
```
✗ HTTP Status 404 – Not Found
```
**Solution:**
- Check Application context: `/MobileStore`
- Verify Tomcat đã deploy WAR file
- Check web.xml configuration

### Issue 3: JSP Not Found
```
✗ /WEB-INF/views/product/list.jsp not found
```
**Solution:**
- Check file path đúng trong servlet
- Verify JSP files tồn tại trong `/WEB-INF/views/`

### Issue 4: ClassNotFoundException
```
✗ com.mysql.cj.jdbc.Driver not found
```
**Solution:**
```bash
# Reload Maven dependencies
mvn clean install -U
```

---

## Project Structure Check

Verify your project has this structure:

```
✅ database/schema.sql
✅ src/main/java/com/mobilestore/
    ✅ controller/
    ✅ dao/
    ✅ filter/
    ✅ listener/
    ✅ model/
    ✅ service/
    ✅ util/
✅ src/main/webapp/
    ✅ WEB-INF/web.xml
    ✅ WEB-INF/views/
    ✅ assets/css/
    ✅ assets/js/
✅ pom.xml
```

---

## Next Steps

Sau khi Product Module chạy thành công, implement các module tiếp theo:

1. **Authentication Module** (Login/Logout)
2. **Order & Cart Module**
3. **Customer Module**
4. **Reports Module**

---

## Support

Nếu gặp vấn đề, check:
1. Console logs trong IntelliJ/Terminal
2. Tomcat logs: `logs/catalina.out`
3. Browser Developer Console (F12)

**Happy Coding! 🚀**
