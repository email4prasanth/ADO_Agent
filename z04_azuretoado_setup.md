- Create a service connection
- Create api registration with name `azuretoado` with multiple tenants applicable to all tenants.
- create secret with name `azuretoadosecret`, create a kv and store the key- value pair choose policy over RBAC.   
```sh
AZURE-SUBSCRIPTION-ID
AZURE-TENANT-ID
AZURE-CLIENT-ID
AZURE-CLIENT-SECRET
```
- now go to access policy **permission** and select key, secret, certificate manager.
- **principal** search with tried with client ID.
- Now got to Azureterraform/Pipelines/Library select variable group `azurecreds`, link seccrets from azure key vault. select subscription click on authorise
- select key vault and authorize, click on variables add the secrets you can see the details, click on save.

- now push the code to ADO, click on pipelines check the available pipelines, 
- click on Repos Push an existing repository from command line
```sh
git remote -v
git remote add ado https://reachai@dev.azure.com/reachai/Azureterraform/_git/Azureterraform
git remote -v
git push -u ado dev
```
- Enter mail id and code and check the ADO repo, go to pipeline then run check pipelines
- Go to: Pipelines → Environments create dev
- modify the code and open the agent server and go to myagent then hit `./run.sh &`, check the status of AzureAgentPool status.
- During first run allow the permission to access variables, azure key vault.
- To access provider assing contributor access to `aiado-terraform-rg `.