# 🚀 Quick Tomcat Setup Guide

Hướng dẫn này giúp bạn cài Tomcat nhanh chóng để chạy ChatBot!

---

## ⚡ Express Setup (5 phút)

### Bước 1: Download Tomcat 10.1
```powershell
# Tạo folder Tomcat
mkdir C:\tomcat-setup
cd C:\tomcat-setup

# Download Tomcat 10.1 (hoặc truy cập: https://tomcat.apache.org/download-10.cgi)
# Chọn: apache-tomcat-10.1.XX.zip

# Giải nén vào C:\apache-tomcat-10
# Hoặc dùng PowerShell:
Expand-Archive -Path apache-tomcat-10.1.XX.zip -DestinationPath C:\
Rename-Item C:\apache-tomcat-10.1.XX C:\apache-tomcat-10
```

### Bước 2: Set Environment Variable
```powershell
# Set TOMCAT_HOME permanently
[Environment]::SetEnvironmentVariable("TOMCAT_HOME", "C:\apache-tomcat-10", "User")

# Hoặc set tạm thời trong current PowerShell session:
$env:TOMCAT_HOME = "C:\apache-tomcat-10"
```

### Bước 3: Chạy Server
```bash
cd C:\Users\hatha\J2EE_MobileStore

# Cách 1: Dùng batch script
.\start-server.bat

# Hoặc Cách 2: Chạy Tomcat trực tiếp
C:\apache-tomcat-10\bin\startup.bat
```

### Bước 4: Deploy WAR
```powershell
# Copy WAR file vào Tomcat
copy target\MobileStore.war C:\apache-tomcat-10\webapps\

# Tomcat sẽ tự động extract và deploy
```

### Bước 5: Truy cập ChatBot
```
Mở browser:
http://localhost:8080/MobileStore/chatbot-demo.html
```

---

## 🔍 Verify Tomcat is Running

```powershell
# Check if Tomcat process exists
Get-Process | Where-Object {$_.ProcessName -like "*java*"}

# Or open browser:
http://localhost:8080/

# Should see Tomcat welcome page
```

---

## ❌ Troubleshooting

### Port 8080 đang bị sử dụng
```powershell
# Tìm process chiếm port 8080
netstat -ano | findstr :8080

# Kill process (nếu cần)
taskkill /PID <PID> /F
```

### Tomcat không start
```powershell
# Check Tomcat logs
cd C:\apache-tomcat-10\logs
# Mở file: catalina.out hoặc catalina.DATE.log
```

### WAR không deploy
```powershell
# Xóa MobileStore folder cũ (nếu có)
Remove-Item C:\apache-tomcat-10\webapps\MobileStore -Recurse -Force

# Copy WAR lại
copy target\MobileStore.war C:\apache-tomcat-10\webapps\

# Restart Tomcat
```

---

## 📦 Alternative: Chạy mà không cần cài Tomcat

Nếu bạn muốn avoid cài Tomcat, có 2 cách khác:

### A) Dùng Docker (Nếu có Docker)
```bash
# Tôi có thể tạo Dockerfile cho bạn
```

### B) Dùng Embedded Server (Tôi sẽ hướng dẫn)
```bash
# Thêm Spring Boot + Embedded Tomcat
# Hãy báo nếu bạn muốn cách này
```

---

## ✅ Success Checklist

- [ ] Tomcat downloaded & extracted to C:\apache-tomcat-10
- [ ] TOMCAT_HOME environment variable set
- [ ] MobileStore.war in target/ folder
- [ ] WAR file copied to webapps/
- [ ] Tomcat started (java process running)
- [ ] Can access http://localhost:8080/MobileStore/chatbot-demo.html

---

## 📞 Need Help?

Nếu gặp vấn đề, báo cho tôi:
1. Lỗi message từ PowerShell
2. Kết quả của: `Get-Process | Where-Object {$_.ProcessName -like "*java*"}`
3. Tomcat log file content (từ logs folder)

---

**Sau khi setup xong, bạn sẽ thấy giao diện ChatBot đẹp trong browser! 🎉**
