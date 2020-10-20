[Sitecore.Configuration.Factory]::GetConfigNode("languageDefinitions").FirstChild.ChildNodes | % {
    $id = $_.id
    $region = $_.region.ToString()

    if ($region) {
        $name = "$id-$region"
    }
    else {
        $name = "$id"
    }
    $culture = [Sitecore.Globalization.Language]::CreateCultureInfo($name)
    $culture
}