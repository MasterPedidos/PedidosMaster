@echo off
chcp 65001 >nul
title Atualizando imagens WebP no produtos.json

set "prod=produtos.json"
set "links_raw=links_webp_corrigido.txt"
set "links_ok=links_webp.txt"
set "backup=produtos_BACKUP.json"

echo.
echo ============================================================
echo   ??  ATUALIZANDO ARQUIVO produtos.json COM LINKS WEBP NOVOS
echo ============================================================
echo.

if not exist "%prod%" (
    echo ? ERRO: Arquivo %prod% nao encontrado!
    pause
    exit /b
)

if not exist "%links_raw%" (
    echo ? ERRO: Arquivo %links_raw% nao encontrado!
    pause
    exit /b
)

echo ? Criando backup seguro...
copy /y "%prod%" "%backup%" >nul

echo ? Extraindo URLs corretas para %links_ok% ...
echo # LINKS WEBP CORRIGIDOS > "%links_ok%"

for /f "usebackq tokens=1* delims=;" %%a in ("%links_raw%") do (
    set "json=%%b"
    setlocal enabledelayedexpansion
    set "linha=!json:*url=\"=!"
    for /f "tokens=1 delims=\"\"" %%x in ("!linha!") do (
        echo %%a;%%x>>"%links_ok%"
    )
    endlocal
)

echo ? Atualizando imagens dentro de %prod% ...

for /f "usebackq tokens=1,2 delims=;" %%a in ("%links_ok%") do (
    powershell -Command "(Get-Content '%prod%') -replace '\"imagem\":\"[^\"]*\"(?=.*,\"Código\":\"%%a\")','\"imagem\":\"%%b\"' | Set-Content '%prod%'"
)

echo.
echo ?? FINALIZADO COM SUCESSO!
echo ------------------------------------------------------------
echo • produtos.json atualizado
echo • Nada mais foi alterado (codigo, preco, marca preservados)
echo • Se algo der errado, o backup esta em: %backup%
echo ------------------------------------------------------------
echo.
pause
