Recently Microsoft announced the deprecation of legacy PowerShell modules that are required in scenarios not yet available in Microsoft Graph PowerShell SDK. Microsoft recongnized the need to allow time for admins and developers to update their PowerShell code/cmdlets, postponing the deprecation date for MS Online, AzureAD, and AzureAD Preview PowerShell modules to March 30, 2024.

This solution provides admins and developers with a workaround to support New-MgInvitation. According to Microsoft documentation, the legacy New-AzureADMSInvitation (AzureAD Module) is replaced with the New-MgInvitation (Microsoft.Graph Module). Currently, New-MgInvitation only support the creation of new invitations, and does not support existing user objects. This issue has been reported to Microsoft.

# B2B Conversion Kit

This PowerShell uses the Invitation API REST endpoints for Conversion of a existing internal Guest User account created in an Azure Tenant to a B2B Collaboration Account

## Prerequisites 
 - App Registration
	 - Create App Registration
	 - Copy Application (client) ID
	 - Copy Directory (tenant) ID
	 - Update the API Permissions
	 - Add the following API Permissions
		 >**User.ReadWrite.All**
		 
		 > **User.Invite.All**
	 - Grant admin consent for your Tenant
	 - Under Authentication Blade Update the Redirect URIs and add the following:
	> 		https://login.microsoftonline.com/common/oauth2/nativecleint
 
   	> 		http://localhost
	 - While in Authentication tick the checkboxes for Access tokens and ID tokens
	 - Supported account types can remain as "Accounts in  this organization directory only..."
	 - Open the Certificates & Secrets Blade
	 - Create a Client Secret for the App Registration to be used in the PowerShell Script
	 - Set the Expires and Description values to your discretion
	 - Copy the Value of the newly created Secret
 - Azure AD User Requirements
	 - User must be a Guest Account currently not configured for B2B Collaboration
	 - User account must contain a valid email address in the Mail property of the user account
## Exceution
 - Open PowerShell ISE as Administrator
 - Edit the PowerShell with the following:
	 - $tenantId (Your Azure AD Tenant ID)
	 - $appID (Your App Registration App ID)
	 - $appSecret (The Client Secret you created in the previous steps)
	 - $externalEmailAddress (In Azure AD a Guest User account that hasn't been configured for B2B Collaboration, the Mail property will need to contain an external email address that will be used for configuring B2B Collaboration)
	 - $userObjectID (The target users Object ID in Azure AD)
 -  Save the PowerShell
 -  Execute the PowerShell
