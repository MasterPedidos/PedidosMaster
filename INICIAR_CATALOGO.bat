@echo off
chcp 65001 >nul
cd /d "C:\Users\Usuario\Desktop\Catalogo"

echo ======================================
echo  Iniciando API (porta 8081)...
echo ======================================

start "" cmd /k python iniciar_api.py

timeout /t 2 >nul

echo ======================================
echo  Iniciando Servidor Web (porta 8080)...
echo ======================================

start "" cmd /k python -m http.server 8080

timeout /t 2 >nul

echo ======================================
echo  Abrindo o Painel no navegador...
echo ======================================

start "" "chrome.exe" "http://localhost:8080/painel.html"

echo ? Tudo pronto!
pause
