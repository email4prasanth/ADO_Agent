### Introduction to AzurDevOps CI/CD
#### AzureDevOps pipeline
- Azure is a cloud AzureDevOps - Saas based tool - is a solution
    - Repos
    - Pipelines
    - Kanban Boards
    - Test Cases
    - Artifacts

#### Pictorial representation of ADO
1. Steps to create new organization in AzureDevOps
    - ![01-steps](https: //github.com/email4prasanth/AzureDevOps/blob/master/azuredevopsimage/01_steps.png)
- Build-pipe line stages
    - First stage : CI build java code using javac or maven to create .war file called as `Artifacts`,
    - Second stage is `continuous delivery(require manual approval) and continous Deployment` (line represents separates the CI and deploy). The components above the line come under CI includes store artifacts in `cloud storage` and Build docker image from the .war file and push to `containers`, then images are converted into `services`. The below line includes stagging and prod servers so it is Continous delivery.
    - Third is continuous doeployment with release classic pipeline - lec-62-37:00
    - ![02-CI/CD](https://github.com/email4prasanth/AzureDevOps/blob/master/azuredevopsimage/02_CI-CD.png)
- Create project “myapp” and push the code to repo 
    - ![ADD-Project ](https://github.com/email4prasanth/AzureDevOps/blob/master/azuredevopsimage/03_Project.png)
- 09:04 - Picture
- 12:36 - AzureDevOps Agent is required to run all the stage in CI/CD pipeline
    -	Microsoft Hosted Agent
    -	Self Hosted Agent
0. Open Azuredevops account, Create an organisation with name `testingdkuttiado` and create `myapp`. we can create upto 5 organizations.


#                                     AzureDevOps Part-2/2
## Creating azure-pipeline.yml
### Clone the git hub if required and push the code to ADO
- create an empty folder `Base` and open it by using powershell
```
cd Base
git clone https://github.com/email4prasanth/ADO_Agent.git
git clone https://github.com/email4prasanth/AI_Infra.git
```
- Use this code and do necessary modification create a new folder
```
Remove git form the folder since we dont wont to push to git repo
git status
git init

git remote -v
git remote add  origin https://reachai@dev.azure.com/reachai/AzureTerraform/_git/AzureTerraform
git checkout -b feature/intial-setup
```
<!-- - 06 ado-repo image -->
### Push code to AzureDevOps repo 
<!-- - image -->
```
git add .; git commit -m "Base code is commited"
git branch
git remote add origin <>
git remote -v
git push origin feature/intial-setup

```
- Now create yml file to create infra lec-63, 7:57
- Store the secrtes under library variable group with name `AZURE_ACESS_GROUP_DEV`and  integrate with azure keyvault.
- Establish connection ADO to Azure cloud, go to organisation --> project --> project settings--> under the Pipelines section service connections-->connection type (Azure Resource Manager).
    - Identity type: App registration
    - Credential: Workload identity federation
    - Scope level: Subscription
    - Connection Name: ADOtoAzure
- once the connection is done, open azure kv add the key value pair then go to access policies -> create select permission -- choose key secrets & certificate manager --> principal -->  choose the connection and create.
- now open `AZURE_ACESS_GROUP_DEV` enable link from azure, provide subscription and keyvault name, resfresh click on add you will see the secrets.
- open rg aiado-terraform-rg | Access control (IAM), click on add--> role assignment --> select Privileged administrator roles --> contributor access --> next --> User, group, or service principal--> select members **azuretoado** (application registration) and create.

- open subscription `azlearn` folow the above steps
- Now check the deployment of dev and qa(with branch protection rules)

