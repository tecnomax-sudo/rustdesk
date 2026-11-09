---
projeto: acesso-remoto-tecnomax
atualizado: 09/11/2026
---

# Estado atual

## Feito (09/11/2026)
- Decisão do CEO: **fork próprio**, em vez do RustDesk Server Pro.
- Forks públicos criados: `tecnomax-sudo/rustdesk` e `tecnomax-sudo/hbb_common`.
- Branch `tecnomax` com `tecnomax/rebrand.py`, testado contra a v1.5.3 (commit upstream 95cca3f):
  todas as trocas acham o alvo, uma segunda execução falha sem gravar nada, e um nome contendo
  "RustDesk" é recusado.

## Observação
O `rebrand.py` altera o submódulo `libs/hbb_common` no próprio build. Por isso o fork
`tecnomax-sudo/hbb_common` não é necessário hoje: ele só vira necessário se um dia for preciso
mudar código do hbb_common além das constantes.

## Pendências
- 🟠 **Nome do produto** (`TM_APP_NAME`): decisão do Yago.
- 🟠 **Onde sobe o hbbs/hbbr**: precisa de IP público, das portas 21115–21119 (TCP) e 21116 (UDP),
  e de DNS sem proxy da Cloudflare. Não usar o labsai.
- 🟠 **Certificado de assinatura de código (Windows)**: sem ele, o SmartScreen e o Defender barram o executável.
- 🟡 Ícones da marca em `tecnomax/marca/`.
- 🟡 Ligar o `rebrand.py` no `.github/workflows/flutter-build.yml`, depois do checkout de cada job,
  e trocar a assinatura remota da RustDesk (`SIGN_BASE_URL`) pela nossa.
- 🟡 Gerar o par de chaves para o `custom.txt` (`TM_CUSTOM_PUB_KEY`), se for usar configuração por cliente.
- 🔵 macOS e Android: identificador do app e notarization ficam para depois do Windows.
