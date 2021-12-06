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
$location = Read-Host "Ingrese el aula F al que pertenece el PC (Ej. 1) "

$adaptador = Get-NetAdapter -Name "Ethernet" # Replace Ethernet by Wi-Fi for not generate more modifications on code
$ifindex = $adaptador.ifIndex
$IPv4Address = (Get-NetIPConfiguration -InterfaceIndex $ifindex).IPv4Address.IPAddress
$macAddressEthernet = $adaptador.MacAddress

$IPv4DefaultGateway = (Get-NetIPConfiguration -InterfaceIndex $ifindex).IPv4DefaultGateway.NextHop
$dnsServer = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses
Remove-NetIPAddress -InterfaceIndex $ifindex
Remove-NetRoute -InterfaceIndex $ifindex
New-NetIPAddress -AddressFamily IPv4 –IPAddress $IPv4Address -DefaultGateway $IPv4DefaultGateway -PrefixLength 22 -InterfaceIndex $ifindex
Set-NetIPInterface -InterfaceIndex $ifindex -Dhcp Disabled 
$dnsParams = @{
    InterfaceIndex = $ifindex
    ServerAddresses = $dnsServer
}
Set-DnsClientServerAddress @dnsParams
Write-Output $adaptador
Write-Output "Computadora: $numPC"
Write-Output "IP: $IPv4Address"
Write-Output "Gateway: $IPv4DefaultGateway"
Write-Output "Mac: $macAddress"
Write-Output "DNS: $dnsServer"

Write-Host ""
Write-Host "---Enviando datos a servidor---"
Write-Host "Procesando..."
Write-Host ""
Start-Sleep -s 30

$type = "computer"
$name = "PC-$numPC"
$mac = $macAddressEthernet
                         #
$url = "http://192.168.8.36:3000/$type/$name/$IPv4Address/$mac/$location"
Write-Output "CURL: $url"

$CURLEXE = 'C:\Windows\System32\curl.exe'
& $CURLEXE $url

Write-Host ""
pause