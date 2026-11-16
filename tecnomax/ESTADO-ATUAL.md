---
projeto: acesso-remoto-tecnomax
atualizado: 16/11/2026
---

# Estado atual

## Servidor atualizado em 16/11/2026 (em produção)
- **hbbs/hbbr do commit `121728b`** do rustdesk-server (CI 43783088929, 16 testes ok) na VPS desde
  **01:03:25 UTC de 16/11/2026**: o hbbs responde `OnlineRequest` pela sessão WebSocket (`/ws/id`).
  **As bolinhas de online acendem**: teste pela internet devolveu `states: 70` (3 de 5 IDs online).
  O túnel não precisou de regra nova: o cliente leva a consulta da 21115 para o mesmo `/ws/id`.
- **Limites do relay** na unidade do hbbr: `TOTAL_BANDWIDTH=200`, `SINGLE_BANDWIDTH=20`, `LIMIT_SPEED=8`
  (Mb/s, somando os dois sentidos). O `HOME` dos serviços passou a valer (sem "Failed to store config").
  Unidades versionadas em `tecnomax-sudo/rustdesk-server`, pasta `tecnomax/systemd/` (commit `e8a1d8a`).
- **Rollback:** binários anteriores e unidades originais em `/opt/tecnomax-connect/bin/anterior-2026-11-15/`.
- **WebSocket ocioso (~40 s):** regra do próprio hbbs (heartbeat 10 s, fecha após 35 s sem resposta);
  os fechamentos vinham de um cliente só (206524240). Nada mudado.
- **Sonda externa no labsai** (`tecnomax-connect-sonda.timer`, a cada 5 min): testa `/ws/id` e `/ws/relay`
  (101), alerta por e-mail pelo SMTP do PVE após 2 falhas seguidas e avisa a recuperação. Teste de falha ok.
- **Pendente do Yago:** regra de limite de requisições na Cloudflare para `/ws/*` (o acesso à API desta
  máquina não alcança a zona `tecnomax.tech`; passo a passo no RAG).

## Preparado em 16/11/2026, ainda NÃO compilado (Actions bloqueado, chamado #4979864)
Trabalho da noite de 15→16/11/2026 a partir da `AVALIACAO-2026-11-15.md`, na branch
`melhorias-2026-11-16` (PR para a `tecnomax`, sem merge). Nada disso está em nenhuma release.
- **Workflow mais leve:** só disparo manual (sem build por push), `build-topmost` só quando o modo
  privacidade entra no pacote, MSI só com o input `msi`, `timeout-minutes` nos jobs.
- **Motor do Flutter travado** pelo SHA256 `ec8cabf3…036e` (o upstream só tem a tag móvel `main`). Se a
  RustDesk trocar o arquivo, o build falha de propósito; como atualizar: `PLANO-ATUALIZACAO.md` 6.5.
- **Duas versões:** input `variante` (`tecnico`|`suporte`|`ambas`). A Suporte (`TM_SO_RECEBER=1`,
  `conn-type=incoming` em `HARD_SETTINGS`) sai como `TecnomaxConnectSuporte-x64.exe`, "Tecnomax Connect
  Suporte", só ID e senha. Nome técnico próprio `TecnomaxConnectSuporte` (decisão de 16/11/2026):
  pasta, serviço, ID e MSI separados; convive com a completa e não a substitui. Publicar exige
  a técnica no build, para `releases/latest/download/TecnomaxConnect-x64.exe` continuar existindo.
- **Senha permanente:** `tecnomax/instalar-gerenciado.ps1` (instala em silêncio, define a senha,
  `verification-method` e `approve-mode`, imprime o ID; senha não gravada nem exibida). Documentado no
  `tecnomax/README.md`, com MSI por GPO/RMM.
- **Atalhos e "Editor":** Menu Iniciar, Área de Trabalho e "Desinstalar ..." com o nome de exibição;
  Publisher = "Tecnomax". Caminho de instalação, exe e serviço inalterados.
- **Upstream:** ensaio na branch `upstream-1.5.3-2026-11-16` (merge do `master`, 28 commits além da 1.5.3):
  sem conflito, rebrand todo "ok". Não juntado à `tecnomax` (regra: só tag estável; ver o PLANO, seção 1).
