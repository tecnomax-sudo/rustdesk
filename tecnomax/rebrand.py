#!/usr/bin/env python3
"""Aplica a marca Tecnomax sobre o código do RustDesk antes da compilação.

O código original fica intacto no git: este script altera os arquivos no momento
do build (CI ou máquina local). Assim, atualizar para uma versão nova do RustDesk
é só trazer o upstream e rodar de novo.

Cada troca exige encontrar o texto original exatamente uma vez. Se o upstream
mudar o arquivo, o script para com erro em vez de gerar um cliente pela metade.

Variáveis de ambiente:
  TM_APP_NAME          nome do aplicativo (padrão: Tecnomax Connect)
  TM_RENDEZVOUS_SERVER endereço do hbbs, ex.: remoto.exemplo.com (obrigatório)
  TM_RS_PUB_KEY        chave pública do hbbs, conteúdo do id_ed25519.pub (obrigatório)
  TM_CUSTOM_PUB_KEY    chave pública que valida o custom.txt (opcional; sem ela
                       o custom.txt fica desativado, pois a chave da RustDesk é removida)
  TM_ORG               identificador da organização (padrão: tech.tecnomax)
  TM_COPYRIGHT         texto de copyright do .exe
  TM_DRY_RUN=1         só confere se todas as trocas acham o alvo, sem gravar

Uso: python3 tecnomax/rebrand.py   (na raiz do repositório)
"""

import os
import re
import shutil
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
MARCA = Path(__file__).resolve().parent / "marca"

# Chave usada no lugar da chave da RustDesk quando não há chave própria para o
# custom.txt: 32 bytes zerados não validam nenhuma assinatura.
CHAVE_NULA = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="


def env(nome, obrigatorio=True, padrao=None):
    valor = os.environ.get(nome, padrao)
    if obrigatorio and not valor:
        sys.exit(f"ERRO: variável {nome} não definida")
    return valor


