@echo off
chcp 65001 >nul

set "input=links_webp_corrigido.txt"
set "output=links_webp.txt"

if not exist "%input%" (
    echo ? Arquivo %input% não encontrado!
    pause
    exit /b
)

echo ? Corrigindo links...
echo # LINKS WEBP CORRIGIDOS > "%output%"

for /f "usebackq tokens=1* delims=;" %%a in ("%input%") do (
    set "linha=%%b"
    call :extrair "%%a" "%%b"
)

echo ? Finalizado! Agora execute: atualizar_produtos_json.bat
pause
exit /b

:extrair
set "codigo=%~1"
set "json=%~2"

for /f "tokens=2 delims=:\"" %%x in ("%json:*url=\"=%") do (
    echo %codigo%;%%x>>"%output%"
    goto :eof
)
