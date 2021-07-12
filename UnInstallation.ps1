#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [String]
    $Anaconda_Folder
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
    Write-Log "Going to uninstall Anaconda3"
    
    if(Test-Path -Path $Anaconda_Folder)
    {
        $Uninstaller = Get-ChildItem -Path $Anaconda_Folder | Where-Object {$_ -like "*Uninstall-Anaconda*"}
        if($Uninstaller)
        {
            $Proc = Start-Process -FilePath $Uninstaller.FullName -ArgumentList "/S" -PassThru

            do {
                start-sleep -Seconds 5
                Write-Log "UnInstallation in Progress -> ..."
            } until ($Proc.HasExited)

        }
        else 
        {
            throw "Unable to find uninstaller from $Anaconda_Folder"    
        }
        
    Write-Log "UnInstallation Completed"
    }
    else 
    {
        throw "Unable to detect the Anaconda folder from ENV PATH"    
    }
    
}
catch
{
    Write-Log "$_" -Type ERR
}