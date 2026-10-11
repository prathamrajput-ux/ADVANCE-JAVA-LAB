@echo off
setlocal enabledelayedexpansion
title NovaMart - Apache Tomcat 11 Web Server

echo ===================================================================
echo     NovaMart (ShopSphere) - Universal Tomcat Web Server Launcher
echo ===================================================================
echo.

rem -------------------------------------------------------------------
rem 1. Auto-detect Project Directory and WAR File
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
rem 2. Universal Java Environment Detection (Crucial for Tomcat)
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
if not defined JAVA_HOME (
    echo [ERROR] Java Development Kit (JDK 17+) was not found on your system.
    echo Apache Tomcat requires JAVA_HOME or JRE_HOME to run.
    echo Please install Java JDK 17 or higher from https://adoptium.net/
    pause
    exit /b 1
)

set "JRE_HOME=%JAVA_HOME%"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo [INFO] Using Java: %JAVA_HOME%

rem -------------------------------------------------------------------
rem 3. Universal Maven Detection & WAR Build
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

set "WAR_FILE=%PROJECT_DIR%\target\ShopSphere.war"

if defined MVN_CMD (
    echo.
    echo [INFO] Building ShopSphere with Maven (%MVN_CMD%)...
    cd /d "%PROJECT_DIR%"
    call "%MVN_CMD%" clean package -DskipTests
    cd /d "%SCRIPT_DIR%"
) else (
    echo [INFO] Maven CLI not found in PATH or standard folders.
    if exist "%WAR_FILE%" (
        echo [INFO] Found existing packaged WAR file at: %WAR_FILE%
    ) else (
        echo [ERROR] Neither Maven nor an existing 'ShopSphere.war' was found!
        echo Please ensure Maven is installed or compile the project first.
        pause
        exit /b 1
    )
)

if not exist "%WAR_FILE%" (
    echo [ERROR] WAR file was not generated: %WAR_FILE%
    pause
    exit /b 1
)

rem -------------------------------------------------------------------
rem 4. Universal Apache Tomcat Detection
rem -------------------------------------------------------------------
set "TOMCAT_DIR="

rem Check CATALINA_HOME / TOMCAT_HOME
if defined CATALINA_HOME if exist "%CATALINA_HOME%\bin\startup.bat" set "TOMCAT_DIR=%CATALINA_HOME%"
if "%TOMCAT_DIR%"=="" if defined TOMCAT_HOME if exist "%TOMCAT_HOME%\bin\startup.bat" set "TOMCAT_DIR=%TOMCAT_HOME%"

rem Check remembered .tomcat_path file
if "%TOMCAT_DIR%"=="" (
    if exist "%SCRIPT_DIR%\.tomcat_path" (
        set /p SAVED_TC=<"%SCRIPT_DIR%\.tomcat_path"
        if exist "!SAVED_TC!\bin\startup.bat" set "TOMCAT_DIR=!SAVED_TC!"
    )
)

rem Check developer's previous default paths
if "%TOMCAT_DIR%"=="" (
    if exist "C:\Users\prath\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26\bin\startup.bat" (
        set "TOMCAT_DIR=C:\Users\prath\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26"
    ) else if exist "P:\DEV TOOLS\apache-tomcat-11.0.26\bin\startup.bat" (
        set "TOMCAT_DIR=P:\DEV TOOLS\apache-tomcat-11.0.26"
    )
)

rem Scan sibling and parent directories
if "%TOMCAT_DIR%"=="" (
    for /d %%T in ("%SCRIPT_DIR%\..\APACHE TOMCAT\apache-tomcat*" "%SCRIPT_DIR%\..\apache-tomcat*" "%SCRIPT_DIR%\apache-tomcat*" "%SCRIPT_DIR%\..\tomcat*" "%SCRIPT_DIR%\tomcat*") do (
        if exist "%%T\bin\startup.bat" set "TOMCAT_DIR=%%T"
    )
)

