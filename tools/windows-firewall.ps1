param([Parameter(Mandatory=$true)][string]$TvIp,[int]$Minutes=10)
$ErrorActionPreference='Stop'
$parsedIp=$null
if(-not [System.Net.IPAddress]::TryParse($TvIp,[ref]$parsedIp)){throw 'IP inválida'}
$octets=$parsedIp.GetAddressBytes()
if($octets.Length -ne 4 -or -not ($octets[0] -eq 10 -or ($octets[0] -eq 192 -and $octets[1] -eq 168) -or ($octets[0] -eq 172 -and $octets[1] -ge 16 -and $octets[1] -le 31))){throw 'Solo IPv4 privada'}
if($Minutes -lt 1 -or $Minutes -gt 30){throw 'Duración permitida: 1 a 30 minutos'}
$ruleName='VizioOpenHomeTemporary8099'
$nodePath=(Get-Command node.exe -ErrorAction Stop).Source
$stateDir=Join-Path (Split-Path $PSScriptRoot -Parent) '.private'
New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
$stopFile=Join-Path $stateDir 'firewall-stop'
$stateFile=Join-Path $stateDir 'firewall-status'
Remove-Item -LiteralPath $stopFile -ErrorAction SilentlyContinue
if(Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue){throw 'Ya existe una regla con este nombre. Revisa su propietario antes de continuar.'}
try{
 New-NetFirewallRule -Name $ruleName -DisplayName 'Vizio Open Home temporary bridge' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8099 -RemoteAddress $TvIp -Program $nodePath -Profile Any | Out-Null
 'ACTIVE' | Set-Content -LiteralPath $stateFile
 $deadline=(Get-Date).AddMinutes($Minutes)
 while((Get-Date) -lt $deadline -and -not (Test-Path -LiteralPath $stopFile)){Start-Sleep -Seconds 2}
}finally{
 Remove-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
 'REMOVED' | Set-Content -LiteralPath $stateFile
}
