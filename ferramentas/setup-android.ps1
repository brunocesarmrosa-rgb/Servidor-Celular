# Instala Termux:Boot e Termux:API no celular (USB) e prepara o Termux. Uso: ferramentas\setup-android.ps1
$ErrorActionPreference = "Stop"
adb devices
$inst = (adb shell dumpsys package com.termux | Select-String "installerPackageName").ToString()
$assinaturaGithub = (adb shell dumpsys package com.termux | Select-String "versionName").ToString() -match "github"
Write-Host "Termux instalado por: $inst"
if (-not $assinaturaGithub) {
  Write-Host "Seu Termux NÃO é da versão GitHub. Instale Termux:Boot e Termux:API pela MESMA loja (F-Droid): https://f-droid.org/packages/com.termux.boot/ e https://f-droid.org/packages/com.termux.api/" -ForegroundColor Yellow
  adb shell am start -a android.intent.action.VIEW -d "https://f-droid.org/packages/com.termux.boot/"
  exit 0
}
$tmp = New-Item -ItemType Directory -Force "$env:TEMP\taikazet-apk"
foreach ($repo in @("termux/termux-boot","termux/termux-api")) {
  $rel = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"
  $apk = $rel.assets | Where-Object { $_.name -like "*.apk" } | Select-Object -First 1
  $dest = Join-Path $tmp $apk.name
  Invoke-WebRequest $apk.browser_download_url -OutFile $dest
  adb install -r $dest
}
Write-Host "Abra Termux:Boot uma vez no celular para ativá-lo." -ForegroundColor Green
