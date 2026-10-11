@echo off
setlocal
title NovaMart - MySQL Database Import

echo ===================================================================
echo     NovaMart (ShopSphere) - MySQL Database Importer
echo ===================================================================
echo.

rem Delegate to the universal setup_database.bat script in the same folder
if exist "%~dp0setup_database.bat" (
    call "%~dp0setup_database.bat"
    exit /b %ERRORLEVEL%
) else (
    echo [ERROR] setup_database.bat not found in %~dp0
    pause
    exit /b 1
)
