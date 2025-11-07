@echo off
setlocal enabledelayedexpansion

echo =======================================================
echo   CONVERSOR PARA WEBP (com transparencia preservada)
echo   By GPT-5 ??
echo =======================================================
echo.

REM === Cria a pasta webp se não existir ===
if not exist "webp" (
    mkdir "webp"
    echo ?? Pasta "webp" criada!
)

echo.
set "PASTA=%cd%"
echo ?? Pasta atual: %PASTA%
echo.

for %%a in (*.png *.jpg *.jpeg *.webp) do (
    echo ?? Convertendo: %%a ...
    magick "%%a" -quality 90 -define webp:lossless=true "webp\%%~na.webp"
)

echo.
echo ? Conversão concluída!
echo ?? Arquivos convertidos estão em: %PASTA%\webp
echo.

pause
