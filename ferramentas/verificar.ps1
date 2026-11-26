# Checa PC + celular e mostra o que falta.
function ok($n,$c){ if($c){Write-Host "[OK]  $n" -ForegroundColor Green}else{Write-Host "[FALTA] $n" -ForegroundColor Red} }
ok "git"    (Get-Command git -EA 0)
ok "gh"     (Get-Command gh -EA 0)
ok "adb"    (Get-Command adb -EA 0)
ok "scrcpy" (Get-Command scrcpy -EA 0)
ok "node/npx" (Get-Command npx -EA 0)
ok "ssh"    (Get-Command ssh -EA 0)
ok "claude" (Get-Command claude -EA 0)
$cfg="$HOME\.claude\settings.json"
ok "Claude Code sem proxy estranho" (-not ((Test-Path $cfg) -and (Select-String -Path $cfg -Pattern "ANTHROPIC_BASE_URL" -Quiet)))
if (Get-Command adb -EA 0) {
  $d = adb devices | Select-String "\tdevice$"; ok "celular conectado (adb)" $d
  if ($d) {
    foreach ($p in @("com.termux","com.termux.boot","com.termux.api")) { ok "app $p" (adb shell pm list packages $p | Select-String $p) }
    adb shell dumpsys battery | Select-String "level|temperature"
  }
}
