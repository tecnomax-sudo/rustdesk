<#
.SYNOPSIS
    Instala o Tecnomax Connect sem interação e define a senha permanente (clientes de contrato).

.DESCRIPTION
    Para máquina gerenciada (servidor, estação de contrato) em que o técnico precisa entrar sem
    ninguém do outro lado ler a senha temporária.

    1. Usa o instalador indicado em -Instalador (.exe portátil ou .msi) ou baixa o da última
       release do GitHub da Tecnomax (versão técnica ou Suporte), conferindo o SHA256 publicado.
    2. Instala em silêncio: "<exe> --silent-install" ou "msiexec /i <msi> /qn".
    3. Espera o serviço TecnomaxConnect ficar em execução.
    4. Define a senha permanente (TecnomaxConnect.exe --password), o método de verificação e o modo
       de aprovação (--option verification-method / approve-mode).
    5. Imprime o ID da máquina.

    A senha NUNCA é gravada em arquivo nem escrita na tela por este script. Não ligue
    Start-Transcript em volta dele. Limite conhecido (do próprio RustDesk): a senha vai na linha de
    comando do TecnomaxConnect.exe por alguns segundos, visível para administradores da máquina
    na lista de processos enquanto ele roda.

    Precisa de PowerShell como administrador (o --password do RustDesk só funciona elevado e com o
    programa instalado).

.PARAMETER Senha
    Senha permanente, como SecureString. Sem ela, o script lê a variável de ambiente
    TM_CONNECT_SENHA (uso por RMM, com variável secreta) e, por último, pergunta na tela.
    Mínimo de 8 caracteres.

.PARAMETER Instalador
    Caminho de um TecnomaxConnect*-x64.exe ou TecnomaxConnect*-x64.msi já baixado. Sem ele, baixa
    da release mais recente.

.PARAMETER Variante
    Tecnico (padrão, versão completa) ou Suporte (só recebe conexões). Só vale para o download.

.PARAMETER Verificacao
    Ambas (padrão: senha temporária da tela OU a permanente) ou Permanente (só a permanente).

.PARAMETER Aprovacao
    Senha (padrão: entra com a senha, sem clique do usuário), Clique (alguém precisa aceitar na
    tela) ou Ambos (senha ou clique).

.EXAMPLE
    # Interativo: pergunta a senha
    .\instalar-gerenciado.ps1

.EXAMPLE
    # RMM: senha em variável secreta TM_CONNECT_SENHA, instalador já copiado para a máquina
    .\instalar-gerenciado.ps1 -Instalador C:\Temp\TecnomaxConnect-x64.msi -Verificacao Permanente
#>
[CmdletBinding()]
param(
    [SecureString]$Senha,
    [string]$Instalador,
    [ValidateSet('Tecnico', 'Suporte')]
    [string]$Variante = 'Tecnico',
    [ValidateSet('Ambas', 'Permanente')]
    [string]$Verificacao = 'Ambas',
    [ValidateSet('Senha', 'Clique', 'Ambos')]
    [string]$Aprovacao = 'Senha',
    [int]$EsperaServicoSegundos = 180
)

$ErrorActionPreference = 'Stop'
$NomeTecnico = 'TecnomaxConnect'   # pasta, exe e serviço (iguais nas duas variantes)
$Release = 'https://github.com/tecnomax-sudo/rustdesk/releases/latest/download'

function Falhar([string]$msg) {
    Write-Host "ERRO: $msg" -ForegroundColor Red
    exit 1
}

# --- Pré-requisitos -------------------------------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Falhar 'rode este script em um PowerShell como administrador.'
}

if (-not $Senha) {
    if ($env:TM_CONNECT_SENHA) {
        $Senha = ConvertTo-SecureString $env:TM_CONNECT_SENHA -AsPlainText -Force
    } elseif ([Environment]::UserInteractive) {
        $Senha = Read-Host 'Senha permanente do Tecnomax Connect' -AsSecureString
        $conf = Read-Host 'Repita a senha' -AsSecureString
        $a = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Senha))
        $b = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($conf))
        $iguais = ($a -ceq $b)
        $a = $null; $b = $null
        if (-not $iguais) { Falhar 'as senhas digitadas não conferem.' }
    } else {
        Falhar 'informe -Senha (SecureString) ou a variável de ambiente TM_CONNECT_SENHA.'
    }
}
if ($Senha.Length -lt 8) { Falhar 'a senha permanente precisa ter pelo menos 8 caracteres.' }

