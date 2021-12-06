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

$veyon = 'veyon-cli.exe'

Write-Host "---Exportando a Veyon Master---"
$aula = Read-Host "Ingresa el aula a ingresar (Ej. 1) "

$args = "networkobjects remove F$aula"
$arg = $args.Split(" ");
& "$veyon" $arg

$args1 = "networkobjects add location F$aula"
$arg1 = $args1.Split(" ");
& "$veyon" $arg1

$args2 = "networkobjects import C:/Users/adano/Desktop/ServidorFlask/F$aula.csv format %location%,%name%,%host%,%mac%"
$arg2 = $args2.Split(" ");
& "$veyon" $arg2