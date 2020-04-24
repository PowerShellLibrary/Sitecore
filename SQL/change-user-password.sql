DECLARE @UserID uniqueidentifier
DECLARE @userName varchar(60)
SET @userName = 'sitecore\a'

SET @UserID  = (SELECT UserId FROM [aspnet_Users] WHERE UserName = @userName)

UPDATE [aspnet_Membership] SET Password='qOvF8m8F2IcWMvfOBjJYHmfLABc='
WHERE UserId = @UserID
UPDATE [aspnet_Membership] SET PasswordSalt='OM5gu45RQuJ76itRvkSPFw=='
WHERE UserId = @UserID