rem Scan standard locations across system drives
if "%TOMCAT_DIR%"=="" (
    for %%D in (C: D: P: E:) do (
        if exist "%%D\" (
            for /d %%T in ("%%D\Program Files\Apache Software Foundation\Tomcat*" "%%D\Program Files (x86)\Apache Software Foundation\Tomcat*" "%%D\apache-tomcat*" "%%D\tomcat*" "%USERPROFILE%\Downloads\apache-tomcat*" "%USERPROFILE%\apache-tomcat*") do (
                if exist "%%T\bin\startup.bat" set "TOMCAT_DIR=%%T"
            )
        )
    )
)

rem Interactive prompt if not found anywhere
if "%TOMCAT_DIR%"=="" (
    echo.
    echo ===================================================================
    echo [PROMPT] Could not automatically locate Apache Tomcat on this PC.
    echo ===================================================================
    echo Please enter the full path to your Apache Tomcat folder
    echo (Example: C:\apache-tomcat-11.0.26 or D:\Tools\tomcat):
    set /p USER_TC="Path: "
    if exist "!USER_TC!\bin\startup.bat" (
        set "TOMCAT_DIR=!USER_TC!"
        echo !USER_TC!>"%SCRIPT_DIR%\.tomcat_path"
        echo [SAVED] Tomcat path remembered for future runs!
    ) else (
        echo [ERROR] Invalid Tomcat directory. 'bin\startup.bat' not found in: !USER_TC!
        pause
        exit /b 1
    )
)

echo [INFO] Located Apache Tomcat at: %TOMCAT_DIR%

rem -------------------------------------------------------------------
rem 5. Port 8080 Conflict Check
rem -------------------------------------------------------------------
netstat -ano 2>nul | findstr /r /c:":8080 .*LISTENING" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo.
    echo [NOTE] Port 8080 is currently active.
    echo If Tomcat is already running, the new WAR file will be deployed automatically.
)

rem -------------------------------------------------------------------
rem 6. Deploy WAR to Tomcat webapps
rem -------------------------------------------------------------------
echo.
echo [INFO] Deploying latest ShopSphere.war to %TOMCAT_DIR%\webapps\...
if not exist "%TOMCAT_DIR%\webapps" mkdir "%TOMCAT_DIR%\webapps" >nul 2>&1
copy /Y "%WAR_FILE%" "%TOMCAT_DIR%\webapps\" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] Copied ShopSphere.war to webapps directory.
) else (
    echo [WARN] Could not copy WAR file directly. Tomcat might have locked the file.
)

rem -------------------------------------------------------------------
rem 7. Launch Tomcat Server in a Dedicated Window
rem -------------------------------------------------------------------
echo.
echo [INFO] Launching Tomcat Server...
set "CATALINA_HOME=%TOMCAT_DIR%"
cd /d "%TOMCAT_DIR%\bin"

start "Apache Tomcat 11 - ShopSphere Web Server" "%TOMCAT_DIR%\bin\startup.bat"
cd /d "%SCRIPT_DIR%"

rem -------------------------------------------------------------------
rem 8. Auto-Open Web Browser & Summary
rem -------------------------------------------------------------------
echo.
echo ===================================================================
echo [SUCCESS] Apache Tomcat has been launched!
echo ===================================================================
echo.
echo Web Application URL:
echo    http://localhost:8080/ShopSphere/
echo.
echo Demo Accounts for Testing:
echo   * Admin Account:    admin@shopsphere.com    (Password: admin123)
echo   * Customer Account: customer@shopsphere.com (Password: user123)
echo.
echo Opening browser in 3 seconds...
timeout /t 3 /nobreak >nul 2>&1
start http://localhost:8080/ShopSphere/

echo.
echo (To shut down Tomcat later, run: "%TOMCAT_DIR%\bin\shutdown.bat" or close its window)
echo ===================================================================
echo.
pause