- Dry-run do rebrand na `melhorias-2026-11-16`: 50 trocas ok (técnica) e 51 (Suporte); aplicado de
  verdade no worktree e conferido o diff de `windows.rs` e `config.rs`.
- Build local não tentado: esta máquina não tem MSVC/Windows SDK, Rust, Flutter nem LLVM, e o C++ do
  Visual Studio só instala com elevação.

## Servidor de produção (desde 15/11/2026) — leia primeiro
- **O servidor saiu do CT 120 (labsai) e está na VPS Hostinger `vps-dk-qr`** (`ssh vps-dk-qr`, Ubuntu 24.04,
  Campinas), decisão do CEO em 15/11/2026. É a mesma VPS da ponte QR do WhatsApp da DK: 🟠 risco aceito de
  produto da Tecnomax dividir máquina com estrutura de cliente (reinício ou comprometimento de uma afeta a outra).
- Isolado da ponte da DK: usuário de sistema `tcconnect` (sem shell), tudo em `/opt/tecnomax-connect/`
  (`bin/` hbbs 1.1.17 do fork + hbbr + cloudflared 2026.10.7, mesmos SHA256 do CT 120; `dados/` chave
  `id_ed25519` e banco; `tunel/` credencial e `config.yml`). Serviços systemd `tecnomax-connect-hbbs`,
  `-hbbr` e `-tunel` (com `ProtectSystem=strict`). Logs: `journalctl -u tecnomax-connect-*`.
- **Mesma chave do hbbs** (pública `vTVBcMvy…o7M=`) e **mesmo túnel** `connect-teste`
  (`cdf3d124-…`): nenhum cliente precisou de build novo e o DNS não mudou. Métricas do cloudflared em
  `127.0.0.1:20242` (a `20241` é do túnel da ponte da DK). ufw da VPS segue só com a 22: nada exposto.
- Virada em 15/11/2026: CT parado 14:57:55 UTC, VPS no ar 14:58:04 UTC (~10 s). Os 4 IDs ativos
  registraram de novo às 14:58:23 UTC. O banco do CT **não** foi copiado (falha no comando de cópia); o
  hbbs começou com banco novo e os clientes se registraram sozinhos. Cópia do banco antigo segue no CT 120.
- **Sessões reais pela VPS aprovadas pelo Yago em 15/11/2026** (Dell → outra máquina; hbbr `got paired`
  às 12:09, 12:14 e 12:14 BRT). Serviços sem reinício, túnel sem erro.
- **CT 120 apagado em 15/11/2026** (`pct destroy 120 --purge`, a pedido do Yago). Ficaram no labsai os backups
  `vzdump-lxc-120-2026_11_14` e `_15` (storage `backup`, ~275 MB cada) como cópia da chave do hbbs até ela
  estar no Bitwarden; depois, apagar os dois (não somem sozinhos: o CT saiu do job de backup).
