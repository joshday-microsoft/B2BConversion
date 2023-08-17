#region Global Variables
$tenantId = "<TenantId>"
$appID = "<AppID>"
$appSecret = "<AppSecret>"
$externalEmailAddress = "<ExternalEmailAddress>"
$userObjectID = "<UserObjectID>"
#endregion

#region Module Installs
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module Microsoft.Graph.Users -Scope CurrentUser
#endregion 

#region Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"
#endregion

#region Check if External Email Address is part of Existing User Object if not end script with instructions
$userDetails = Get-MgUser -UserId $userObjectID
$userMail = $userDetails.Mail
$userOtherMails = $userDetails.OtherMails

$foundInMail = $userMail -eq $externalEmailAddress

if ($foundInMail) {
    Write-Output "The email address $externalEmailAddress is set appropriately...Continuing..."
} else {
    Write-Error "The email address $externalEmailAddress is not found on the Azure AD User Profile. Please add the email to the User Properties in Azure AD to the Mail Property and restart this script"
    Write-Host "Please Note: Propogation can take up to 5 min after being set, so please wait 5+ minutes prior to starting this script after setting the property in Azure AD."
    return
}
#endregion

#region Get Access Token
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$tokenBody = @{
    client_id     = $appID
    scope         = "https://graph.microsoft.com/.default"
    client_secret = $appSecret
    grant_type    = "client_credentials"
}

$response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $tokenBody
$token = $response.access_token
#endregion

#region Call the Graph API endpoint for Invitation API
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"   = "application/json"
}

$body = @{
    invitedUserEmailAddress = "$externalEmailAddress"
    sendInvitationMessage   = $true
    invitedUserMessageInfo  = @{
        messageLanguage = "en-US"
        ccRecipients    = @()
        customizedMessageBody = "Join my Azure AD (B2B Collaboration)"
    }
    inviteRedirectUrl = "https://myapps.microsoft.com"
    invitedUser       = @{
        id = "$userObjectID"
    }
} | ConvertTo-Json

$endpoint = "https://graph.microsoft.com/v1.0/invitations"

try{
$result = Invoke-RestMethod -Method Post -Uri $endpoint -Headers $headers -Body $body -Verbose
}
catch
{
    $_.Exception.Response.GetResponseStream()
    $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $reader.ReadToEnd()
}
#endregion

#region Display the result
$result
#endregion