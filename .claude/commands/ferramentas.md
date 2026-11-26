Verifique e instale as ferramentas do projeto (lista completa em docs/FERRAMENTAS.md).
1. Rode `powershell -ExecutionPolicy Bypass -File ferramentas\verificar.ps1`.
2. Para cada [FALTA] no PC, rode `ferramentas\setup-pc.ps1` (ou o winget específico). Para o celular, `ferramentas\setup-android.ps1`.
3. No Termux (via SSH), confira: `pkg list-installed | grep -E "python|llama-cpp|openssh|termux-api"`; instale o que faltar com `termux/install.sh`.
4. Rode a verificação de novo e registre o resultado em docs/LOG.md. Commit + push.
