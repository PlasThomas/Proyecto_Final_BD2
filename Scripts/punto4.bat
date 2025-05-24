@echo off
setlocal

set DB_NAME=ecommerce
set DB_USER=root
set DB_PASS=312908
set "BACKUP_DIR=C:\respaldos\ecommerce"
set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin"
set INTERVAL_DAYS=7
set /a SLEEP_SECONDS=%INTERVAL_DAYS% * 86400

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:LOOP
for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set TIMESTAMP=%%i

echo [%DATE% %TIME%] Iniciando respaldo...
"%MYSQL_BIN%\mysqldump.exe" -u%DB_USER% -p%DB_PASS% --databases %DB_NAME% > "%BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql"

:: Verificación de integridad
"%MYSQL_BIN%\mysql.exe" -u%DB_USER% -p%DB_PASS% -e "DROP DATABASE IF EXISTS test_integrity; CREATE DATABASE test_integrity;"
"%MYSQL_BIN%\mysql.exe" -u%DB_USER% -p%DB_PASS% test_integrity < "%BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql"

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] Verificación exitosa.
    "%MYSQL_BIN%\mysql.exe" -u%DB_USER% -p%DB_PASS% -e "DROP DATABASE test_integrity;"
) else (
    echo [%DATE% %TIME%] ¡Error en verificación!
)

echo [%DATE% %TIME%] Esperando %INTERVAL_DAYS% días (%SLEEP_SECONDS% segundos)...
powershell -Command "Start-Sleep -Seconds %SLEEP_SECONDS%"

goto LOOP
