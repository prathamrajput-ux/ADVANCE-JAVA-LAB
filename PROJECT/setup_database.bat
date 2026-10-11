@echo off
setlocal enabledelayedexpansion
title NovaMart - MySQL Database Setup & Seed Data Importer

echo ===================================================================
echo     NovaMart (ShopSphere) - Universal MySQL Setup & Importer
echo ===================================================================
echo.

rem -------------------------------------------------------------------
rem 1. Auto-detect Project Directory and SQL File
rem -------------------------------------------------------------------
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "PROJECT_DIR="
if exist "%SCRIPT_DIR%\ShopSphere" (
    set "PROJECT_DIR=%SCRIPT_DIR%\ShopSphere"
) else if exist "%SCRIPT_DIR%\src\main\java" (
    set "PROJECT_DIR=%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%\..\ShopSphere" (
    set "PROJECT_DIR=%SCRIPT_DIR%\..\ShopSphere"
) else (
    set "PROJECT_DIR=%SCRIPT_DIR%"
)

set "SQL_FILE="
if exist "%PROJECT_DIR%\database\shopsphere.sql" (
    set "SQL_FILE=%PROJECT_DIR%\database\shopsphere.sql"
) else if exist "%SCRIPT_DIR%\ShopSphere\database\shopsphere.sql" (
    set "SQL_FILE=%SCRIPT_DIR%\ShopSphere\database\shopsphere.sql"
) else if exist "%SCRIPT_DIR%\database\shopsphere.sql" (
    set "SQL_FILE=%SCRIPT_DIR%\database\shopsphere.sql"
)

if "%SQL_FILE%"=="" (
    for /r "%SCRIPT_DIR%" %%F in (shopsphere.sql) do (
        if exist "%%F" (
            set "SQL_FILE=%%F"
            goto :SQL_FOUND
        )
    )
)
:SQL_FOUND

if "%SQL_FILE%"=="" (
    echo [ERROR] Could not locate 'shopsphere.sql' schema file.
    echo Please make sure 'shopsphere.sql' exists inside the ShopSphere\database folder.
    pause
    exit /b 1
)

echo [INFO] Located SQL file: %SQL_FILE%

rem -------------------------------------------------------------------
rem 2. Ensure local JDBC library is cached
rem -------------------------------------------------------------------
if not exist "%PROJECT_DIR%\lib" mkdir "%PROJECT_DIR%\lib" >nul 2>&1
if not exist "%PROJECT_DIR%\lib\mysql-connector-j-8.3.0.jar" (
    if exist "%PROJECT_DIR%\target\ShopSphere\WEB-INF\lib\mysql-connector-j-8.3.0.jar" (
        copy /Y "%PROJECT_DIR%\target\ShopSphere\WEB-INF\lib\mysql-connector-j-8.3.0.jar" "%PROJECT_DIR%\lib\" >nul 2>&1
    ) else if exist "%SCRIPT_DIR%\..\EXP - 3\JDBC\lib\mysql-connector-j-26.7.0.jar" (
        copy /Y "%SCRIPT_DIR%\..\EXP - 3\JDBC\lib\mysql-connector-j-26.7.0.jar" "%PROJECT_DIR%\lib\" >nul 2>&1
    )
)

rem -------------------------------------------------------------------
rem 3. Universal Java Environment Detection
rem -------------------------------------------------------------------
set "JAVA_EXE="
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" (
    set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
    goto :JAVA_DETECTED
)

where java >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "delims=" %%I in ('where java') do (
        set "JAVA_EXE=%%I"
        goto :JAVA_PATH_FOUND
    )
)
:JAVA_PATH_FOUND
if defined JAVA_EXE (
    for %%I in ("%JAVA_EXE%\..\..") do (
        if not defined JAVA_HOME set "JAVA_HOME=%%~fI"
    )
    goto :JAVA_DETECTED
)