def rust_str(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


PENDENTES = {}  # arquivo -> texto já alterado, gravado só se todas as trocas acharem o alvo


def trocar(arquivo, padrao, novo, dry):
    """Prepara a troca de um padrão regex que deve aparecer exatamente uma vez."""
    texto = PENDENTES.get(arquivo)
    if texto is None:
        texto = (RAIZ / arquivo).read_text(encoding="utf-8")
    achados = len(re.findall(padrao, texto, flags=re.M))
    if achados != 1:
        sys.exit(f"ERRO: {arquivo}: padrão encontrado {achados}x (esperado 1): {padrao}\n"
                 "Nada foi gravado. Se o rebrand já foi aplicado, restaure com git checkout.")
    PENDENTES[arquivo] = re.sub(padrao, lambda _: novo, texto, flags=re.M)
    print(f"ok  {arquivo}")


def gravar_pendentes():
    for arquivo, texto in PENDENTES.items():
        (RAIZ / arquivo).write_text(texto, encoding="utf-8", newline="")


def main():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    dry =os.environ.get("TM_DRY_RUN") == "1"
    nome = env("TM_APP_NAME", obrigatorio=False, padrao="Tecnomax Connect")
    servidor = env("TM_RENDEZVOUS_SERVER")
    chave = env("TM_RS_PUB_KEY")
    chave_custom = env("TM_CUSTOM_PUB_KEY", obrigatorio=False) or CHAVE_NULA
    org = env("TM_ORG", obrigatorio=False, padrao="tech.tecnomax")
    copyright_ = env("TM_COPYRIGHT", obrigatorio=False,
                     padrao=f"{nome}, baseado no RustDesk (AGPL-3.0)")

    if "RustDesk" in nome:
        sys.exit("ERRO: o nome não pode conter 'RustDesk' (o app passaria por cliente oficial)")

    cfg = "libs/hbb_common/src/config.rs"
    # Servidor e chave padrão do cliente
    trocar(cfg, r'^pub const RENDEZVOUS_SERVERS: &\[&str\] = &\[.*\];$',
           f'pub const RENDEZVOUS_SERVERS: &[&str] = &["{rust_str(servidor)}"];', dry)
    trocar(cfg, r'^pub const RS_PUB_KEY: &str = ".*";$',
           f'pub const RS_PUB_KEY: &str = "{rust_str(chave)}";', dry)
    # Nome do app: também desliga a atualização automática pelo site da RustDesk
    # (is_custom_client) e troca "RustDesk" nos textos traduzidos (src/lang.rs)
    trocar(cfg, r'APP_NAME: RwLock<String> = RwLock::new\("RustDesk"\.to_owned\(\)\)',
           f'APP_NAME: RwLock<String> = RwLock::new("{rust_str(nome)}".to_owned())', dry)
    trocar(cfg, r'ORG: RwLock<String> = RwLock::new\("com\.carriez"\.to_owned\(\)\)',
           f'ORG: RwLock<String> = RwLock::new("{rust_str(org)}".to_owned())', dry)

    # WebSocket fixo: o servidor da Tecnomax só é alcançável pelo túnel da Cloudflare (443),
    # e OVERWRITE_SETTINGS tem prioridade sobre o que o usuário configurar
    trocar(cfg, r'pub static ref OVERWRITE_SETTINGS: RwLock<HashMap<String, String>> = Default::default\(\);',
           'pub static ref OVERWRITE_SETTINGS: RwLock<HashMap<String, String>> = RwLock::new(HashMap::from([\n'
           '        ("allow-websocket".to_owned(), "Y".to_owned()),\n'
           '    ]));', dry)
    # wss sempre que o servidor for um domínio. No original, só com a opção api-server em
    # https, que o nosso servidor não usa; sem isso o registro iria em ws:// sem criptografia
    trocar("libs/hbb_common/src/websocket.rs",
           r'let protocol = if is_domain \{\s*let api_server = Config::get_option\("api-server"\);\s*'
           r'if api_server\.starts_with\("https"\) \{\s*"wss"\s*\} else \{\s*"ws"\s*\}\s*\} else \{',
           'let protocol = if is_domain {\n        "wss"\n    } else {', dry)

    # Chave que valida o custom.txt: tira a da RustDesk
    trocar("src/common.rs", r'const KEY: &str = "5Qbwsde3unUcJBtrx9ZkvUmwFNoExHzpryHuPUdqlWM=";',
           f'const KEY: &str = "{rust_str(chave_custom)}";', dry)

    # Metadados do executável do Windows
    trocar("Cargo.toml", r'^LegalCopyright = ".*"$', f'LegalCopyright = "{rust_str(copyright_)}"', dry)
    trocar("Cargo.toml", r'^ProductName = "RustDesk"$', f'ProductName = "{rust_str(nome)}"', dry)
    trocar("Cargo.toml", r'^FileDescription = "RustDesk Remote Desktop"$',
           f'FileDescription = "{rust_str(nome)}"', dry)

    # Metadados do empacotador portátil (o .exe que o usuário baixa)
    pk = "libs/portable/Cargo.toml"
    trocar(pk, r'^LegalCopyright = ".*"$', f'LegalCopyright = "{rust_str(copyright_)}"', dry)
    trocar(pk, r'^ProductName = "RustDesk"$', f'ProductName = "{rust_str(nome)}"', dry)
    trocar(pk, r'^FileDescription = "RustDesk Remote Desktop"$', f'FileDescription = "{rust_str(nome)}"', dry)

    # Título fixo na barra de abas do Flutter
    trocar("flutter/lib/desktop/widgets/tabbar_widget.dart",
           r'child: const Text\(\s*"RustDesk",',
           f'child: const Text(\n                              "{rust_str(nome)}",', dry)

    if not dry:
        gravar_pendentes()

    # Ícones: copia o que existir em tecnomax/marca/ por cima do original
    destinos = {
        "icon.ico": ["res/icon.ico", "flutter/windows/runner/resources/app_icon.ico"],
        "tray-icon.ico": ["res/tray-icon.ico"],
        "icon.png": ["res/icon.png"],
        "icon.svg": ["flutter/assets/icon.svg"],
        "logo.svg": ["res/logo.svg"],
    }
    for origem, alvos in destinos.items():
        arq = MARCA / origem
        if not arq.exists():
            print(f"--  marca/{origem} ausente: fica o ícone original")
            continue
        for alvo in alvos:
            if not dry:
                shutil.copyfile(arq, RAIZ / alvo)
            print(f"ok  {alvo} <- marca/{origem}")

    print("simulação concluída, nada gravado" if dry else "rebrand aplicado")


if __name__ == "__main__":
    main()
