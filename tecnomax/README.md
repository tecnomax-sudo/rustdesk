---
projeto: acesso-remoto-tecnomax
base: rustdesk/rustdesk (AGPL-3.0)
branch: tecnomax
atualizado: 09/11/2026
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
| `TM_DRY_RUN=1` | não | só confere, sem gravar |

A chave **privada** do hbbs nunca entra no repositório: ela fica no servidor e no Bitwarden.
A chave pública não é segredo, porque vai dentro do executável.

## Servidor

O cliente fala só por WebSocket (443), porque o servidor da Tecnomax fica atrás de um Cloudflare
Tunnel, sem porta aberta. O hbbs do upstream não registra o ID por WebSocket; por isso o servidor é
o fork [`tecnomax-sudo/rustdesk-server`](https://github.com/tecnomax-sudo/rustdesk-server)
(branch `tecnomax`), que faz isso.

## Build

O workflow `.github/workflows/tecnomax-windows.yml` compila o Windows x64 a cada push em `tecnomax/`
e gera o `.exe` portátil (artefato `tecnomax-connect-windows-x64`). Servidor e chave vêm das
variáveis do repositório `TM_RENDEZVOUS_SERVER` e `TM_RS_PUB_KEY`. Os workflows do upstream estão
desativados neste fork, para não rodarem o build noturno nem o CI completo.

## Ícones

Para trocar os ícones, coloque estes arquivos em `tecnomax/marca/`: `icon.ico`, `tray-icon.ico`,
`icon.png`, `icon.svg` e `logo.svg`. O arquivo que estiver faltando continua com o ícone original.
