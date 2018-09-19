Import-Function New-Tenant
Import-Function New-Site

function Get-SetupRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$TemplateName,
        [Parameter(Mandatory = $false, Position = 1)]
        [Item]$Root = (Get-Item -Path "master:/sitecore/system/Settings")
    )

    begin {
        Write-Verbose "Cmdlet Get-SetupRoot - Begin"
    }

    process {
        Write-Verbose "Cmdlet Get-SetupRoot - Process"
        $Root.Axes.GetDescendants() | ? { $_.TemplateName -eq $TemplateName } | Wrap-Item
    }

    end {
        Write-Verbose "Cmdlet Get-SetupRoot - End"
    }
}

# variables
$contentPath = "master:/content/F"
$tenantName = "T"
$siteName = "S"
$gridSetupPath = "master:/sitecore/system/Settings/Feature/Experience Accelerator/Bootstrap/Grid Setup"

# create - new tenant
New-Item -Path $contentPath -ItemType "/Foundation/Experience Accelerator/Multisite/Tenant Folder" | Out-Null
$model = New-Object Sitecore.XA.Foundation.Scaffolding.Models.CreateNewTenantModel
$model.TenantName = $tenantName
$model.TenantLocation = Get-Item -Path $contentPath
$model.DefinitionItems = New-Object System.Collections.ArrayList($null)
Get-SetupRoot "TenantSetupRoot" | ? { $_.IncludeByDefault -eq '1' } | % { $model.DefinitionItems.Add($_) } | Out-Null
New-Tenant $model

# create - new site
$model = New-Object Sitecore.XA.Foundation.Scaffolding.Models.CreateNewSiteModel
$model.SiteName = $siteName
$model.SiteLocation = Get-Item -Path "$contentPath\$tenantName"
$model.DefinitionItems = New-Object System.Collections.ArrayList($null)
Get-SetupRoot "SiteSetupRoot" | ? { $_.IncludeByDefault -eq '1' } | % { $model.DefinitionItems.Add($_) } | Out-Null
$model.CreateSiteTheme = $false
$model.ThemeName = ""
$model.ValidThemes = $null
$model.Language = "en"
$model.HostName = "*"
$model.VirtualFolder = "/"
$model.GridSetup = Get-Item -Path $gridSetupPath
New-Site $model