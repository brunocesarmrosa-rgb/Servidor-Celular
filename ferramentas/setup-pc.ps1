# Instala/atualiza tudo o que o PC precisa. Uso: powershell -ExecutionPolicy Bypass -File ferramentas\setup-pc.ps1
$ErrorActionPreference = "Continue"
$pacotes = @("Git.Git","GitHub.cli","Genymobile.scrcpy","OpenJS.NodeJS.LTS","Python.Python.3.12")
foreach ($p in $pacotes) {
  Write-Host "==> $p" -ForegroundColor Cyan
  winget install --id $p -e --accept-source-agreements --accept-package-agreements --silent
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { irm https://claude.ai/install.ps1 | iex }
# OpenSSH client
if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) { Write-Host "Ative 'Cliente OpenSSH' em Configurações > Sistema > Recursos opcionais" -ForegroundColor Yellow }
# Alerta de proxy indesejado
$cfg = "$HOME\.claude\settings.json"
if ((Test-Path $cfg) -and (Select-String -Path $cfg -Pattern "ANTHROPIC_BASE_URL|ANTHROPIC_AUTH_TOKEN" -Quiet)) {
  Write-Host "ATENÇÃO: $cfg redireciona o Claude Code para outro servidor. Remova o bloco 'env'." -ForegroundColor Red }
Write-Host "Feche e reabra o terminal para atualizar o PATH. Depois: gh auth login" -ForegroundColor Green
