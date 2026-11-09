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
- Workflow `tecnomax-windows.yml` gera o `.exe` portátil do Tecnomax Connect (1º build verde, run 42656026923).
- **1º Tecnomax Connect aprovado (09/11/2026 17:21 UTC):** abriu na YAGO-PC sem configurar nada, registrou só pela 443 (`wss`) e a Dell conectou nele pelo relay (`got paired` em 44 ms).

- **Decisões do CEO (09/11/2026, tarde):** sem certificado de assinatura por enquanto (custo; risco
  aceito: aviso de "editor desconhecido" e possível alerta de antivírus); piloto com clientes de teste
  usando o **CT 120 como servidor**, no endereço **connect.tecnomax.tech**; download publicado no site
  em página própria **/connect**; ícone = **só a marca de 4 cores** (versão reduzida nova da logo).
- Ícones e logos em `tecnomax/marca/` (gerados do logo oficial); cores da interface no azul da marca.
- `connect.tecnomax.tech` publicado no mesmo túnel (o `connect-teste` continua respondendo).
- Workflow publica release com nome fixo `TecnomaxConnect-x64.exe` no disparo manual com "publicar".

## Observação
O `rebrand.py` altera o submódulo `libs/hbb_common` no próprio build. Por isso o fork
`tecnomax-sudo/hbb_common` não é necessário hoje.

## Pendências
- 🟠 **Servidor depois do piloto**: o CT 120 fica no labsai, que é laboratório, está na rede do RI e
  tem histórico de travar a placa de rede. Migrar ao fim do piloto (continua pelo túnel, sem porta aberta).
- 🟠 Sem assinatura de código (decisão do CEO): orientar o cliente de teste sobre o aviso do Windows.
- 🟡 Gerar o par de chaves para o `custom.txt` (`TM_CUSTOM_PUB_KEY`), se for usar configuração por cliente.
- 🟡 Instalador MSI (o workflow gera só o `.exe` portátil).
- 🟡 O `.exe` interno ainda se chama `rustdesk.exe`: o portátil extrai para `%LOCALAPPDATA%\rustdesk`, a mesma pasta do RustDesk oficial (a configuração fica separada, em `%APPDATA%\Tecnomax Connect`).
- 🔵 macOS e Android: identificador do app e notarization ficam para depois do Windows.
