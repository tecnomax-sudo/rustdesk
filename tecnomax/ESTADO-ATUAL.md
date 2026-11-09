---
projeto: acesso-remoto-tecnomax
atualizado: 09/11/2026
---

# Estado atual

## Feito (09/11/2026)
- Decisão do CEO: **fork próprio**, em vez do RustDesk Server Pro.
- Nome do produto definido pelo CEO: **Tecnomax Connect** (grafia exata). Fica como padrão no `rebrand.py`.
- Forks públicos: `tecnomax-sudo/rustdesk` (cliente), `tecnomax-sudo/hbb_common` e
  `tecnomax-sudo/rustdesk-server` (servidor com registro por WebSocket).
- `tecnomax/rebrand.py`: nome, servidor, chave, organização, chave do `custom.txt`, metadados do
  `.exe`, título, WebSocket fixo e `wss` para domínio.
- **Servidor de teste**: CT 120 `connect-teste` no labsai, com hbbs/hbbr do fork atrás do Cloudflare
  Tunnel `connect-teste.tecnomax.tech`, sem porta aberta.
- **Sessão real aprovada**: a Dell controlou a YAGO-PC pelo túnel, com o cliente oficial configurado
  para o nosso servidor.
- Workflow `tecnomax-windows.yml` criado para gerar o `.exe` do Tecnomax Connect.

## Observação
O `rebrand.py` altera o submódulo `libs/hbb_common` no próprio build. Por isso o fork
`tecnomax-sudo/hbb_common` não é necessário hoje.

## Pendências
- 🟠 **Servidor de produção**: o CT 120 é laboratório, num host que fica na rede do RI. Definir onde
  roda o hbbs/hbbr de verdade (ainda pelo túnel, sem porta aberta).
- 🟠 **Certificado de assinatura de código (Windows)**: sem ele, o SmartScreen e o Defender barram o executável.
- 🟡 Ícones da marca em `tecnomax/marca/`.
- 🟡 Gerar o par de chaves para o `custom.txt` (`TM_CUSTOM_PUB_KEY`), se for usar configuração por cliente.
- 🟡 Instalador MSI (o workflow gera só o `.exe` portátil).
- 🟡 O `.exe` interno ainda se chama `rustdesk.exe`: o portátil extrai para `%LOCALAPPDATA%\rustdesk`, a mesma pasta do RustDesk oficial (a configuração fica separada, em `%APPDATA%\Tecnomax Connect`).
- 🔵 macOS e Android: identificador do app e notarization ficam para depois do Windows.
