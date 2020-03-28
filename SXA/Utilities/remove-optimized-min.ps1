$query = "fast://*[@@name='optimized-min']"
@("web", "master") | % {
    $db = $_
    Get-Item -Path "$db`:" -Language "en" -Query $query | % {
        $path = $_.Paths.Path
        Write-Host "Removing $db`:$path" -ForegroundColor Green
        $_ | Remove-Item
    }
}