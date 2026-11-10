---
projeto: acesso-remoto-tecnomax
assunto: envio de falso positivo aos fabricantes de antivírus
atualizado: 09/11/2026
---

# Tecnomax Connect — falso positivo em antivírus

Material pronto para pedir a reanálise do Tecnomax Connect quando um antivírus bloquear o programa.
**Quem envia é o Yago** (os formulários pedem conta ou identificação do responsável).

## Caso atual (09/11/2026): Microsoft Defender

O Yago informou que quem bloqueou foi o **Microsoft Defender**. 🟡 Falta o nome exato da detecção
(Segurança do Windows → Proteção contra vírus e ameaças → Histórico de proteção) e em qual arquivo.

Passo a passo do envio (feito pelo Yago, com a conta Microsoft dele):
1. Abrir https://www.microsoft.com/en-us/wdsi/filesubmission e entrar como **Software developer**.
2. Enviar o arquivo da release em uso (`TecnomaxConnect-x64.exe`; se a detecção for no programa
   instalado, enviar também o `.zip`).
3. Marcar "Incorrectly detected as malware/malicious" e informar o nome da detecção.
4. Colar o texto em inglês deste arquivo, com o SHA256 da release enviada.
5. Guardar o número do envio. A resposta costuma vir por e-mail; cada versão nova pode precisar de novo envio.

## Antes de enviar

1. Anotar **qual antivírus** bloqueou e **o nome exato da detecção** (ex.: `Trojan:Win32/Wacatac.B!ml`),
   de preferência com print. Sem isso o fabricante não tem o que reavaliar.
2. Enviar sempre o **arquivo da release atual** e conferir o SHA256 (cada build tem um hash novo; a
   liberação de um fabricante vale para aquele arquivo, e a reputação recomeça a cada versão).
3. Enviar só para o fabricante que detectou. Não adianta enviar "preventivamente" a todos.

| Dado | Valor |
|---|---|
| Produto | Tecnomax Connect |
| Arquivo | `TecnomaxConnect-x64.exe` (e `TecnomaxConnect-x64.zip`, mesmo programa sem autoextração) |
| Versão / release | 🟡 preencher com a release enviada (ex.: `connect-v2026.11.09-0d501ee`) |
| SHA256 | 🟡 preencher com o da release enviada (`0d501ee`: `c33b0e25040f24e156dabd54b53c7b85ab17a1d15d0c316f28133cae9b91e42b`) |
| Download oficial | https://www.tecnomax.tech/connect |
| Código-fonte | https://github.com/tecnomax-sudo/rustdesk (branch `tecnomax`) |
| Releases e hashes | https://github.com/tecnomax-sudo/rustdesk/releases |
| Empresa | Tecnomax — Soluções em Tecnologia da Informação, Horizontina/RS, Brasil |
| Contato | contato@tecnomax.cloud |
| Licença | AGPL-3.0 (baseado no RustDesk, código aberto) |
| Assinatura digital | não há (arquivo sem assinatura de código) |

## Onde enviar (canais oficiais, conferidos em 09/11/2026)

| Fabricante | Canal | O que pede |
|---|---|---|
| Microsoft Defender / SmartScreen | https://www.microsoft.com/en-us/wdsi/filesubmission | Conta Microsoft; escolher "Software developer"; enviar o arquivo; marcar "Incorrectly detected as malware/malicious" e informar o nome da detecção. Guia: https://learn.microsoft.com/en-us/defender-xdr/submission-guide |
| Kaspersky | https://opentip.kaspersky.com/ | Enviar o arquivo e, no resultado, usar "Submit to reanalyze" com o texto abaixo |
| ESET | https://support.eset.com/en/kb141 | E-mail para `samples@eset.com`, assunto "False positive", arquivo em .zip/.rar com senha `infected`, descrição e print do alerta |
| Avast | https://www.avast.com/report-false-positive | Formulário com upload do arquivo e e-mail de contato |
| AVG | https://www.avg.com/en-ww/report-false-positive | Idem (mesmo laboratório da Avast) |
| Norton | https://submissions.norton.com/submitsample | Formulário "false positive": arquivo ou hash, nome da detecção, contato |
| Sophos | https://support.sophos.com/support/s/filesubmission | Formulário de envio de amostra, tipo "False positive" |
| Trend Micro | https://www.trendmicro.com/en_us/about/legal/detection-reevaluation.html | Formulário de reavaliação de detecção |
| Bitdefender | https://www.bitdefender.com/consumer/support/answer/29358/ | Formulário de falso positivo (🟡 a página não respondeu à conferência automática; abrir pelo navegador) |
| McAfee | https://www.mcafee.com/en-us/consumer-support/dispute-detection-allowlisting.html | Contestação de detecção (🟡 idem) |
| Malwarebytes | https://forums.malwarebytes.com/forum/122-false-positives/ | Tópico no fórum de falsos positivos, com o arquivo em .zip (🟡 idem) |

