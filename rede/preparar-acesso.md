# Preparar cada aparelho para acesso por Wi-Fi (uma vez só)

## Android (ADB por Wi-Fi) — porta fixa 5555
1. Ligue o aparelho no USB do PC uma vez e aceite "Permitir depuração USB".
2. `. .\rede\rede.ps1; FixarAdb celular-servidor` → a porta 5555 fica aberta até reiniciar.
3. **Depois de reiniciar o celular**: use Depuração por Wi-Fi (Opções do desenvolvedor) → "Parear com código" → `adb pair IP:PORTA CODIGO` → `adb connect IP:PORTA`, ou repita o passo 2 com cabo.
   Dica: no celular-servidor, o SSH do Termux (abaixo) não depende disso e sobrevive a reinícios.

## Android com Termux (SSH 8022) — o mais estável
No Termux: `pkg install openssh && passwd && sshd`; Termux:Boot já inicia o sshd (termux/boot.sh).
No PC: `ssh-keygen` (uma vez) e `type $HOME\.ssh\id_ed25519.pub | ssh -p 8022 192.168.15.18 "cat >> ~/.ssh/authorized_keys"`.

## Windows (notebook) — OpenSSH Server
PowerShell como Administrador no notebook:
```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd; Set-Service sshd -StartupType Automatic
```
## macOS
Ajustes do Sistema → Geral → Compartilhamento → **Início de Sessão Remoto** (SSH) ligado.

## Recomendado: IPs fixos
No roteador (192.168.15.1), em DHCP → "Reserva de endereço", fixe os IPs dos aparelhos pelo MAC. Sem isso os IPs podem mudar e o dispositivos.json fica desatualizado.

## Segurança
- Só funciona dentro da sua rede; não abra essas portas no roteador para a internet.
- Desligue a depuração no celular pessoal quando não estiver usando: ADB dá controle total do aparelho.
