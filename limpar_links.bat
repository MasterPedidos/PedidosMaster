@echo off
cd /d "%~dp0"

powershell -Command ^
$linhas = Get-Content 'links_webp_corrigido.txt'; ^
$saida = @(); ^
foreach ($linha in $linhas) { ^
    if ($linha -match '^(\d+);.*?(https://i\.ibb\.co/[^\s"\\]+\.webp)') { ^
        $saida += "$($matches[1]);$($matches[2])" ^
    } ^
}; ^
$saida | Set-Content 'links_webp_final.txt' -Encoding UTF8

echo ======================================================
echo ✅ LIMPEZA CONCLUIDA!
echo Arquivo gerado: links_webp_final.txt
echo ======================================================
pause
