@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "CATALOGO=C:\Users\Usuario\Desktop\Catalogo"
set "MAP=%CATALOGO%\links_webp_corrigido.txt"
set "JSON=%CATALOGO%\produtos.json"
set "BACKUP=%CATALOGO%\produtos_BACKUP.json"

if not exist "%JSON%" (
  echo ❌ ERRO: produtos.json não encontrado!
  pause
  exit /b
)

if not exist "%MAP%" (
  echo ❌ ERRO: links_webp_corrigido.txt não encontrado!
  pause
  exit /b
)

echo 📦 Criando backup...
copy "%JSON%" "%BACKUP%" >nul
echo ✅ Backup criado: produtos_BACKUP.json
echo.

echo 🔄 Atualizando imagens...

powershell -NoLogo -Command ^
$links = @{}; ^
Get-Content "%MAP%" | ForEach-Object { ^
  if ($_ -match '^(\d+);(.+)$') { $links[$matches[1]] = $matches[2] } ^
}; ^
$json = Get-Content "%JSON%" -Raw; ^
foreach ($code in $links.Keys) { ^
  $url = $links[$code]; ^
  $pattern = '"Código"\s*:\s*"' + $code + '".*?"imagem"\s*:\s*"[^"]*"' ; ^
  $replacement = '"Código":"' + $code + '","imagem":"' + $url + '"' ; ^
  $json = [regex]::Replace($json, $pattern, $replacement, [System.Text.RegularExpressions.RegexOptions]::Singleline) ^
}; ^
$json | Set-Content "%JSON%" -Encoding UTF8

echo.
echo ✅ FINALIZADO COM SUCESSO!
echo Verifique o catálogo para confirmar.
echo Se algo der errado, restaure produtos_BACKUP.json.
echo.
pause