# --- Instalador -----------------------------------------------------------------------------
$temp = $null
if (-not $Instalador) {
    $arq = if ($Variante -eq 'Suporte') { 'TecnomaxConnectSuporte-x64.exe' } else { 'TecnomaxConnect-x64.exe' }
    $temp = Join-Path $env:TEMP ("tecnomax-connect-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $temp | Out-Null
    $Instalador = Join-Path $temp $arq
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Write-Host "Baixando $arq da última release..."
    Invoke-WebRequest -UseBasicParsing -Uri "$Release/$arq" -OutFile $Instalador
    $esperado = ((Invoke-WebRequest -UseBasicParsing -Uri "$Release/$arq.sha256").Content -split '\s+')[0].Trim().ToLower()
    $obtido = (Get-FileHash $Instalador -Algorithm SHA256).Hash.ToLower()
    if ($esperado -ne $obtido) { Falhar "SHA256 do download não confere (esperado $esperado, obtido $obtido)." }
    Write-Host "SHA256 conferido: $obtido"
}
if (-not (Test-Path $Instalador)) { Falhar "instalador não encontrado: $Instalador" }
$Instalador = (Resolve-Path $Instalador).Path

# --- Instalação silenciosa ------------------------------------------------------------------
Write-Host "Instalando $([IO.Path]::GetFileName($Instalador)) em modo silencioso..."
if ($Instalador -like '*.msi') {
    $log = Join-Path $env:TEMP 'tecnomax-connect-msi.log'
    $p = Start-Process msiexec.exe -ArgumentList @('/i', "`"$Instalador`"", '/qn', '/norestart', '/l*v', "`"$log`"") -Wait -PassThru
    if ($p.ExitCode -notin 0, 3010) { Falhar "msiexec terminou com código $($p.ExitCode). Log: $log" }
} else {
    # O portátil extrai e chama o instalador; o processo inicial pode sair antes do fim, por isso
    # a confirmação de verdade é o serviço em execução, logo abaixo.
    Start-Process -FilePath $Instalador -ArgumentList '--silent-install' -Wait | Out-Null
}

$limite = (Get-Date).AddSeconds($EsperaServicoSegundos)
do {
    $svc = Get-Service -Name $NomeTecnico -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq 'Running') { break }
    Start-Sleep -Seconds 3
} while ((Get-Date) -lt $limite)
if (-not $svc -or $svc.Status -ne 'Running') {
    Falhar "o serviço $NomeTecnico não entrou em execução em $EsperaServicoSegundos s."
}
Start-Sleep -Seconds 5   # o serviço precisa abrir o canal IPC antes de aceitar --password

$exe = Join-Path $env:ProgramFiles "$NomeTecnico\$NomeTecnico.exe"
if (-not (Test-Path $exe)) { Falhar "programa instalado não encontrado em $exe" }

function Invoke-Connect([string[]]$argumentos) {
    # Saída capturada por pipe: o exe é de interface gráfica e só escreve no console assim
    (& $exe @argumentos | Out-String).Trim()
}

function Set-OpcaoConnect([string]$nome, [string]$valor) {
    # Start-Process recebe a linha de comando pronta: assim o valor vazio ("") chega como
    # argumento vazio também no Windows PowerShell 5.1, que descarta string vazia no "&".
    $p = Start-Process -FilePath $exe -ArgumentList "--option $nome `"$valor`"" -Wait -PassThru -WindowStyle Hidden
    if ($p.ExitCode -ne 0) { Falhar "não foi possível gravar a opção $nome (código $($p.ExitCode))." }
}

# --- Senha permanente e modo de acesso ------------------------------------------------------
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Senha)
try {
    $plano = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    $res = Invoke-Connect @('--password', $plano)
} finally {
    $plano = $null
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}
if ($res -notmatch 'Done') { Falhar "a senha permanente não foi aceita (resposta do programa: '$res')." }
Write-Host 'Senha permanente definida.'

$metodo = @{ Ambas = 'use-both-passwords'; Permanente = 'use-permanent-password' }[$Verificacao]
$modo = @{ Senha = 'password'; Clique = 'click'; Ambos = '' }[$Aprovacao]
Set-OpcaoConnect 'verification-method' $metodo
Set-OpcaoConnect 'approve-mode' $modo
$confMetodo = Invoke-Connect @('--option', 'verification-method')
$confModo = Invoke-Connect @('--option', 'approve-mode')
if ($confMetodo -ne $metodo -or $confModo -ne $modo) {
    Write-Host "AVISO: opções lidas de volta diferem do pedido (verificação '$confMetodo', aprovação '$confModo')." -ForegroundColor Yellow
}
Write-Host "Verificação: $confMetodo | Aprovação: $(if ($confModo) { $confModo } else { 'senha ou clique' })"

$id = Invoke-Connect @('--get-id')
if ($temp) { Remove-Item -Recurse -Force $temp -ErrorAction SilentlyContinue }
if (-not $id) { Falhar 'instalado, mas o ID não foi lido. Abra o Tecnomax Connect na máquina para conferir.' }
Write-Host ''
Write-Host "Tecnomax Connect instalado. ID desta máquina: $id" -ForegroundColor Green
Write-Output $id
