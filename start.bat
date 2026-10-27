@echo off
REM Armingram - run without Docker on Windows. Requires Node.js 22.13+ (24 LTS recommended)
cd /d "%~dp0"
if not exist node_modules call npm install --omit=dev
if "%PORT%"=="" set PORT=3000
node src\server.js
pause
