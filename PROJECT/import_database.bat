@echo off
setlocal
echo ========================================================
echo Importing ShopSphere Database into MySQL...
echo ========================================================

rem Auto-detect SQL file location
set "SQL_FILE="
if exist "%~dp0ShopSphere\database\shopsphere.sql" (
    set "SQL_FILE=%~dp0ShopSphere\database\shopsphere.sql"
) else if exist "%~dp0JAVA_PROJECT\ShopSphere\database\shopsphere.sql" (
    set "SQL_FILE=%~dp0JAVA_PROJECT\ShopSphere\database\shopsphere.sql"
) else if exist "P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere\database\shopsphere.sql" (
    set "SQL_FILE=P:\CODING\ADV. JAVA LAB\JAVA_PROJECT\ShopSphere\database\shopsphere.sql"
)

if "%SQL_FILE%"=="" (
    echo [ERROR] Could not locate shopsphere.sql!
    pause
    exit /b 1
)

rem Auto-detect mysql.exe executable
set "MYSQL_BIN="
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if exist "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
if exist "C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe" set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe"
if exist "C:\Program Files\MySQL\MySQL Server 9.1\bin\mysql.exe" set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 9.1\bin\mysql.exe"

if "%MYSQL_BIN%"=="" (
    where mysql >nul 2>&1
    if %ERRORLEVEL% equ 0 set "MYSQL_BIN=mysql"
)

if "%MYSQL_BIN%"=="" (
    echo [ERROR] Could not find mysql.exe in Program Files or system PATH!
    echo Please make sure MySQL Server is installed.
    pause
    exit /b 1
)

echo Using MySQL client: "%MYSQL_BIN%"
echo Importing SQL file: "%SQL_FILE%"
echo.

rem Try password 2703 first
"%MYSQL_BIN%" -u root -p2703 < "%SQL_FILE%"
if %ERRORLEVEL% neq 0 (
    echo [INFO] Trying fallback password 'mydevsql'...
    "%MYSQL_BIN%" -u root -pmydevsql < "%SQL_FILE%"
)

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo [SUCCESS] Database 'shopsphere' and all seed data imported!
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo [ERROR] Failed to import into MySQL.
    echo 1. Ensure MySQL service is RUNNING (Win+R -> services.msc -> MySQL80).
    echo 2. Verify root password is '2703'.
    echo ========================================================
)
pause
