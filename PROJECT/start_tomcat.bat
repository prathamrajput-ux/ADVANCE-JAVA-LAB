@echo off
setlocal
echo ========================================================
echo Starting Apache Tomcat 11 for ShopSphere...
echo ========================================================

rem Auto-detect WAR file location
set "WAR_FILE="
if exist "%~dp0ShopSphere\target\ShopSphere.war" (
    set "WAR_FILE=%~dp0ShopSphere\target\ShopSphere.war"
) else if exist "%~dp0JAVA_PROJECT\ShopSphere\target\ShopSphere.war" (
    set "WAR_FILE=%~dp0JAVA_PROJECT\ShopSphere\target\ShopSphere.war"
) else if exist "P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere\target\ShopSphere.war" (
    set "WAR_FILE=P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere\target\ShopSphere.war"
)

if not "%WAR_FILE%"=="" (
    echo Deploying latest ShopSphere.war to Tomcat webapps...
    copy /Y "%WAR_FILE%" "P:\DEV TOOLS\apache-tomcat-11.0.26\webapps\"
) else (
    echo [WARNING] ShopSphere.war not found yet in target. Using existing deployment if present.
)

echo.
echo Launching Tomcat Server in new window...
echo Once Tomcat says "Server startup in [X] milliseconds", open:
echo.
echo    http://localhost:8080/ShopSphere/
echo.
start "Apache Tomcat 11 - ShopSphere" "P:\DEV TOOLS\apache-tomcat-11.0.26\bin\startup.bat"
echo Tomcat window opened! You can close this terminal.
pause
