---
projeto: acesso-remoto-tecnomax
documento: plano de atualização do Tecnomax Connect
criado: 09/11/2026
ciclo: a cada 30 dias (verificação agendada para o dia 9 de cada mês)
responsavel: Yago Salbego Ramos
---

# Plano de atualização — Tecnomax Connect

O Tecnomax Connect é uma **cópia nossa (fork)** do RustDesk com a marca da Tecnomax aplicada por cima.
Pense numa edição própria de um livro: o autor (RustDesk) continua publicando capítulos novos, e a nossa
edição só ganha esses capítulos quando nós os trazemos. Este plano diz **quando trazer, como trazer e
como voltar atrás**.

São duas peças, atualizadas em separado:

| Peça | Repositório nosso | Original (upstream) | Onde roda |
|---|---|---|---|
| **Cliente** (o programa que o cliente baixa) | `tecnomax-sudo/rustdesk`, branch `tecnomax` | `rustdesk/rustdesk` | PCs com Windows |
| **Servidor** (hbbs = "central telefônica", hbbr = "ponte" da sessão) | `tecnomax-sudo/rustdesk-server`, branch `tecnomax` | `rustdesk/rustdesk-server` | CT 120 no labsai |

## 1. Retrato em 09/11/2026

| Item | Cliente | Servidor |
|---|---|---|
| Nossa base | commit `95cca3f`, que é exatamente a tag **1.5.3** | commit `680b603` = **1.1.16 + 25 commits** (o código já se declara 1.1.17, ainda não lançada) |
| Última versão **estável** do original | **1.5.1** (01/11/2026) | **1.1.16** (20/07/2026) |
| Última publicada | 1.5.3 (09/11/2026), marcada como **pré-lançamento** | 1.1.16 |
| Nossas mudanças por cima | 14 commits, só em `tecnomax/` e no workflow (a marca entra pelo `rebrand.py` na hora do build) | 1 mudança de código: registro por WebSocket em `src/rendezvous_server.rs` |
| Em produção | release `connect-v2026.11.09-0d501ee` | `/usr/local/bin/hbbs` e `hbbr` compilados em 09/11/2026 (run 42652418950) |

Avisos de segurança publicados no GitHub para os dois repositórios originais em 09/11/2026: **nenhum**.
A 1.5.3 traz correções de endurecimento (relay só para endereços que o próprio peer ofereceu; bloqueio de
opções sensíveis em atualização de estratégia), e nós já estamos nela.

🟡 **Ponto de atenção:** hoje a nossa base é um **pré-lançamento** (1.5.3) no cliente e um ponto **entre
versões** no servidor. Foi o que estava no ar no dia em que o fork nasceu. Não é para voltar atrás agora
(o piloto está funcionando), mas a partir do próximo ciclo a regra é a da seção 3.

## 2. Como a versão é escolhida hoje

- O build **não** busca nada no original sozinho. Ele compila o que estiver na nossa branch `tecnomax`.
  Ou seja: a versão só muda quando alguém junta (merge) o original na nossa branch. Isso é bom — nada
  muda sem decisão.
- Cliente: `.github/workflows/tecnomax-windows.yml`. Roda `tecnomax/rebrand.py` e compila. Só publica
  release quando disparado à mão com `publicar=true`.
- Servidor: `.github/workflows/tecnomax-build.yml`. Roda os testes, compila `hbbs` e `hbbr` e entrega
  como artefato. **Não há instalação automática** no CT 120: os binários são copiados à mão.

## 3. Regra de base: sempre uma versão estável com nome

**Recomendação:** juntar o original **somente em tag estável** (ex.: `1.5.4`), nunca no `master` do dia
nem em pré-lançamento.

Por quê:
- O `master` é a bancada de trabalho deles: muda todo dia e pode ter defeito ainda não percebido.
  Uma versão estável é a que eles mesmos distribuem para todo mundo.
- Com uma tag, dá para dizer ao cliente e a nós mesmos "o Tecnomax Connect está na 1.5.x" e comparar com
  as notas de versão oficiais. Com um commit solto, não.
- Quando aparecer um defeito, fica fácil saber se é nosso ou deles: basta testar o RustDesk oficial da
  mesma versão.

Exceção: correção de segurança que só exista no `master`. Aí se traz **só aquela correção**
(`git cherry-pick`), não o `master` inteiro.

## 4. Critério de decisão (a cada verificação)

