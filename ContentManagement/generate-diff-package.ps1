$packagekName = "Diffpackage--$([DateTime]::Now.ToString('yyyy-MM-dd-hhss')).zip"
$limit = (Get-Date).AddDays(-10)
$rootPath = "/sitecore/content/SXA Reference"

function Test-EditedRecently($item) {
    $updated = Get-Date -Date $item."__Updated"
    $updated -gt $limit
}

$items = Get-ChildItem -Path $rootPath -Recurse | ? { Test-EditedRecently $_ }
$package = New-Package "DiffPackage"
foreach ($i in $items) {
    Write-Host "$($i.Paths.Path)"
    $TemplatesSource = $i | New-ItemSource -Name "$($i.Name)" -InstallMode Merge -MergeMode Merge
    $package.Sources.Add($TemplatesSource);
}

$package.Metadata.Author = "Auto generated"
$package.Metadata.Comment = "Isn't it cool?!"
$package.Metadata.Publisher = "Alan NULL"

$package | Export-Package -FileName $packagekName -Zip