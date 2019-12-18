<#

.SYNOPSIS
Helper script for removing inactive logs and opening the active one.

.DESCRIPTION
This script will do two things:
- it will remove all inactive logs for a given location.
- it will open the last active log using logview.exe

You can pick which log should be opened:
- Sitecore
- Search
- SPE
- Publishing

If you wish to work using single logview window use `SingleWindow` switch.

.PARAMETER LogType
Type of the log. It can be Sitecore log, Publishing, SPE etc.

.PARAMETER LogsFolder
Location of the folder where your Sitecore logs live.

.PARAMETER SingleWindow
Allow you to focus on a single logview window. When used previously opened logview windows will be closed.

.PARAMETER RemoveLogs
Specifies whether stale log files should be removed.

.EXAMPLE
.\Open-Log.ps1 "c:\sitecore\Data\logs" -LogType Sitecore
Removes all logs in "c:\sitecore\Data\logs\" and opens active Sitecore log

.EXAMPLE
.\Open-Log.ps1 "c:\sitecore\Data\logs" -LogType SPE
Removes all logs in "c:\sitecore\Data\logs\" and opens active SPE log

.EXAMPLE
.\Open-Log.ps1 "c:\sitecore\Data\logs" -LogType SPE -SingleWindow
Removes all logs in "c:\sitecore\Data\logs\" then closes all existing windows with logs and opens active Sitecore log

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$LogsFolder,
    [Parameter(Mandatory = $false)]
    [ValidateSet("Sitecore", "Search", "SPE", "Publishing")]
    [string]$LogType = 'Sitecore',
    [Parameter(Mandatory = $false)]
    [switch]$SingleWindow,
    [Parameter(Mandatory = $false)]
    [switch]$RemoveLogs
)

process {
    if (!(Test-Path $LogsFolder)) {
        Write-Host "Incorrect logs folder path:" -ForegroundColor Red
        Write-Host "$LogsFolder" -ForegroundColor Red
        exit
    }

    if ($SingleWindow) {
        Get-Process | ? { $_.Name -eq "logview" } | Stop-Process
    }

    Switch ($LogType) {
        "Sitecore" { $ending = "log." }
        "Search" { $ending = "Search.log" }
        "SPE" { $ending = "SPE." }
        "Publishing" { $ending = "Publishing." }
    }

    $currentFolder = Get-Item $PSScriptRoot
    $exe = Join-Path $currentFolder.Parent.FullName "bin\logview.exe"

    if ($RemoveLogs) {
        Get-ChildItem $LogsFolder | Remove-Item -ErrorAction SilentlyContinue | Out-Null
    }
    $firstLog = Get-ChildItem $LogsFolder | ? { $_.Name.StartsWith($ending) } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
    & "$exe" $firstLog.FullName
}
