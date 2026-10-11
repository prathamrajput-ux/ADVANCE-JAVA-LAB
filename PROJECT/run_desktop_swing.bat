@echo off
setlocal enabledelayedexpansion
title NovaMart - Desktop Swing Inventory Application

echo ===================================================================
echo     NovaMart (ShopSphere) - Desktop Swing Inventory Viewer
echo ===================================================================
echo.

rem -------------------------------------------------------------------
rem 1. Auto-detect Project Directory
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

echo [INFO] Project directory: %PROJECT_DIR%

rem -------------------------------------------------------------------
rem 2. Universal Java Environment Detection
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
if not defined JAVA_EXE (
    echo [ERROR] Java runtime (JDK 17+) was not found on your system.
    echo Please install Java JDK 17 or higher from https://adoptium.net/
    pause
    exit /b 1
)

set "PATH=%JAVA_HOME%\bin;%PATH%"
echo [INFO] Using Java: %JAVA_EXE%

rem -------------------------------------------------------------------
rem 3. Universal Maven Detection
rem -------------------------------------------------------------------
set "MVN_CMD="
where mvn >nul 2>&1 && set "MVN_CMD=mvn"
if "%MVN_CMD%"=="" if defined MAVEN_HOME if exist "%MAVEN_HOME%\bin\mvn.cmd" set "MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
if "%MVN_CMD%"=="" if defined M2_HOME if exist "%M2_HOME%\bin\mvn.cmd" set "MVN_CMD=%M2_HOME%\bin\mvn.cmd"

if "%MVN_CMD%"=="" (
    for /d %%M in ("%SCRIPT_DIR%\..\APACHE TOMCAT\apache-maven*" "%SCRIPT_DIR%\..\apache-maven*" "%PROJECT_DIR%\..\apache-maven*") do (
        if exist "%%M\bin\mvn.cmd" set "MVN_CMD=%%M\bin\mvn.cmd"
    )
)

if "%MVN_CMD%"=="" (
    for %%D in (C: D: E:) do (
        if exist "%%D\" (
            for /d %%M in ("%%D\Program Files\apache-maven*" "%%D\apache-maven*" "%%D\maven*" "%USERPROFILE%\apache-maven*" "%USERPROFILE%\Downloads\apache-maven*") do (
                if exist "%%M\bin\mvn.cmd" set "MVN_CMD=%%M\bin\mvn.cmd"
            )
        )
    )
)

rem -------------------------------------------------------------------
rem 4. Auto-Compile if Project Classes Are Not Built
rem -------------------------------------------------------------------
set "SWING_CLASS=%PROJECT_DIR%\target\classes\com\shopsphere\desktop\SwingInventoryViewer.class"
if not exist "%SWING_CLASS%" (
    echo.
    echo [NOTICE] Compiled application classes not found.
    if defined MVN_CMD (
        echo [INFO] Automatically compiling ShopSphere using Maven...
        cd /d "%PROJECT_DIR%"
        call "%MVN_CMD%" compile -DskipTests
        cd /d "%SCRIPT_DIR%"
    ) else (
        echo [ERROR] Could not find compiled classes and Maven is not installed to auto-build.
        echo Please build the project with Maven or run from an environment with Maven installed.
        pause
        exit /b 1
    )
)

rem -------------------------------------------------------------------
rem 5. Ensure JDBC Library is Available
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
rem 6. Load Saved Database Credentials if Available
rem -------------------------------------------------------------------
if exist "%SCRIPT_DIR%\.db_pass" (
    set /p SAVED_PASS=<"%SCRIPT_DIR%\.db_pass"
    if not defined DB_PASSWORD set "DB_PASSWORD=!SAVED_PASS!"
    if not defined MYSQL_PWD set "MYSQL_PWD=!SAVED_PASS!"
)

rem -------------------------------------------------------------------
rem 7. Assemble Classpath & Launch Swing Application
rem -------------------------------------------------------------------
set "CP=%PROJECT_DIR%\target\classes;%PROJECT_DIR%\target\ShopSphere\WEB-INF\lib\*;%PROJECT_DIR%\lib\*;%PROJECT_DIR%\target\dependency\*;%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\*\*;%SCRIPT_DIR%\..\EXP - 3\JDBC\lib\*"

echo.
echo ===================================================================
echo  Launching NovaMart Desktop Swing UI...
echo ===================================================================
echo.

cd /d "%PROJECT_DIR%"
"%JAVA_EXE%" -cp "%CP%" com.shopsphere.desktop.SwingInventoryViewer

if %ERRORLEVEL% neq 0 (
    echo.
    echo ===================================================================
    echo [NOTICE] Application closed or exited with a status code.
    echo If you encountered a database connectivity error:
    echo   1. Verify your MySQL server is running in services.msc.
    echo   2. Run 'setup_database.bat' first to initialize the database.
    echo ===================================================================
    pause
)
