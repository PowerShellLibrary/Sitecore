$contextItem = Get-Item .
$sourceDb = Get-Database "master"
$targetDb = Get-Database "web"
$mode = [Sitecore.Publishing.PublishMode]::Smart
$lang = $contextItem.Language
$publishDate = [System.DateTime]::Now
$options = [Sitecore.Publishing.PublishOptions]::new($sourceDb, $targetDb, $mode, $lang, $publishDate)
$options.RootItem = Get-Item -Path "/sitecore/templates/Sample/Sample Item/Data/Title"
$publisher = [Sitecore.Publishing.Publisher]::new($options)


[Sitecore.Events.Event]::RaiseEvent("publish:end", $publisher);


$evt = [Sitecore.Eventing.Remote.PublishEndRemoteEvent]::new($publisher)
$args = [Sitecore.Data.Events.PublishEndRemoteEventArgs]::new($evt)
[Sitecore.Events.Event]::RaiseEvent("publish:end:remote", $args);