rem Scan standard JDK locations across system drives
for %%D in (C: D: E:) do (
    if exist "%%D\" (
        for /d %%J in ("%%D\Program Files\Java\jdk*" "%%D\Program Files\Eclipse Adoptium\jdk*" "%%D\Program Files\Microsoft\jdk*" "%%D\Program Files\Amazon Corretto\jdk*" "%%D\Program Files\Zulu\zulu*" "%%D\Program Files (x86)\Java\jdk*") do (
            if exist "%%J\bin\java.exe" (
                set "JAVA_HOME=%%J"
                set "JAVA_EXE=%%J\bin\java.exe"
                goto :JAVA_DETECTED
            )
        )
    )
)

:JAVA_DETECTED
if defined JAVA_HOME (
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    set "JRE_HOME=%JAVA_HOME%"
)

rem -------------------------------------------------------------------
rem 4. Universal MySQL Client Detection
rem -------------------------------------------------------------------
set "MYSQL_EXE="
where mysql >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "delims=" %%I in ('where mysql') do (
        set "MYSQL_EXE=%%I"
        goto :MYSQL_LOCATED
    )
)

if defined MYSQL_HOME if exist "%MYSQL_HOME%\bin\mysql.exe" (
    set "MYSQL_EXE=%MYSQL_HOME%\bin\mysql.exe"
    goto :MYSQL_LOCATED
)

rem Scan standard MySQL directories across drives
for %%D in (C: D: E:) do (
    if exist "%%D\" (
        for /d %%M in ("%%D\Program Files\MySQL\MySQL Server *\bin" "%%D\Program Files (x86)\MySQL\MySQL Server *\bin" "%%D\xampp\mysql\bin" "%%D\wamp64\bin\mysql\mysql*\bin" "%%D\laragon\bin\mysql\mysql*\bin" "%%D\Program Files\MariaDB*\bin") do (
            if exist "%%M\mysql.exe" (
                set "MYSQL_EXE=%%M\mysql.exe"
                goto :MYSQL_LOCATED
            )
        )
    )
)

:MYSQL_LOCATED
if defined MYSQL_EXE (
    echo [INFO] Located MySQL executable: %MYSQL_EXE%
) else (
    echo [INFO] MySQL CLI executable not found in PATH or standard folders.
    echo        Will proceed via Java JDBC direct connection fallback.
)

rem -------------------------------------------------------------------
rem 5. Password Negotiation & SQL Import via MySQL CLI
rem -------------------------------------------------------------------
if defined MYSQL_EXE (
    echo.
    echo [1/2] Testing MySQL connection credentials...

    set "CONNECTED_PASS="
    set "TEST_SUCCESS=0"

    rem Priority A: Environment variables if set
    if defined DB_PASSWORD (
        call :TRY_PASS "!DB_PASSWORD!"
        if !TEST_SUCCESS! equ 1 goto :IMPORT_WITH_CLI
    )
    if defined MYSQL_PWD (
        call :TRY_PASS "!MYSQL_PWD!"
        if !TEST_SUCCESS! equ 1 goto :IMPORT_WITH_CLI
    )

    rem Priority B: Saved password file if previously configured
    if exist "%SCRIPT_DIR%\.db_pass" (
        set /p SAVED_PASS=<"%SCRIPT_DIR%\.db_pass"
        call :TRY_PASS "!SAVED_PASS!"
        if !TEST_SUCCESS! equ 1 goto :IMPORT_WITH_CLI
    )

    rem Priority C: Candidate list ("2703", blank, "root", "admin", "123456", "1234", "password")
    for %%P in ("2703" "" "root" "admin" "123456" "1234" "password") do (
        if !TEST_SUCCESS! equ 0 (
            call :TRY_PASS "%%~P"
            if !TEST_SUCCESS! equ 1 goto :IMPORT_WITH_CLI
        )
    )

    rem Priority D: Interactive prompt if all candidates failed
    if !TEST_SUCCESS! equ 0 (
        echo.
        echo [PROMPT] Could not connect with standard default passwords (2703, blank, root, admin).
        set /p USER_PASS="Please enter your MySQL root password (press Enter for blank): "
        call :TRY_PASS "!USER_PASS!"
        if !TEST_SUCCESS! equ 1 (
            echo !USER_PASS!>"%SCRIPT_DIR%\.db_pass"
            goto :IMPORT_WITH_CLI
        )
    )

:IMPORT_WITH_CLI
    if !TEST_SUCCESS! equ 1 (
        echo [INFO] Connection successful! Importing '%SQL_FILE%'...
        if "!CONNECTED_PASS!"=="" (
            "%MYSQL_EXE%" -u root < "%SQL_FILE%"
        ) else (
            "%MYSQL_EXE%" -u root --password="!CONNECTED_PASS!" < "%SQL_FILE%"
        )

        if !ERRORLEVEL! equ 0 (
            echo [SUCCESS] Database 'shopsphere' imported successfully via MySQL CLI.
            goto :SUCCESS_DISPLAY
        ) else (
            echo [WARN] MySQL CLI returned error code. Attempting Java fallback...
        )
    )
)

