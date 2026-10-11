@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo ShopSphere - Build and Deploy to Tomcat
echo ========================================================

rem 1. Set Maven Path
set "MVN_CMD="
if exist "%~dp0..\APACHE TOMCAT\apache-maven-3.9.16\bin\mvn.cmd" (
    set "MVN_CMD=%~dp0..\APACHE TOMCAT\apache-maven-3.9.16\bin\mvn.cmd"
) else (
    where mvn >nul 2>&1
    if !ERRORLEVEL! equ 0 set "MVN_CMD=mvn"
)

rem 2. Build ShopSphere Project
echo [1/3] Building ShopSphere with Maven...
cd /d "%~dp0ShopSphere"
if not "%MVN_CMD%"=="" (
    call "%MVN_CMD%" clean package -DskipTests
) else (
    echo [WARNING] Maven not found! Using existing compiled build if available.
)

rem 3. Detect Tomcat Directory
echo.
echo [2/3] Locating Apache Tomcat...
set "TOMCAT_DIR="
if exist "C:\Users\%USERNAME%\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26" (
    set "TOMCAT_DIR=C:\Users\%USERNAME%\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26"
) else if exist "P:\DEV TOOLS\apache-tomcat-11.0.26" (
    set "TOMCAT_DIR=P:\DEV TOOLS\apache-tomcat-11.0.26"
)

if "%TOMCAT_DIR%"=="" (
    echo [WARNING] Could not automatically locate Tomcat path.
    echo Please copy ShopSphere\target\ShopSphere.war to your Tomcat webapps folder manually.
) else (
    echo Found Tomcat at: "%TOMCAT_DIR%"
    echo Deploying updated files...

    rem Copy WAR
    if exist "%~dp0ShopSphere\target\ShopSphere.war" (
        copy /Y "%~dp0ShopSphere\target\ShopSphere.war" "%TOMCAT_DIR%\webapps\"
        echo -> Copied ShopSphere.war to Tomcat webapps!
    )

    rem If ROOT webapp is active, update DBConnection.class inside ROOT
    if exist "%TOMCAT_DIR%\webapps\ROOT\WEB-INF\classes\com\shopsphere\util" (
        if exist "%~dp0ShopSphere\target\classes\com\shopsphere\util\DBConnection.class" (
            copy /Y "%~dp0ShopSphere\target\classes\com\shopsphere\util\DBConnection*.class" "%TOMCAT_DIR%\webapps\ROOT\WEB-INF\classes\com\shopsphere\util\"
            echo -> Updated DBConnection.class in webapps\ROOT!
        )
    )
)

echo.
echo ========================================================
echo [3/3] Deployment complete!
echo Please restart Tomcat:
echo 1. Close the current Tomcat terminal window.
echo 2. Run "%TOMCAT_DIR%\bin\startup.bat" or run start_tomcat.bat
echo 3. Open http://localhost:8080/ in your browser!
echo ========================================================
pause
