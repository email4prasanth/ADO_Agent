### one time setup
- Az PowerShell context
```sh
az account list --output table
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Connect-AzAccount

Get-AzContext
Connect-AzAccount -TenantId 5fa31033-e5a8-478a-8865-bbf71f8162f3
Get-AzContext
Set-AzContext -Subscription "ceb3ae8b-a788-4e9d-965b-3c3250fdf106"
```
- Azure CLI context
```sh
# Log in to the correct tenant
az login --tenant 5fa31033-e5a8-478a-8865-bbf71f8162f3
az account set --subscription "ceb3ae8b-a788-4e9d-965b-3c3250fdf106"
az account show
```
