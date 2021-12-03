[cmdletbinding()]
param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

Write-Host "...Script Iniciado..."
Write-Host '¡Ejecución en modo administrador!'
Write-Host ""

$numPC = Read-Host "Ingrese el numero de la PC "

$adaptador = Get-NetAdapter -Name "Wi-Fi"
$macAddress = $adaptador.MacAddress
$ifindex = $adaptador.ifIndex

$IPv4Address = (Get-NetIPConfiguration -InterfaceIndex $ifindex).IPv4Address.IPAddress

$IPv4DefaultGateway = (Get-NetIPConfiguration -InterfaceIndex $ifindex).IPv4DefaultGateway.NextHop

$dnsServer = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses

<#$dnsObject = $ip_configuration.DNSServer.ServerAddresses
$dnsServer = @()
foreach($dns in $dnsObject){
    if(!$dns.Contains(":")){
        $dnsServer += "$dns"
    }
}#>
    

$mask = "255.255.240.0"

Remove-NetIPAddress -InterfaceIndex $ifindex
Remove-NetRoute -InterfaceIndex $ifindex

New-NetIPAddress -AddressFamily IPv4 –IPAddress $IPv4Address -DefaultGateway $IPv4DefaultGateway -PrefixLength 22 -InterfaceIndex $ifindex
<#
$ipParams = @{
    InterfaceIndex = $ifindex
    IPAddress = $IPv4Address
    PrefixLength = 20|22|24 => 250|252|255 (creo) jaja
    DefaultGateway = $IPv4DefaultGateway
    AddressFamily = "IPv4"
}
New-NetIPAddress @ipParams
#>

Set-NetIPInterface -InterfaceIndex $ifindex -Dhcp Disabled
    
$dnsParams = @{
    InterfaceIndex = $ifindex
    ServerAddresses = $dnsServer
}
Set-DnsClientServerAddress @dnsParams

#Write-Output $adaptador
Write-Output "Computadora: $numPC"
Write-Output "IP: $IPv4Address"
Write-Output "Gateway: $IPv4DefaultGateway"
Write-Output "Mac: $macAddress"
Write-Output "DNS: $dnsServer"#>

Write-Host ""
Write-Host "---Enviando datos a servidor---"
Write-Host "Procesando..."
Write-Host ""
Start-Sleep -s 30

$url = "http://192.168.8.36:3000/$numPC/$IPv4Address/$macAddress"
Write-Output "CURL: $url"

$CURLEXE = 'C:\Windows\System32\curl.exe'
& $CURLEXE $url

Write-Host ""
pause