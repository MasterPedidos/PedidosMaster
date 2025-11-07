@echo off
cd /d "%~dp0"
echo ================================
echo  SERVIDOR INICIADO
echo  Acesse no navegador:
echo  http://localhost:8080
echo ================================
python -m http.server 8080
pause
