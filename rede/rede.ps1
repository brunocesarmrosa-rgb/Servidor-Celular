<#  Controle dos aparelhos da rede por Wi-Fi.
    Uso:  . .\rede\rede.ps1            (carrega as funções)
      Listar                           -> mostra aparelhos e se respondem
      Conectar [nome]                  -> adb connect / testa ssh (todos se sem nome)
      Executar <nome> "<comando>"      -> roda o comando no aparelho (adb shell, Termux via ssh, ou ssh no PC)
      Termux <nome> "<comando>"        -> roda dentro do Termux (ssh 8022)
      Enviar <nome> <arquivo> <destino> / Tela <nome> (abre scrcpy pela rede)
      FixarAdb <nome>                  -> com o aparelho no USB, fixa a porta 5555 (adb tcpip)
      Adicionar <nome> <ip> <tipo>     -> cadastra novo aparelho (android|windows|macos|linux)  #>
$Arq = Join-Path $PSScriptRoot "dispositivos.json"
function _Cfg { Get-Content $Arq -Raw | ConvertFrom-Json }
function _Dev($n) { $d = (_Cfg).dispositivos | Where-Object nome -eq $n; if (-not $d) { throw "Aparelho '$n' não cadastrado" }; $d }
function _Salvar($c) { $c | ConvertTo-Json -Depth 5 | Set-Content $Arq -Encoding UTF8 }

function Listar {
  foreach ($d in (_Cfg).dispositivos) {
    $on = Test-Connection $d.ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    "{0,-18} {1,-15} {2,-8} {3}" -f $d.nome, $d.ip, $d.tipo, ($(if ($on) {"ONLINE"} else {"offline"}))
  }
}
function Conectar([string]$nome) {
  $lista = if ($nome) { @(_Dev $nome) } else { (_Cfg).dispositivos }
  foreach ($d in $lista) {
    if ($d.acesso -contains "adb") { adb connect "$($d.ip):$($d.adb_porta)" }
    if ($d.acesso -contains "ssh") {
      $ok = Test-NetConnection $d.ip -Port $d.ssh_porta -InformationLevel Quiet -WarningAction SilentlyContinue
      Write-Host "$($d.nome) ssh:$($d.ssh_porta) -> $ok"
    }
  }
}
function Executar([string]$nome, [string]$cmd) {
  $d = _Dev $nome
  switch ($d.tipo) {
    "android" { adb -s "$($d.ip):$($d.adb_porta)" shell $cmd }
    default   { if ($d.acesso -contains "local") { powershell -NoProfile -Command $cmd } else { ssh -p $d.ssh_porta "$($d.ip)" $cmd } }
  }
}
function Termux([string]$nome, [string]$cmd) { $d = _Dev $nome; ssh -p $d.ssh_porta "$($d.ip)" $cmd }
function Enviar([string]$nome, [string]$arq, [string]$dest) {
  $d = _Dev $nome
  if ($d.tipo -eq "android" -and $d.acesso -contains "ssh") { scp -P $d.ssh_porta $arq "$($d.ip):$dest" }
  elseif ($d.tipo -eq "android") { adb -s "$($d.ip):$($d.adb_porta)" push $arq $dest }
  else { scp -P $d.ssh_porta $arq "$($d.ip):$dest" }
}
function Tela([string]$nome) { $d = _Dev $nome; scrcpy -s "$($d.ip):$($d.adb_porta)" }
function FixarAdb([string]$nome) {
  $d = _Dev $nome; adb -d tcpip $d.adb_porta; Start-Sleep 3; adb connect "$($d.ip):$($d.adb_porta)"
  Write-Host "Porta $($d.adb_porta) fixa até o celular reiniciar. Pode tirar o cabo." }
function Adicionar([string]$nome, [string]$ip, [string]$tipo) {
  $c = _Cfg
  $acesso = if ($tipo -eq "android") { @("adb") } else { @("ssh") }
  $novo = [pscustomobject]@{ nome=$nome; ip=$ip; tipo=$tipo; acesso=$acesso; adb_porta=5555; ssh_porta=$(if($tipo -eq "android"){8022}else{22}); obs="" }
  $c.dispositivos = @($c.dispositivos | Where-Object nome -ne $nome) + $novo; _Salvar $c; Write-Host "Cadastrado: $nome ($ip)" }
