@echo off
REM Simple HTTP Server to view ChatBot UI locally
REM Requires Python 3 to be installed
REM This serves HTML files locally for testing without Tomcat

echo.
echo ====================================
echo  MobileStore ChatBot - Local Server
echo ====================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python 3 is not installed!
    echo.
    echo Please install Python 3 from: https://www.python.org/downloads/
    echo.
    echo Or use Tomcat for full feature support.
    pause
    exit /b 1
)

echo [*] Starting local HTTP server...
echo.

REM Change to webapp directory
cd src\main\webapp

REM Start Python HTTP server on port 3000
echo [+] Server started!
echo.
echo ====================================
echo  ChatBot is now available at:
echo ====================================
echo.
echo 📚 Demo & Docs:
echo    http://localhost:3000/chatbot-demo.html
echo.
echo 💬 Chat Widget:
echo    http://localhost:3000/chatbot.html
echo.
echo.
echo NOTE: Backend API won't work in this mode!
echo       For full features, deploy to Tomcat.
echo.
echo Press Ctrl+C to stop server.
echo ====================================
echo.

python -m http.server 3000

pause
