- Create resource for terraform state files
```sh
# Variables
$resourceGroup = "aiado-terraform-rg"
$location = "eastus"   # Change if needed
$storageAccount = "aiadosto"
$containerName = "terraformstate"

# Create Resource Group
az group create --name $resourceGroup --location $location

# Create Storage Account
az storage account create --resource-group $resourceGroup --name $storageAccount `
    --sku Standard_LRS --encryption-services blob

# Get Storage Account Key
$accountKey = az storage account keys list --resource-group $resourceGroup `
    --account-name $storageAccount --query "[0].value" --output tsv

# Create Blob Container
az storage container create --name $containerName `
    --account-name $storageAccount --account-key $accountKey
```
- check the available vm
```sh
```
- terraform details
```
terraform init
terraform fmt
terraform workspace list
terraform workspace new agent
terraform validate
terraform apply --auto-approve
ssh adminuser@<public-ip> # enter password
```
- Remove terraform resource
```sh
az storage container delete --name $containerName `
    --account-name $storageAccount --account-key $accountKey

az storage account delete --name $storageAccount --resource-group $resourceGroup --yes

az group delete --name $resourceGroup --yes
```