- `Environment=HOME=/opt/tecnomax-connect/dados` nos serviços hbbs/hbbr (o hbbs logava "Failed to store
  config" por causa do `ProtectHome`; inofensivo). Vale no próximo reinício dos serviços.

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
- **Site no ar (09/11/2026):** `www.tecnomax.tech/connect` (noindex, fora do sitemap durante o piloto) e
  cartão na `/suporte`; o botão baixa `releases/latest/download/TecnomaxConnect-x64.exe`.
- **Correções da noite de 09/11/2026 (release `connect-v2026.11.09-eacec60`):**
  - nome técnico sem espaço (`TecnomaxConnect`, variável `TM_APP_ID`) para a instalação no Windows passar
    na validação do upstream; o nome exibido segue "Tecnomax Connect" (commit `4f08cd4`). A pasta de
    configuração mudou para `%APPDATA%\TecnomaxConnect`: quem usou a versão anterior ganha chave nova;
  - tela "Servidor ID/Relay" escondida (`hide-server-settings=Y` em `BUILTIN_SETTINGS`, commit `eacec60`);
  - conferido: SHA256 do download igual ao publicado; o portátil abre, registra por `wss` e mostra o título certo.
- **Sessões reais pelo servidor do piloto** em 09/11/2026 (20:04 e 20:05 UTC), pelo relay, com encerramento normal.
- **Compra do RustDesk Server Pro: decidida e anulada pelo CEO no mesmo dia (09/11/2026).** Segue o fork próprio; não propor de novo.
- **Release `connect-v2026.11.09-0d501ee` (09/11/2026 21:34 UTC):** a instalação passa a renomear o exe
  copiado (`rustdesk.exe` → `TecnomaxConnect.exe`); antes falhava com "exit code 9059" e "O Windows não
  pode encontrar ...TecnomaxConnect.exe". SHA256 do download conferido. Instalação ainda não testada (pede elevação).
- **Plano de atualização (09/11/2026):** `tecnomax/PLANO-ATUALIZACAO.md` — verificação a cada 30 dias
  (tarefa agendada "Tecnomax Connect — verificação mensal de atualização", todo dia 9, 1ª em 09/12/2026;
  só verifica e entrega relatório). Base em 09/11/2026: cliente na tag 1.5.3 (pré-lançamento; estável é a
  1.5.1), servidor em 1.1.16 + 25 commits.
- **Tecnomax Connect é o acesso remoto oficial (decisão do CEO, 09/11/2026):** site em produção na versão
  `8625218d` — `/suporte` só com o Connect (AnyDesk removido de vez), `/connect` indexável e com a
  pergunta "Preciso instalar?", lista de tecnologias trocada. Rollback: `561966a4` (com AnyDesk em
  "Outros sistemas") ou `810f8864` (piloto).
- **Pacote mais limpo para antivírus (commit `7e69e139c`):** metadados Tecnomax no programa instalado, exe
  interno `TecnomaxConnect.exe` (portátil extrai em `%LOCALAPPDATA%\tecnomaxconnect`), `.zip` na release,
  MSI experimental como artefato e **modo privacidade removido** (variável `TM_SEM_MODO_PRIVACIDADE=1`,
  decisão do CEO). Publicado como **pré-lançamento** `connect-v2026.11.10-7e69e13-teste` (abre e mostra a
  janela; instalação não testada). O `latest` segue `connect-v2026.11.09-0d501ee`.
- **Release `connect-v2026.11.10-7e69e13` é a oficial (latest) desde 10/11/2026 01:24 UTC.** Mesmos arquivos do
  pré-lançamento `-teste` (SHA256 do `.exe` `5adfb739…6b24`), sem build novo (o Actions está bloqueado). Testado na
  ialabs: Defender sem detecção (assinaturas 1.463.217.0); instalação completa ok (pasta, serviço `TecnomaxConnect`
  automático, atalhos, desinstalador, metadados "Tecnomax"); serviço registrado no hbbs (ID 287322631); a Dell
  conectou e o Yago viu a tela (hbbr `got paired` 01:22:56 UTC, 64 ms). O botão da `/connect` baixa este arquivo
  (hash conferido pelo link `releases/latest/download`). O pré-lançamento `-teste` ficou publicado como histórico.
- **Atualização por cima testada (10/11/2026 ~01:27 UTC):** na Dell, com a versão anterior instalada, o `.exe`
  novo mostrou "Your installation is lower version" → "Click to upgrade" (compara `BuildDate` do registro com o
  do exe em execução e roda `update_me`, copiando o próprio arquivo; nada é baixado). A Dell voltou a registrar
  no hbbs às 01:27:43 com o mesmo ID (277858512). O aviso "nova versão do RustDesk" (que baixa do site da
  RustDesk) não aparece no Connect: `is_custom_client()` é verdadeiro porque o `APP_NAME` foi trocado.
- Túnel do CT 120 em **HTTP/2** desde 10/11/2026 00:19 UTC (QUIC caía; cópia em `config.yml.bak-quic`).
- Decisões de 09/11/2026: conexão direta (WebRTC) fica para depois; servidor fica no labsai por ora;
  preparar pedido à SignPath (rascunho em `ANTIVIRUS-FALSO-POSITIVO.md`); quem detecta é o Defender.

## Aprendido
- Dois apps na mesma máquina (RustDesk oficial + Tecnomax Connect) usam o **mesmo ID** (vem do hardware) com
  chaves diferentes; o servidor atende quem registrou por último e a conexão falha de forma intermitente
  ("Falha ao conectar ao servidor de rendezvous"). Não deixar os dois abertos apontando para o nosso servidor.
- **Tela preta não é bug do produto quando a máquina controlada está em RDP**: com a janela do RDP
  minimizada ou desconectada o Windows para de desenhar e a captura vem preta (vídeo chega e decodifica
  normal). Testar em máquina física ou pelo console da VM. Diagnóstico de 09/11/2026.
- Quem controla de dentro de uma sessão RDP deve desligar "renderização por textura"
  (`use-texture-render = 'N'` no `_local.toml`).
- O hbbs descarta no arranque o relay cujo nome não resolve (`relay-servers=[]`). Depois de criar um nome no
  DNS, conferir essa linha no log e reiniciar o hbbs se vier vazia.

## Observação
O `rebrand.py` altera o submódulo `libs/hbb_common` no próprio build. Por isso o fork
`tecnomax-sudo/hbb_common` não é necessário hoje.

## Pendências
- 🔴 **GitHub Actions desativado no repositório pelo GitHub** (10/11/2026 ~00:18 UTC): o run 42721997868
  foi cancelado na limpeza final e todo disparo responde "Actions has been disabled for this repository",
  embora a configuração do repo mostre ligado. Sem isso não há build novo. O Yago precisa ver o e-mail/aviso
  do GitHub na conta `tecnomax-sudo` e, se for o caso, abrir chamado no suporte.
  **10/11/2026 ~01:15 UTC:** novo disparo de teste ainda recusado (422); nenhuma notificação na conta e
  nenhum e-mail localizado. **Chamado aberto no suporte do GitHub: #4979864** (Repositories → Repository
  access issues, tipo "erros/problemas de Actions"); resposta vai para `tecnomax@tecnomax.cloud`. Conta
  gratuita ("Technical support not included"). Provável filtro automático: conta criada em 04/11/2026 e vários
  builds Windows de ~40 min em 09/11/2026 (inferência, não confirmada).
