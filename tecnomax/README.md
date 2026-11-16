---
projeto: acesso-remoto-tecnomax
base: rustdesk/rustdesk (AGPL-3.0)
branch: tecnomax
atualizado: 16/11/2026
---

# Tecnomax Connect

Cliente de acesso remoto da Tecnomax, construído sobre o [RustDesk](https://github.com/rustdesk/rustdesk).
Este fork é público por exigência da licença AGPL-3.0: quem distribui uma versão modificada precisa
disponibilizar o código dela.

## Como o fork está organizado

O código do RustDesk **não é editado à mão**. Tudo o que é da Tecnomax fica nesta pasta, e o
`rebrand.py` aplica a marca no momento da compilação. Por isso, atualizar para uma versão nova
do RustDesk é só trazer o upstream e compilar de novo:

```bash
git fetch upstream && git merge upstream/master
```

Se o RustDesk mudar algum dos arquivos que o script altera, ele para com erro e não grava nada.
Isso evita gerar um cliente pela metade, metade Tecnomax e metade RustDesk.

## O que o rebrand troca

| O quê | Arquivo |
|---|---|
| Servidor (hbbs) e chave pública padrão | `libs/hbb_common/src/config.rs` |
| Nome do app e organização | `libs/hbb_common/src/config.rs` |
| WebSocket sempre ligado (`allow-websocket=Y` em `OVERWRITE_SETTINGS`) | `libs/hbb_common/src/config.rs` |
| `wss` sempre que o servidor for domínio (o original exigia `api-server` em https) | `libs/hbb_common/src/websocket.rs` |
| Chave que valida o `custom.txt` (a da RustDesk sai) | `src/common.rs` |
| Nome, descrição e copyright do `.exe` | `Cargo.toml` |
| Título da barra de abas | `flutter/lib/desktop/widgets/tabbar_widget.dart` |
| Atalhos, pasta do Menu Iniciar e "Desinstalar ..." com o nome de exibição; "Editor" = empresa | `src/platform/windows.rs` |
| Só recebe conexões (`conn-type=incoming` em `HARD_SETTINGS`), só com `TM_SO_RECEBER=1` | `libs/hbb_common/src/config.rs` |
| Ícones e logo (se estiverem em `tecnomax/marca/`) | `res/`, `flutter/assets/`, `flutter/windows/runner/resources/` |

Trocar o nome do app tem dois efeitos automáticos no próprio RustDesk:
- os textos traduzidos passam a mostrar o nosso nome no lugar de "RustDesk" (`src/lang.rs`);
- a busca de atualização no site da RustDesk é desligada (`is_custom_client`). Sem isso, o cliente
  poderia se atualizar sozinho para a versão oficial.

## Variáveis

| Variável | Obrigatória | Conteúdo |
|---|---|---|
| `TM_APP_NAME` | não | padrão `Tecnomax Connect`; não pode conter "RustDesk" |
| `TM_RENDEZVOUS_SERVER` | sim | endereço do hbbs |
| `TM_RS_PUB_KEY` | sim | conteúdo do `id_ed25519.pub` gerado pelo hbbs |
| `TM_CUSTOM_PUB_KEY` | não | chave pública da Tecnomax para assinar `custom.txt`; sem ela, o `custom.txt` fica desativado |
| `TM_ORG` | não | padrão `tech.tecnomax` |
| `TM_COPYRIGHT` | não | padrão "<nome>, baseado no RustDesk (AGPL-3.0)" |
| `TM_COMPANY` | não | padrão `Tecnomax` (metadados do `.exe` e "Editor" em Aplicativos instalados) |
| `TM_APP_ID` | não | nome técnico sem espaço (exe, pasta, serviço); padrão `TecnomaxConnect` |
| `TM_SEM_MODO_PRIVACIDADE=1` | não | tira o modo privacidade (cópia do RuntimeBroker + DLL injetada) |
| `TM_SO_RECEBER=1` | não | variante **Suporte**: só recebe conexões; nome de exibição `Tecnomax Connect Suporte`, mesmo nome técnico |
| `TM_DRY_RUN=1` | não | só confere, sem gravar |

A chave **privada** do hbbs nunca entra no repositório: ela fica no servidor e no Bitwarden.
A chave pública não é segredo, porque vai dentro do executável.

## Servidor

O cliente fala só por WebSocket (443), porque o servidor da Tecnomax fica atrás de um Cloudflare
Tunnel, sem porta aberta. O hbbs do upstream não registra o ID por WebSocket; por isso o servidor é
o fork [`tecnomax-sudo/rustdesk-server`](https://github.com/tecnomax-sudo/rustdesk-server)
(branch `tecnomax`), que faz isso.

## Build

O workflow `.github/workflows/tecnomax-windows.yml` compila o Windows x64 **só por disparo manual**
(Actions → tecnomax-windows → Run workflow), com três escolhas:

| Input | Valores | Efeito |
|---|---|---|
| `variante` | `tecnico` (padrão), `suporte`, `ambas` | qual programa compilar (cada um ~40 min, em paralelo) |
| `publicar` | sim/não | cria a release (vira a `latest` e o download do site); exige `tecnico` ou `ambas` |
| `msi` | sim/não | gera também o `.msi` de cada variante; com `publicar`, vai para a release |

Arquivos da release, com nome fixo: `TecnomaxConnect-x64.exe` (o botão da página `/connect` aponta
para `releases/latest/download/TecnomaxConnect-x64.exe`), `TecnomaxConnectSuporte-x64.exe`, os `.zip`,
os `.msi` quando pedidos, e um `.sha256` de cada. Servidor e chave vêm das variáveis do repositório
`TM_RENDEZVOUS_SERVER` e `TM_RS_PUB_KEY`. Os workflows do upstream estão desativados neste fork.

## Duas versões: Técnico e Suporte

- **Tecnomax Connect** (técnico): versão completa, conecta e recebe.
- **Tecnomax Connect Suporte** (cliente final): só mostra ID e senha e só recebe conexões, como um
  "QuickSupport". Não serve para controlar outras máquinas, o que também tira estranhos do nosso relay.

As duas têm o **mesmo nome técnico** (`TecnomaxConnect`: pasta, serviço, configuração e chave). Assim,
instalar a Suporte numa máquina que já tem a versão completa atualiza no lugar, mantendo ID e senha,
em vez de deixar dois serviços disputando o mesmo ID no servidor. Consequência: numa mesma máquina
fica instalada uma ou outra, nunca as duas. Na troca de variante, a pasta do Menu Iniciar da
variante anterior pode ficar para trás (é só apagar).

## Instalação gerenciada (clientes de contrato)

Para entrar sem ninguém do outro lado ler a senha temporária: `tecnomax/instalar-gerenciado.ps1`,
em PowerShell como administrador.

```powershell
.\instalar-gerenciado.ps1                                   # pergunta a senha e baixa a versão técnica
.\instalar-gerenciado.ps1 -Variante Suporte                 # baixa a versão Suporte
.\instalar-gerenciado.ps1 -Instalador C:\Temp\TecnomaxConnect-x64.msi -Verificacao Permanente
```

O que ele faz: instala em silêncio (`<exe> --silent-install` ou `msiexec /i <msi> /qn`), espera o
serviço `TecnomaxConnect`, define a senha permanente (`TecnomaxConnect.exe --password`), grava o
método de verificação (`verification-method`: `use-both-passwords` ou `use-permanent-password`) e o
modo de aprovação (`approve-mode`: `password` = entra só com a senha, sem clique; `click`; vazio =
os dois) e imprime o ID. Download da release conferido pelo `.sha256` publicado.

A senha chega por `-Senha` (SecureString), pela variável de ambiente `TM_CONNECT_SENHA` (variável
secreta do RMM) ou digitada na hora. Ela não é gravada nem mostrada; a senha de cada cliente fica
**só no Bitwarden**. Limite do próprio RustDesk: a senha passa na linha de comando do
`TecnomaxConnect.exe` por alguns segundos (visível para administradores locais na lista de processos).

Os mesmos comandos, à mão (elevado, com o programa instalado):

```powershell
& "$env:ProgramFiles\TecnomaxConnect\TecnomaxConnect.exe" --password "<senha>" | Out-String
& "$env:ProgramFiles\TecnomaxConnect\TecnomaxConnect.exe" --option approve-mode password
& "$env:ProgramFiles\TecnomaxConnect\TecnomaxConnect.exe" --get-id | Out-String
```

### MSI por GPO ou RMM

O `.msi` (input `msi` do workflow) instala o mesmo programa, com fabricante "Tecnomax" e
desinstalação pelo próprio Windows Installer. Um MSI atualiza o outro (o `UpgradeCode` sai do nome
técnico). Linha de comando silenciosa:

```
msiexec /i TecnomaxConnect-x64.msi /qn /norestart /l*v C:\Windows\Temp	ecnomax-connect.log
```

Propriedades úteis do projeto WiX do upstream: `INSTALLFOLDER="C:\..."`, `CREATEDESKTOPSHORTCUTS=0`,
`CREATESTARTMENUSHORTCUTS=0`, `LAUNCH_TRAY_APP=N`. Por **GPO**: Configuração do Computador → Políticas
→ Configurações de Software → Instalação de software → Novo pacote (caminho UNC do `.msi`,
"Atribuído"). Por **RMM**: copiar o `.msi` e rodar o `instalar-gerenciado.ps1 -Instalador <msi>`,
que também define a senha permanente. O MSI sozinho não define senha.

## Ícones

Para trocar os ícones, coloque estes arquivos em `tecnomax/marca/`: `icon.ico`, `tray-icon.ico`,
`icon.png`, `icon.svg` e `logo.svg`. O arquivo que estiver faltando continua com o ícone original.