rem -------------------------------------------------------------------
rem 6. Universal Java DatabaseInitializer Fallback
rem -------------------------------------------------------------------
echo.
echo [2/2] Running ShopSphere DatabaseInitializer via Java...

if not defined JAVA_EXE (
    echo [ERROR] Java is not installed or could not be found.
    echo Please install Java JDK 17 or higher from https://adoptium.net/
    pause
    exit /b 1
)

rem Build Classpath
set "CP=%PROJECT_DIR%\target\classes;%PROJECT_DIR%\target\ShopSphere\WEB-INF\lib\*;%PROJECT_DIR%\lib\*;%PROJECT_DIR%\target\dependency\*;%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\*\*"

rem If classes are not compiled yet, attempt to compile DatabaseInitializer
if not exist "%PROJECT_DIR%\target\classes\com\shopsphere\util\DatabaseInitializer.class" (
    echo [INFO] Project classes not found. Auto-compiling DatabaseInitializer...
    where mvn >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        cd /d "%PROJECT_DIR%"
        call mvn compile -DskipTests
        cd /d "%SCRIPT_DIR%"
    )
)

"%JAVA_EXE%" -cp "%CP%" com.shopsphere.util.DatabaseInitializer
if %ERRORLEVEL% equ 0 goto :SUCCESS_DISPLAY

echo.
echo ===================================================================
echo [ERROR] Connection to MySQL failed.
echo.
echo Please verify that MySQL Service is RUNNING on your computer:
echo  1. Press Win+R, type 'services.msc' and press Enter.
echo  2. Find 'MySQL80' (or 'MySQL' / 'MariaDB') in the list.
echo  3. Right-click and choose 'Start'.
echo  4. If using XAMPP/WAMP: Open the Control Panel and click Start for MySQL.
echo  5. If you have a custom root password, set it in Windows:
echo     set DB_PASSWORD=your_password
echo ===================================================================
pause
exit /b 1

rem -------------------------------------------------------------------
rem Helper Subroutine: Test MySQL Connection with a Password Candidate
rem -------------------------------------------------------------------
:TRY_PASS
set "CANDIDATE=%~1"
if "%CANDIDATE%"=="" (
    "%MYSQL_EXE%" -u root -e "SELECT 1;" >nul 2>&1
) else (
    "%MYSQL_EXE%" -u root --password="%CANDIDATE%" -e "SELECT 1;" >nul 2>&1
)
if %ERRORLEVEL% equ 0 (
    set "CONNECTED_PASS=%CANDIDATE%"
    set "TEST_SUCCESS=1"
    echo !CANDIDATE!>"%SCRIPT_DIR%\.db_pass"
)
exit /b 0

rem -------------------------------------------------------------------
rem 7. Success Banner & Seed Data Summary
rem -------------------------------------------------------------------
:SUCCESS_DISPLAY
echo.
echo ===================================================================
echo [SUCCESS] Database 'shopsphere' is fully configured and ready!
echo ===================================================================
echo.
echo Seeded Accounts:
echo   * Admin Account:    admin@shopsphere.com    (Password: admin123)
echo   * Customer Account: customer@shopsphere.com (Password: user123)
echo.
echo Pre-loaded Catalog:
echo   * 6 Product Categories (Electronics, Fashion, Home, Audio, etc.)
echo   * 24 Enterprise Products with stock, pricing, and images
echo.
echo You can now run:
echo   1. 'start_tomcat.bat'      - To run the ShopSphere Web App
echo   2. 'run_desktop_swing.bat' - To launch the Desktop Inventory UI
echo ===================================================================
echo.
pause
