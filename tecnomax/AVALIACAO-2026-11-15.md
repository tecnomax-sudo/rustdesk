---
projeto: acesso-remoto-tecnomax
tipo: avaliacao
data: 15/11/2026
base: release connect-v2026.11.10-7e69e13, servidor na VPS vps-dk-qr
---

# Avaliação do Tecnomax Connect — melhorias e otimizações

O que está bom: rebrand à prova de upstream (cada troca exige achar o alvo uma vez, senão para), ações do
workflow fixadas por SHA, servidor sem porta aberta e isolado em usuário próprio, e a VPS sobrando
(load 0,00, 624 MB de 3,9 GB de RAM em uso, 7% do disco). Os pontos abaixo são o que mudaria, em ordem.

## 🔴 Prioridade 1 — destravar e proteger o build

**1. Workflow mais leve (ajuda no chamado #4979864 e evita novo bloqueio).** Cada build Windows leva
~40 min, e hoje ele roda em três situações desnecessárias:
- dispara sozinho a cada push em `rebrand.py`/`marca/` (foi assim que saíram vários builds em 09/11/2026);
- o job `build-topmost` compila a DLL do modo privacidade mesmo com `TM_SEM_MODO_PRIVACIDADE=1`, quando ela
  nem entra no pacote;
- o MSI experimental roda em todo build.

Proposta: só disparo manual, `build-topmost` e MSI condicionais, `timeout-minutes` nos jobs. Menos minutos
por build e nenhum build involuntário. Mexe só no workflow: não dispara nada enquanto o Actions estiver
desligado.

**2. Motor do Flutter baixado sem trava.** O passo "Replace engine" baixa
`rustdesk/engine/releases/download/main/windows-x64-release.zip`, que é um arquivo que muda sem aviso e sem
conferência de hash. Dois builds do mesmo commit podem sair diferentes, e se aquele release for trocado,
entra no nosso `.exe`. Proposta: fixar a versão e conferir o SHA256 antes de usar.

**3. Plano B do build, se o GitHub não responder.** Um runner próprio (VM Windows no labsai) registrado no
**mesmo** repositório. Não é contornar o bloqueio com outro repositório. Fica como opção para quando o
chamado demorar demais; decisão sua.

## 🟠 Prioridade 2 — servidor

**4. Relay aberto para quem tiver o `.exe`.** A chave pública vai dentro do instalador público, então
qualquer pessoa com o Connect pode usar o nosso relay, e todo o tráfego de vídeo passa pela VPS e pela
Cloudflare. O hbbr do fork já tem limites prontos que hoje estão no padrão (1 Gbit/s total, 128 Mbit/s por
sessão): `TOTAL_BANDWIDTH`, `SINGLE_BANDWIDTH`, `LIMIT_SPEED`. Proposta: limitar ao que a VPS aguenta e
deixar um teto por sessão. Complemento: regra de limite de requisições na Cloudflare para `/ws/id`.

**5. Ninguém avisa se o Connect cair.** Hoje a queda só seria notada quando um cliente reclamasse. Proposta:
uma verificação de fora (a cada 5 min, de outra máquina) que abre o WebSocket de `/ws/id` e espera a
resposta 101, com alerta por e-mail.

**6. 🟡 Termos da Cloudflare.** O plano gratuito restringe uso "desproporcional" com vídeo. Sessões de
suporte são poucas e curtas (~15 GB/mês estimado), mas se o volume crescer, o relay (só `/ws/relay`) pode
precisar sair do túnel. Não é para agir agora; vale acompanhar o volume.

## 🟡 Prioridade 3 — produto

**7. Bolinhas de "online" não acendem: causa encontrada.** No hbbs, a consulta de online só é atendida na
porta TCP 21115 (`handle_listener2`, linha ~1253 de `src/rendezvous_server.rs`), que não está no túnel. O
caminho WebSocket (`/ws/id`) não trata `OnlineRequest`. A correção é no fork do servidor: responder essa
mensagem também na sessão WebSocket. Não precisa de build do cliente.

**8. Duas versões do Connect: "Suporte" e "Técnico".** O RustDesk aceita, como configuração fixa, o modo
**só receber conexões** (`conn-type=incoming`). Com isso, o cliente final teria um programa que só mostra
o ID e a senha, como o "QuickSupport" do AnyDesk. É mais simples para ele e não serve para controlar
terceiros, o que também reduz o uso do nosso relay por estranhos (ponto 4). O técnico continua com a
versão completa. Custo: um segundo build no mesmo workflow, com uma variável a mais.

**9. Acesso sem ninguém do outro lado (clientes de contrato).** Definir senha permanente na instalação
(`--password` por script) e o modo de aprovação, para servidor e máquina gerenciada. Hoje cada acesso
depende de alguém ler a senha temporária.

**10. MSI para implantação em lote.** O MSI já é gerado como experimental. Testado e publicado, ele permite
instalar por GPO/RMM com a senha permanente já definida (ponto 9).

**11. Upstream 28 commits à frente (tag 1.5.3).** Fazer o primeiro ciclo do `PLANO-ATUALIZACAO.md` assim
que o Actions voltar, junto com o item 1.

## 🔵 Ajustes menores

- O WebSocket ocioso fecha em ~40 s. Isso aparece como 14 "client disconnected" no túnel em 15 h:
  inofensivo, mas polui o log e pode esconder erro real.
- O atalho do Menu Iniciar e o "Editor" no desinstalador saem como "TecnomaxConnect".
- `rebrand.py` linhas 137–139: o comentário do WebSocket fixo ficou emendado no da tela de servidor.
- `ESTADO-ATUAL.md` tem pendências já resolvidas: o `.exe` interno já se chama `TecnomaxConnect.exe` desde
  o `7e69e13`, e a instalação completa foi testada em 10/11/2026.
- Ordem sugerida: 1 → 7 → 4 → 5 → 2 → 8/9/10 → 11.