O VirusTotal (https://www.virustotal.com) mostra quais motores detectam um arquivo. Em 09/11/2026 as
três releases publicadas **não tinham relatório lá** (ninguém enviou). Enviar o arquivo ao VirusTotal é
decisão do Yago: ele passa a ser compartilhado com todos os fabricantes.

## Texto pronto — português

> **Assunto:** Falso positivo — Tecnomax Connect (software de suporte remoto)
>
> Solicito a reanálise do arquivo `TecnomaxConnect-x64.exe` (SHA256: `<hash>`), detectado pelo produto
> de vocês como `<nome da detecção>`.
>
> O Tecnomax Connect é o programa de acesso remoto usado pela Tecnomax — Soluções em Tecnologia da
> Informação (Horizontina/RS, Brasil) para prestar suporte técnico aos seus clientes. Ele é uma versão
> com a nossa marca do RustDesk, software de código aberto (licença AGPL-3.0), compilada no GitHub
> Actions a partir de código público.
>
> O que o programa faz: mostra um ID e uma senha de uso único; o cliente informa esses dados ao
> suporte, que então vê e opera a tela durante o atendimento. A conexão é criptografada, só acontece
> com a senha exibida na tela do cliente e pode ser encerrada por ele a qualquer momento. O programa
> não coleta dados nem se instala sem ação do usuário.
>
> - Página oficial de download: https://www.tecnomax.tech/connect
> - Código-fonte desta versão: https://github.com/tecnomax-sudo/rustdesk (branch `tecnomax`)
> - Releases e hashes: https://github.com/tecnomax-sudo/rustdesk/releases
> - O arquivo não tem assinatura digital de código.
>
> Contato: Yago Salbego Ramos — CEO Tecnomax — Soluções em Tecnologia da Informação —
> contato@tecnomax.cloud

## Ready-to-send text — English

> **Subject:** False positive — Tecnomax Connect (remote support software)
>
> Please re-analyze the file `TecnomaxConnect-x64.exe` (SHA256: `<hash>`), which your product detects
> as `<detection name>`.
>
> Tecnomax Connect is the remote access tool used by Tecnomax — Soluções em Tecnologia da Informação
> (an IT services company based in Horizontina, RS, Brazil) to provide technical support to its
> customers. It is a rebranded build of RustDesk, an open-source remote desktop application
> (AGPL-3.0), compiled on GitHub Actions from public source code.
>
> What it does: it shows an ID and a one-time password; the customer gives them to our support
> technician, who can then view and operate the screen during the support session. The connection is
> encrypted, only happens with the password shown on the customer's screen, and can be closed by the
> customer at any time. The program does not collect data and does not install itself without user
> action.
>
> - Official download page: https://www.tecnomax.tech/connect
> - Source code of this build: https://github.com/tecnomax-sudo/rustdesk (branch `tecnomax`)
> - Releases and hashes: https://github.com/tecnomax-sudo/rustdesk/releases
> - The file is not code-signed.
>
> Contact: Yago Salbego Ramos — CEO, Tecnomax — contato@tecnomax.cloud

## O que já foi feito no pacote para reduzir a detecção

- Metadados do executável coerentes com quem publica (antes o arquivo instalado se declarava "RustDesk",
  da "Purslane Tech Pte. Ltd.", sem ter a assinatura dela).
- Executável interno com o nome do produto (`TecnomaxConnect.exe`), em pasta própria, sem se misturar
  com o RustDesk oficial.
- Versão em `.zip` na release, para quando o antivírus implicar com o `.exe` autoextraível.
- Opção de build `TM_SEM_MODO_PRIVACIDADE=1`, que tira do pacote o componente que copia o
  `RuntimeBroker.exe` do Windows e injeta uma DLL nele (modo privacidade). Desligada por padrão.

## Assinatura de código

Decisão do CEO em 09/11/2026: sem compra de certificado. Efeito: a reputação no SmartScreen e nos
antivírus é construída arquivo a arquivo e recomeça a cada versão. Alternativa gratuita a avaliar: a
**SignPath Foundation** assina projetos de código aberto (https://signpath.org/terms). Exige, entre
outros pontos, licença OSI sem componente proprietário, política de assinatura publicada na página do
projeto, autenticação em dois fatores e, para versão modificada de outro projeto, que o upstream
publique builds assinados e que o fork seja visível. O certificado sai em nome da SignPath Foundation
(é ela que aparece como editor) e a aprovação é deles. 🟡 Não solicitado.

### Rascunho do pedido à SignPath Foundation (decisão do Yago em 09/11/2026: preparar; ele envia)

🟡 Conferir os campos do formulário em https://signpath.org/apply antes de enviar. Pontos a resolver antes:
a política exige que o projeto seja de código aberto com licença aprovada (AGPL-3.0, ok), que os
builds sejam feitos em CI a partir do repositório público e que haja uma página de política de
assinatura de código no repositório. O certificado sai em nome da SignPath Foundation. Um fork com
marca própria pode ser recusado: a aprovação é incerta.

```
Project name: Tecnomax Connect
Repository: https://github.com/tecnomax-sudo/rustdesk (branch "tecnomax")
License: AGPL-3.0 (fork of RustDesk, https://github.com/rustdesk/rustdesk)
Homepage: https://www.tecnomax.tech/connect
Maintainer: Yago Salbego Ramos — Tecnomax (Horizontina/RS, Brazil)
Description: Remote support client for Windows, a rebranded build of the open-source RustDesk
client preconfigured for our self-hosted server. All changes are applied at build time by a public
script (tecnomax/rebrand.py) and the binaries are built by a public GitHub Actions workflow
(.github/workflows/tecnomax-windows.yml). Releases are published with SHA256 checksums.
Why signing: unsigned builds trigger SmartScreen warnings and antivirus false positives for the
small businesses we support.
Artifacts to sign: TecnomaxConnect-x64.exe (portable launcher) and TecnomaxConnect.exe (application).
```
