@echo off
echo Cleaning up .NET processes on service ports...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :7500') do taskkill /PID %%a /F >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8081') do taskkill /PID %%a /F >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8082') do taskkill /PID %%a /F >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8083') do taskkill /PID %%a /F >nul 2>&1
echo Cleanup complete.