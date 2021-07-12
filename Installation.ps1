#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [String]
    $ExePath,
    [Parameter(Mandatory=$True)]
    [String]
    $InstallFolder
)

function Write-Log
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Validateset("INFO","ERR")]
        [string]$Type="INFO"
    )

    $DateTime = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
    $FinalMessage = "[{0}]::[{1}]::[{2}]" -f $DateTime,$Type,$Message

    if($Type -eq "ERR")
    {
        Write-Host $FinalMessage -ForegroundColor Red
    }
    else
    {
        Write-Host $FinalMessage -ForegroundColor Green
    }
    
}

try
{
    Write-Log "Going to install Anaconda3"

    $Proc = Start-Process -FilePath $ExePath -ArgumentList "InstallationType=AllUsers /RegisterPython=1 /AddToPath=1 /S /D=$InstallFolder" -PassThru

    do {
        start-sleep -Seconds 5
        Write-Log "Installation in Progress -> ..."
    } until ($Proc.HasExited)

    Write-Log "Installation Completed"
}
catch
{
    Write-Log "$_" -Type ERR
}