| Situação encontrada | Decisão |
|---|---|
| Aviso de segurança (GHSA/CVE) que atinge a nossa versão, no cliente ou no servidor | 🔴 **Atualizar já**, fora do ciclo |
| Versão **estável** nova (não marcada "pre-release") | 🟡 **Atualizar neste ciclo** |
| Só pré-lançamento, nightly ou commits no `master` | 🔵 **Não atualizar**; anotar e olhar de novo em 30 dias |
| Versão estável nova, mas alguma troca do `rebrand.py` deixou de casar e o conserto não é simples | 🟠 Segurar na versão atual, registrar o motivo, resolver antes do ciclo seguinte |
| Mudança no protocolo entre cliente e servidor (ver seção 7) | 🟠 Atualizar **servidor primeiro**, cliente depois |

## 5. Fontes oficiais — o que olhar

| Fonte | O que olhar |
|---|---|
| `github.com/rustdesk/rustdesk/releases` | Última versão **sem** o selo "Pre-release"; a lista "Changelog" (Added / Changes / Fixes) |
| `github.com/rustdesk/rustdesk-server/releases` | Idem, para o servidor |
| `github.com/rustdesk/rustdesk/security/advisories` e o mesmo no `rustdesk-server` | Avisos de segurança e a versão que corrige |
| `rustdesk.com/docs` (seções *Self-host* e *Client*) | Mudança de porta, de opção de configuração, de requisito do servidor, do modo WebSocket |
| `.github/workflows/flutter-build.yml` do original | Se mudou a versão do Flutter, do Rust, do LLVM ou os passos de build — o nosso workflow é cópia de um pedaço dele e precisa acompanhar |
| Base de CVEs (NVD, busca por "RustDesk") | Vulnerabilidade divulgada fora do GitHub |

Por linha de comando, na máquina com o `gh` logado:

```bash
gh api repos/rustdesk/rustdesk/releases --jq '.[0:6][]|"\(.tag_name) pre=\(.prerelease) \(.published_at[0:10])"'
```

```bash
gh api repos/rustdesk/rustdesk-server/releases --jq '.[0:4][]|"\(.tag_name) pre=\(.prerelease) \(.published_at[0:10])"'
```

## 6. Passo a passo do ciclo

### 6.1 Verificar (automático, todo dia 9)
A tarefa agendada **"Tecnomax Connect — verificação mensal de atualização"** faz esta parte sozinha e
entrega um relatório. Ela **não** publica nada, **não** mexe no servidor e **não** faz deploy.

1. Lê este plano e o `ESTADO-ATUAL.md`.
2. Consulta as fontes da seção 5 e compara com a nossa base.
3. Aplica o critério da seção 4.
4. Se houver versão estável nova: prepara uma branch de ensaio e roda o `rebrand.py` em modo de
   conferência (seção 6.2, passos 1 a 3), sem enviar nada para o GitHub.
5. Entrega o relatório: versão nossa × versão oficial, o que mudou que nos interessa, resultado do
   ensaio e a recomendação. **A decisão de atualizar é do Yago.**

### 6.2 Atualizar o cliente (depois do "pode")

1. Buscar o original e criar a branch de ensaio a partir da nossa:

   ```bash
   git -C C:/Tecnomax/projetos/rustdesk fetch upstream --tags
   ```

   ```bash
   git -C C:/Tecnomax/projetos/rustdesk switch -c atualiza-<versão> tecnomax
   ```

   ```bash
   git -C C:/Tecnomax/projetos/rustdesk merge <tag estável>
   ```

   Conflito só pode aparecer em `.github/workflows/` (os nossos arquivos em `tecnomax/` não existem no
   original). O submódulo `libs/hbb_common` acompanha a tag: `git submodule update --init --recursive`.

2. **Ensaio do rebrand** (confere se cada troca ainda acha o alvo, sem gravar nada):

   ```bash
   cd C:/Tecnomax/projetos/rustdesk && TM_DRY_RUN=1 TM_RENDEZVOUS_SERVER=connect.tecnomax.tech TM_RS_PUB_KEY=x python tecnomax/rebrand.py
   ```

   Todas as linhas precisam sair "ok". O `rebrand.py` funciona como "localizar e substituir" com trava:
   cada troca exige achar o trecho **exatamente uma vez**. Se o original reescreveu aquele trecho, a
   troca acusa erro em vez de estragar o código em silêncio.

