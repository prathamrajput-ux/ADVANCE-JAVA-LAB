@echo off
setlocal
echo ========================================================
echo Starting ShopSphere Desktop Swing Inventory Viewer...
echo ========================================================

rem 1. Auto-detect ShopSphere root directory
set "PROJECT_DIR="
if exist "%~dp0ShopSphere\target\classes" (
    set "PROJECT_DIR=%~dp0ShopSphere"
) else if exist "%~dp0JAVA_PROJECT\ShopSphere\target\classes" (
    set "PROJECT_DIR=%~dp0JAVA_PROJECT\ShopSphere"
) else if exist "P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere\target\classes" (
    set "PROJECT_DIR=P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere"
)

if "%PROJECT_DIR%"=="" (
    echo [ERROR] Could not locate ShopSphere compiled classes!
    echo Please make sure the project is compiled.
    pause
    exit /b 1
)

cd /d "%PROJECT_DIR%"
echo Project Directory: %CD%

rem 2. Verify or locate java executable
where java >nul 2>&1
if %ERRORLEVEL% neq 0 (
    if exist "C:\Program Files\Java\jdk-21\bin\java.exe" (
        set "PATH=C:\Program Files\Java\jdk-21\bin;%PATH%"
    )
)

rem 3. Launch Swing Inventory Application
set "CP=target/classes;target/ShopSphere/WEB-INF/lib/*;target/dependency/*"
echo Launching Swing UI...
java -cp "%CP%" com.shopsphere.desktop.SwingInventoryViewer

if %ERRORLEVEL% neq 0 (
    echo.
    echo ========================================================
    echo [NOTICE] Application closed or encountered an error.
    echo If you see a database error, please ensure your MySQL service is running!
    echo ========================================================
    pause
)
