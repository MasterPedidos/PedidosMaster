@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "API_KEY=429fad28d0cb4e5d9e40ce28fa0fc13b"
set "BASE_DIR=C:\Users\Usuario\Desktop\Catalogo\Imagens"

echo ============================================================
echo   ?? ENVIANDO IMAGENS WEBP PARA IMGBB AUTOMATICAMENTE...
echo ============================================================
echo.

REM Apagar o arquivo antigo
del links_webp.txt >nul 2>&1
echo # LINKS WEBP GERADOS > links_webp.txt

for /r "%BASE_DIR%" %%F in (*.webp) do (
    echo Enviando: %%~nxF...
    for /f "delims=" %%R in ('curl -s -F "image=@%%F" "https://api.imgbb.com/1/upload?key=%API_KEY%" ^| findstr /i "url"') do (
        set "linha=%%R"
        set "linha=!linha:        ""url"": ""=!"
        set "linha=!linha:""=!"
        set "linha=!linha:,=!"
        echo %%~nxF;!linha!>> links_webp.txt
    )
)

echo.
echo ? PROCESSO CONCLUIDO!
echo ? Todas as URLs foram salvas em: links_webp.txt
echo.
pause
