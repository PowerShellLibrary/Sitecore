<#
.SYNOPSIS
Helper script for displaying various information about dlls

.DESCRIPTION
This script displays information about every dll located in a given path

You can get information about
- FileVersion
- ProductVersion
- LegalCopyright
- BuildConfiguration
- TargetCPU
- JitOptimized flag

One of the prerequisites for this cmdlet is DLLInfo module. You need to install it first.

.PARAMETER DllFolder
Location of the folder with dlls.

.EXAMPLE
.\Test-DLLs.ps1 "C:\sxa\lib\Sitecore\"

Displays information about every dll in a given path
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DllFolder
)

begin {
    Import-Module DLLInfo
}

process {
    if (!(Test-Path $DllFolder)) {
        Write-Host "Incorrect folder path:" -ForegroundColor Red
        Write-Host "$LogsFolder" -ForegroundColor Red
        exit
    }

    Get-ChildItem $DllFolder -Filter "*.dll" | % {
        Write-Host $_.FullName -ForegroundColor Yellow
        $versionInfo = (Get-Item $_.FullName).VersionInfo
        Write-Host "FileVersion   `t`t[$($versionInfo.FileVersion)]"
        Write-Host "ProductVersion`t`t[$($versionInfo.ProductVersion)]"
        Write-Host "LegalCopyright`t`t[$($versionInfo.LegalCopyright)]"
        $buildConfiguration = Get-BuildConfiguration $_.FullName
        if ($buildConfiguration -eq "Release") {
            Write-Host "BuildConfiguration`t[$buildConfiguration]" -ForegroundColor Green
        }else {
            Write-Host "BuildConfiguration`t[$buildConfiguration]" -ForegroundColor Red
        }
        $targetCPU = Get-TargetCPU $_.FullName
        Write-Host "TargetCPU`t`t[$targetCPU] "
        $jitOptimized = Test-JitOptimized $_.FullName
        Write-Host "JitOptimized`t`t[$jitOptimized]"
        write-host ""
    }
}