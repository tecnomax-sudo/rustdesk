---
projeto: acesso-remoto-tecnomax
tipo: prompt-de-continuidade
gerado: 09/11/2026
---

# Prompt para continuar o Tecnomax Connect em outra sessão

Cole o bloco abaixo no Claude Code da outra máquina.

```
Vou continuar o projeto Tecnomax Connect (acesso remoto próprio da Tecnomax, fork do RustDesk).
Antes de qualquer coisa, leia nesta ordem:
1. As regras de trabalho (AGENTS.md / MCP Tecnomax `ler_regras`) e a memória
   `projeto-acesso-remoto-tecnomax` (clone de tecnomax-sudo/tecnomax-conhecimento ou MCP `ler`).
   Faça `git pull` no clone do conhecimento primeiro.
2. No fork do cliente (`gh repo clone tecnomax-sudo/rustdesk`, branch `tecnomax`):
   `tecnomax/ESTADO-ATUAL.md`, `tecnomax/PLANO-ATUALIZACAO.md`, `tecnomax/ANTIVIRUS-FALSO-POSITIVO.md`
   e `tecnomax/rebrand.py`.
3. O fork do servidor (`tecnomax-sudo/rustdesk-server`, branch `tecnomax`) e o site
   (`tecnomax-sudo/tecnomax-site`, branch `master`; skill `tecnomax-site`).

Estado em 09/11/2026 (noite):
- O Tecnomax Connect é o acesso remoto OFICIAL. Site em produção (versão 8625218d): /suporte só com o
  Connect, AnyDesk removido, /connect indexável.
- Release oficial (latest): connect-v2026.11.09-0d501ee — abre, instala e conecta (confirmado pelo Yago).
- Pré-lançamento connect-v2026.11.10-7e69e13-teste: correções para antivírus (metadados Tecnomax, exe
  interno TecnomaxConnect.exe, .zip, sem modo privacidade). Abre; INSTALAÇÃO NÃO TESTADA.
- Servidor: CT 120 no labsai (`ssh labsai`, `pct exec 120`), hbbs/hbbr do nosso fork atrás do túnel
  Cloudflare connect.tecnomax.tech, agora em HTTP/2.

Decisões do CEO que NÃO se reabrem: fork próprio (compra do RustDesk Server Pro anulada); só
Cloudflare, sem porta aberta; sem compra de certificado de assinatura; servidor fica no labsai por
ora; conexão direta (WebRTC) fica para depois; modo privacidade fora do pacote; AnyDesk fora do site.

Pendências, em ordem:
1. 🔴 O GitHub desativou o Actions no repositório tecnomax-sudo/rustdesk (10/11/2026 ~00:18 UTC):
   disparo responde "Actions has been disabled for this repository". Pergunte ao Yago o que o aviso
   do GitHub dizia. Sem isso não há build novo. Não contornar criando outro repositório.
2. 🟡 Testar a instalação do pré-lançamento 7e69e13-teste (o Yago clica; pede elevação) e, se passar,
   promover a latest (o botão do site baixa releases/latest/download/TecnomaxConnect-x64.exe).
3. 🟡 Defender: pedir ao Yago o nome exato da detecção e o arquivo; ele envia o falso positivo à
   Microsoft e, se quiser, o pedido à SignPath (textos prontos no ANTIVIRUS-FALSO-POSITIVO.md).
4. 🟡 Teste de conexão com a máquina controlada FORA de RDP (em RDP minimizado a tela vem preta: não é bug).
5. 🟡 Confirmar se a chave privada do hbbs (id_ed25519, só no CT 120) está no Bitwarden.
6. 🔵 Bolinhas de "online" não acendem (query onlines falha por WebSocket); atalho do Menu Iniciar
   sai "TecnomaxConnect"; hbbs fecha sessão WS ociosa após 40 s; comparar quedas do túnel em HTTP/2.
7. Verificação mensal de atualização: a tarefa agendada ficou na YAGO-PC (dia 9, 09:00). Se esta
   máquina passar a ser a principal, recriar aqui seguindo o PLANO-ATUALIZACAO.md.

Como trabalhar: português do Brasil; dev explicado em linguagem leiga; executar e testar de verdade
antes de concluir; o rebrand só roda no CI (nunca na cópia de trabalho principal; `trocar()` insere
texto literal e exige casar exatamente uma vez); push em tecnomax/rebrand.py ou no workflow dispara
build e cancela o que estiver rodando; deploy público do site pede ok uma vez; segredo só no
Bitwarden; ao encerrar, atualizar ESTADO-ATUAL.md e a memória.
Comece conferindo o estado real (git log dos três repositórios, `gh release list`, serviços do CT 120)
e me diga em poucas linhas o que encontrou antes de agir.
```
