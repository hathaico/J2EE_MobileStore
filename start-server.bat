@echo off
REM MobileStore Chatbot Server Startup Script
REM This script starts Tomcat with MobileStore application

echo.
echo ====================================
echo  MobileStore Chatbot Server Startup
echo ====================================
echo.

REM Check if TOMCAT_HOME is set
if not defined TOMCAT_HOME (
    echo ERROR: TOMCAT_HOME is not set!
    echo.
    echo Please set TOMCAT_HOME environment variable:
    echo   set TOMCAT_HOME=C:\apache-tomcat-10
    echo.
    echo Or edit this script to hardcode your Tomcat path.
    pause
    exit /b 1
)

echo [*] TOMCAT_HOME: %TOMCAT_HOME%
echo.

REM Check if Tomcat exists
if not exist "%TOMCAT_HOME%\bin\startup.bat" (
    echo ERROR: Tomcat not found at %TOMCAT_HOME%
    pause
    exit /b 1
)

REM Copy WAR to Tomcat webapps
echo [*] Deploying MobileStore.war...
if exist "target\MobileStore.war" (
    copy target\MobileStore.war "%TOMCAT_HOME%\webapps\" /Y
    echo [+] WAR deployed successfully
) else (
    echo [-] MobileStore.war not found. Build project first!
    echo    Run: mvn clean package
    pause
    exit /b 1
)

echo.
echo [*] Starting Tomcat...
call "%TOMCAT_HOME%\bin\startup.bat"

echo.
echo [+] Server starting...
echo [*] Waiting 10 seconds for deployment...
timeout /t 10 /nobreak

echo.
echo ====================================
echo  Access ChatBot at:
echo ====================================
echo.
echo Demo & Docs: http://localhost:8080/MobileStore/chatbot-demo.html
echo Chat Widget: http://localhost:8080/MobileStore/chatbot.html
echo.
echo ====================================
pause
