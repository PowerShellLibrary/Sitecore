$user = [Sitecore.Security.Accounts.User]::FromName("extranet\admin", $false)
[Sitecore.Security.Accounts.UserSwitcher]::Enter($user)
# logic
[Sitecore.Security.Accounts.UserSwitcher]::Exit()