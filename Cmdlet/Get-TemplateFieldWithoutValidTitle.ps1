function Get-Title ($name) {
    $chars = $name.ToCharArray() | % {
        if ([char]::IsUpper($_)) {" "}
        $_
    }
    ($chars -join "").TrimStart(" ")
}

function Test-NameMatch ($name) {
    [regex]::Match($name, "[A-Z][a-z]+[A-Z]").Success
}

function Get-TemplateFieldWithoutValidTitle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0 )]
        [Item]$StartItem
    )

    begin {
        Write-Verbose "Cmdlet Get-TemplateFieldWithoutValidTitle - Begin"
    }

    process {
        Write-Verbose "Cmdlet Get-TemplateFieldWithoutValidTitle - Process"
        $query = "fast:$($StartItem.Paths.Path)//*[@@templatename='Template field']"
        Write-Verbose "Query: $query"
        Get-Item -Path master: -Language "en" -Query $query | `
            ? { Test-NameMatch $_.Name } | `
            ? { $_.Title -eq "" }
    }

    end {
        Write-Verbose "Cmdlet Get-TemplateFieldWithoutValidTitle - End"
    }
}