- ✅ ~~Servidor depois do piloto~~: migrado para a VPS `vps-dk-qr` em 15/11/2026 (ver o topo).
- 🟠 Servidor na mesma VPS da ponte QR da DK (decisão do CEO de 15/11/2026, risco aceito).
- 🟡 VPS sem backup semanal da Hostinger (decisão anterior, da DK): a chave `id_ed25519` precisa estar no
  Bitwarden — sem ela, todo cliente instalado exige build novo.
- 🔵 Cota mensal de tráfego do plano KVM 1 não conferida (piloto gasta ~15 GB/mês, estimado de 6 dias).
- 🟠 Sem assinatura de código (decisão do CEO): orientar o cliente de teste sobre o aviso do Windows.
- 🟡 Gerar o par de chaves para o `custom.txt` (`TM_CUSTOM_PUB_KEY`), se for usar configuração por cliente.
- 🟡 Instalador MSI: pronto no workflow (input `msi`, com fabricante e links da Tecnomax) desde
  16/11/2026, **não compilado** (Actions bloqueado). Antes de publicar: um build com `msi=true` e
  `publicar=false` e instalação numa VM de teste.
- ✅ ~~O `.exe` interno ainda se chama `rustdesk.exe`~~: é `TecnomaxConnect.exe` desde o commit `7e69e13`
  (portátil extrai em `%LOCALAPPDATA%\tecnomaxconnect`).
- ✅ ~~Testar a instalação completa~~: testada em 10/11/2026 com a release `7e69e13` (ver "Feito"). A
  conferência visual de que a tela "Servidor ID/Relay" sumiu segue no checklist do `PLANO-ATUALIZACAO.md`.
- 🔵 A consulta de "online" da lista de recentes falha por WebSocket (`query onlines ... Connection reset`):
  as bolinhas de online não acendem. Não impede conectar. Correção é no servidor (avaliação de 15/11/2026, item 7).
- 🔵 O atalho do Menu Iniciar e o "Editor" no desinstalador saem como "TecnomaxConnect" (nome técnico):
  **corrigido no `rebrand.py` em 16/11/2026, não compilado**. Vale para instalação nova; quem só clicar em
  "atualizar" (`update_me`) mantém os atalhos antigos até reinstalar.
- 🔵 macOS e Android: identificador do app e notarization ficam para depois do Windows.