3. **Quando uma troca não casa mais:**
   - abrir o arquivo indicado na versão nova e achar onde o trecho foi parar (`git log -S"<texto>" -- <arquivo>` mostra o commit que mexeu);
   - ajustar o padrão da troca no `rebrand.py`; se o original passou a resolver o problema sozinho
     (ex.: uma opção oficial que faz o que a nossa troca fazia), **remover** a troca;
   - se achou zero ou mais de uma vez, nunca "afrouxar" o padrão até passar: entender a mudança primeiro;
   - rodar o ensaio de novo até tudo sair "ok".
   - ⚠️ O rebrand só roda de verdade no build. Na cópia de trabalho, só o ensaio (`TM_DRY_RUN=1`).

4. Comparar o nosso workflow com o `flutter-build.yml` da versão nova (job do Windows x64): versão do
   Flutter, do Rust, do LLVM, passos novos. Copiar o que mudou para o `tecnomax-windows.yml`.

5. Enviar a branch de ensaio e disparar o build **sem publicar** (`publicar=false`). O `.exe` sai como
   artefato do run, e o download do site continua na versão anterior.

6. **Teste em duas máquinas fora de RDP** (checklist da seção 8). Máquina controlada em RDP dá tela
   preta e invalida o teste.

7. Aprovado: juntar a branch de ensaio na `tecnomax`, disparar o build com `publicar=true`. A release
   nova vira o download da página `/connect` sozinha (o link aponta para `releases/latest`).

8. Conferir: SHA256 do download igual ao publicado; página `www.tecnomax.tech/connect` baixando a
   versão nova; instalação por cima da antiga numa máquina de teste.

### 6.3 Atualizar o servidor (depois do "pode")

1. Mesma ideia: `fetch upstream --tags`, branch de ensaio, `merge <tag estável>`.
   Aqui **pode haver conflito de verdade** em `src/rendezvous_server.rs`, porque a nossa mudança mora
   dentro de um arquivo do original. Se o original passar a oferecer registro por WebSocket por conta
   própria, a nossa mudança sai e passamos a usar a deles.
2. O workflow `tecnomax-build.yml` roda os testes e compila. Sem teste verde, não segue.
3. No CT 120, **antes de trocar**:
   - snapshot do container no Proxmox (`pct snapshot 120 antes-<versão>`);
   - cópia de `/var/lib/rustdesk-server/id_ed25519` e `id_ed25519.pub`. **Essa chave é a identidade do
     servidor: está gravada dentro de todo `.exe` distribuído. Se ela se perder, todos os clientes param
     de confiar no servidor e precisam baixar o programa de novo.** A cópia da chave privada vai para o
     Bitwarden, nunca para arquivo solto, git ou chat;
   - guardar os binários atuais: `cp /usr/local/bin/hbbs /usr/local/bin/hbbs.anterior` (idem `hbbr`).
4. Baixar o artefato do run, conferir o SHA256, copiar para `/usr/local/bin/`, reiniciar
   `rustdesk-hbbr` e `rustdesk-hbbs`.
5. Conferir no log (`/var/log/rustdesk-server/hbbs.log`): linha `relay-servers=["connect.tecnomax.tech"]`
   (se vier vazia, reiniciar o hbbs), `Listening on websocket`, e as máquinas voltando a registrar
   (`WS peer session from ...`).
6. Sessão de teste entre duas máquinas.

A troca derruba o registro por alguns segundos; sessões em andamento passam pelo hbbr e caem quando ele
reinicia. Fazer fora do horário de atendimento.

### 6.4 Fechar o ciclo
- Atualizar `tecnomax/ESTADO-ATUAL.md` (versão base nova, release, o que mudou no rebrand).
- Atualizar a memória `projeto-acesso-remoto-tecnomax` com data absoluta.
- Apagar a branch de ensaio.

## 7. Compatibilidade cliente × servidor

- O nosso cliente registra **só por WebSocket na porta 443** (pela Cloudflare). O servidor original
  não aceita registro por esse caminho; **o nosso aceita, por causa da nossa mudança**. Portanto o
  cliente **depende do nosso servidor**: nunca trocar o hbbs pelo pacote oficial sem a mudança.
