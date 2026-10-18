@echo off
setlocal enabledelayedexpansion
title ShopSphere - Universal Master Control Center

:MENU
cls
echo ===================================================================
echo                  ShopSphere - Master Control Center
echo                 RTU Advanced Java Laboratory Project
echo ===================================================================
echo.
echo   [1] 1-Click Launch (Setup Database + Build WAR + Start Tomcat Web App)
echo   [2] Start Tomcat Web Server (http://localhost:8080/ShopSphere/)
echo   [3] Launch Desktop Swing Inventory Viewer (MVC UI)
echo   [4] Setup / Seed MySQL Database & Users (shopsphere)
echo   [5] Build / Package ShopSphere with Maven (clean package)
echo   [6] Open Web App in Default Browser
echo   [7] Exit
echo.
echo ===================================================================
set /p CHOICE="Enter your choice (1-7): "

if "%CHOICE%"=="1" goto :ONE_CLICK
if "%CHOICE%"=="2" goto :START_TOMCAT
if "%CHOICE%"=="3" goto :RUN_SWING
if "%CHOICE%"=="4" goto :SETUP_DB
if "%CHOICE%"=="5" goto :BUILD_MAVEN
if "%CHOICE%"=="6" goto :OPEN_BROWSER
if "%CHOICE%"=="7" exit /b 0

echo [ERROR] Invalid choice. Please enter a number between 1 and 7.
timeout /t 2 >nul
goto :MENU

:ONE_CLICK
cls
echo ===================================================================
echo [STEP 1/3] Setting up MySQL Database & Seeding Data...
echo ===================================================================
call "%~dp0setup_database.bat"

echo.
echo ===================================================================
echo [STEP 2/3 & 3/3] Building Project & Starting Tomcat Web Server...
echo ===================================================================
call "%~dp0start_tomcat.bat"
goto :MENU

:START_TOMCAT
cls
call "%~dp0start_tomcat.bat"
goto :MENU

:RUN_SWING
cls
call "%~dp0run_desktop_swing.bat"
goto :MENU

:SETUP_DB
cls
call "%~dp0setup_database.bat"
goto :MENU

:BUILD_MAVEN
cls
echo ===================================================================
echo Building ShopSphere with Maven...
echo ===================================================================
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "PROJECT_DIR=%SCRIPT_DIR%\ShopSphere"
if not exist "%PROJECT_DIR%" set "PROJECT_DIR=%SCRIPT_DIR%"

where mvn >nul 2>&1
if %ERRORLEVEL% equ 0 (
    cd /d "%PROJECT_DIR%"
    call mvn clean package -DskipTests
    cd /d "%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%\..\APACHE TOMCAT\apache-maven-3.9.16\bin\mvn.cmd" (
    cd /d "%PROJECT_DIR%"
    call "%SCRIPT_DIR%\..\APACHE TOMCAT\apache-maven-3.9.16\bin\mvn.cmd" clean package -DskipTests
    cd /d "%SCRIPT_DIR%"
) else (
    echo [ERROR] Maven not found in PATH or standard directory.
)
echo.
pause
goto :MENU

:OPEN_BROWSER
start http://localhost:8080/ShopSphere/
goto :MENU
