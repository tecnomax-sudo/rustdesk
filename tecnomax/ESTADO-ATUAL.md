---
projeto: acesso-remoto-tecnomax
atualizado: 10/11/2026
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
  interno `TecnomaxConnect.exe` (portátil extrai em `%LOCALAPPDATA%	ecnomaxconnect`), `.zip` na release,
  MSI experimental como artefato e **modo privacidade removido** (variável `TM_SEM_MODO_PRIVACIDADE=1`,
  decisão do CEO). Publicado como **pré-lançamento** `connect-v2026.11.10-7e69e13-teste` (abre e mostra a
  janela; instalação não testada). O `latest` segue `connect-v2026.11.09-0d501ee`.
- **Release `connect-v2026.11.10-7e69e13` é a oficial (latest) desde 10/11/2026 01:24 UTC.** Mesmos arquivos do
  pré-lançamento `-teste` (SHA256 do `.exe` `5adfb739…6b24`), sem build novo (o Actions está bloqueado). Testado na
  ialabs: Defender sem detecção (assinaturas 1.463.217.0); instalação completa ok (pasta, serviço `TecnomaxConnect`
  automático, atalhos, desinstalador, metadados "Tecnomax"); serviço registrado no hbbs (ID 287322631); a Dell
  conectou e o Yago viu a tela (hbbr `got paired` 01:22:56 UTC, 64 ms). O botão da `/connect` baixa este arquivo
  (hash conferido pelo link `releases/latest/download`). O pré-lançamento `-teste` ficou publicado como histórico.
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
- 🟠 **Servidor depois do piloto**: o CT 120 fica no labsai, que é laboratório, está na rede do RI e
  tem histórico de travar a placa de rede. Migrar ao fim do piloto (continua pelo túnel, sem porta aberta).
- 🟠 Sem assinatura de código (decisão do CEO): orientar o cliente de teste sobre o aviso do Windows.
- 🟡 Gerar o par de chaves para o `custom.txt` (`TM_CUSTOM_PUB_KEY`), se for usar configuração por cliente.
- 🟡 Instalador MSI (o workflow gera só o `.exe` portátil).
- 🟡 O `.exe` interno ainda se chama `rustdesk.exe`: o portátil extrai para `%LOCALAPPDATA%\rustdesk`, a mesma pasta do RustDesk oficial (a configuração fica separada, em `%APPDATA%\Tecnomax Connect`).
- 🟡 Testar a **instalação completa** (botão Instalar, pede elevação) com a release `0d501ee` e conferir
  visualmente que a tela de servidor sumiu.
- 🔵 A consulta de "online" da lista de recentes falha por WebSocket (`query onlines ... Connection reset`):
  as bolinhas de online não acendem. Não impede conectar.
- 🔵 O atalho do Menu Iniciar e o "Editor" no desinstalador saem como "TecnomaxConnect" (nome técnico).
- 🔵 macOS e Android: identificador do app e notarization ficam para depois do Windows.