- O formato das mensagens entre cliente e servidor vem do `hbb_common` (arquivos `.proto`). Em cada
  atualização, olhar se `rendezvous.proto` mudou entre a versão antiga e a nova:

  ```bash
  git -C C:/Tecnomax/projetos/rustdesk/libs/hbb_common log --oneline <commit antigo>..<commit novo> -- protos/
  ```

  Sem mudança: cliente e servidor podem ser atualizados em qualquer ordem. Com mudança: **servidor
  primeiro**, testar com o cliente antigo, depois o cliente.
- Clientes antigos continuam em campo depois de cada release (não há atualização automática 🟡). O
  servidor novo precisa continuar atendendo a release anterior: testar isso antes de trocar.

## 8. Checklist de teste pós-atualização

Duas máquinas físicas (ou VM pelo console do Proxmox), **nenhuma em RDP**.

- [ ] O portátil abre com o título "Tecnomax Connect" e o ícone de 4 cores
- [ ] Mostra ID e senha, e o status "Pronto" sem configurar nada
- [ ] Configurações → Rede: o item "Servidor ID/Relay" **não aparece**
- [ ] A conecta em B: pede a senha, mostra a **imagem**, teclado e mouse respondem
- [ ] B conecta em A
- [ ] Área de transferência (copiar/colar texto) e transferência de arquivo
- [ ] Instalação pelo botão "Aceitar e Instalar": termina sem erro, existe
      `C:\Program Files\TecnomaxConnect\TecnomaxConnect.exe`, serviço `TecnomaxConnect` rodando
- [ ] Com o programa instalado: conectar com a máquina na tela de bloqueio e com um aviso de UAC aberto
- [ ] Instalar por cima da versão anterior mantém o mesmo ID
- [ ] Desinstalar remove a pasta e o serviço
- [ ] Nenhuma menção a "RustDesk" nas telas principais
- [ ] No servidor: `hbbs.log` sem erro repetido; `hbbr.log` com `got paired` em cada sessão
- [ ] O RustDesk oficial **fechado** nas duas máquinas durante o teste (mesmo ID, chaves diferentes)

## 9. Como voltar atrás

| O que deu errado | Como voltar |
|---|---|
| Release nova do cliente com defeito | As releases antigas continuam no GitHub. Apagar (ou marcar como pré-lançamento) a release ruim: `releases/latest` volta a apontar para a anterior e a página `/connect` passa a baixar a anterior, sem mexer no site. `gh release edit <tag> --repo tecnomax-sudo/rustdesk --prerelease` |
| Quem já instalou a versão ruim | Baixar a anterior pela página e instalar por cima |
| Servidor novo com defeito | `cp /usr/local/bin/hbbs.anterior /usr/local/bin/hbbs` (idem `hbbr`) e reiniciar os dois serviços; se não bastar, `pct rollback 120 antes-<versão>` |
| Branch `tecnomax` com merge ruim | `git revert -m 1 <commit do merge>` e novo build |

## 10. Riscos

- 🔴 **Chave do servidor** (`id_ed25519`) existe só no CT 120. Perda = todos os clientes precisam
  reinstalar. Cópia no Bitwarden antes de qualquer troca. 🟡 confirmar se a cópia já existe.
- 🟠 **Uma pessoa só executa tudo.** Se o ciclo cair numa semana de implantação presencial, a
  verificação automática ainda entrega o relatório; a atualização em si espera, salvo caso 🔴.
- 🟠 **Sem assinatura de código** (decisão do CEO): cada `.exe` novo é um arquivo "nunca visto" para o
  Windows e para os antivírus. Publicar release só quando houver motivo — não a cada verificação.
- 🟠 **Servidor no labsai** (laboratório, com histórico de travar a placa de rede). Enquanto o piloto
  estiver lá, snapshot antes de toda troca.
- 🟡 **Sem atualização automática do cliente.** Quem baixou continua na versão que baixou. Em correção
  de segurança, é preciso avisar os clientes para baixar de novo. 🟡 decidir se e como avisar.
- 🟡 **O workflow é cópia de um pedaço do original.** Se eles mudarem o jeito de compilar e nós não
  acompanharmos, o build quebra — aparece no ensaio sem publicar, não em produção.
- 🟡 **Base atual é pré-lançamento** (1.5.3) e ponto entre versões no servidor. Normaliza no primeiro
  ciclo em que sair estável igual ou mais nova.
- 🔵 A tarefa agendada só roda com o aplicativo do Claude aberto na máquina onde foi criada; se estiver
  fechado no dia 9, roda na próxima abertura.
