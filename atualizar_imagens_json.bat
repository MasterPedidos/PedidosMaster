@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "PASTA=C:\Users\Usuario\Desktop\Catalogo"
set "JSON=%PASTA%\produtos.json"
set "BACKUP=%PASTA%\produtos_BACKUP.json"
set "MAP=%PASTA%\links_webp_corrigido.txt"

if not exist "%JSON%" (
  echo ❌ produtos.json NÃO encontrado!
  pause
  exit /b
)

if not exist "%MAP%" (
  echo ❌ links_webp_corrigido.txt NÃO encontrado!
  pause
  exit /b
)

echo 📦 Criando backup...
copy "%JSON%" "%BACKUP%" >nul
echo ✅ Backup criado: produtos_BACKUP.json

echo 🔄 Atualizando imagens...

powershell -NoLogo -Command ^
  $map = @{ }; ^
  Get-Content "%MAP%" | ForEach-Object { ^
    if ($_ -match '^(\d+);(.+)$') { $map[$matches[1]] = $matches[2] } ^
  }; ^
  $json = Get-Content "%JSON%" -Raw | ConvertFrom-Json; ^
  foreach ($item in $json) { ^
    $code = $item."Código"; ^
    if ($map.ContainsKey($code)) { ^
      $item.imagem = $map[$code]; ^
    } ^
  }; ^
  $json | ConvertTo-Json -Depth 10 | Set-Content "%JSON%" -Encoding UTF8

echo ✅ FINALIZADO!
echo As imagens foram atualizadas corretamente.
echo Para desfazer, restaure: produtos_BACKUP.json
echo.
pause
