Gerencie os aparelhos da rede (cadastro em rede/dispositivos.json, funções em rede/rede.ps1, preparo em rede/preparar-acesso.md).
- Carregue: `. .\rede\rede.ps1`; rode `Listar` e `Conectar` e mostre quem está ONLINE/acessível.
- Para executar algo pedido pelo usuário: `Executar <nome> "<cmd>"` (Android = adb shell; PC = ssh/local) ou `Termux <nome> "<cmd>"`.
- Se o usuário der um aparelho novo (nome/IP/tipo): `Adicionar ...`, siga rede/preparar-acesso.md para habilitar o acesso, teste, e faça commit + push.
- Se um aparelho não conectar: confira IP (`Test-Connection`), porta (`Test-NetConnection -Port`), e para Android sem 5555 use pareamento por código ou FixarAdb com cabo.
- Antes de comando destrutivo em aparelho pessoal (apagar, desinstalar, resetar), confirme com o usuário.
