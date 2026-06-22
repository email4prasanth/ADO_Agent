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
- **PART-1:**
1. Use AWS or Azure launch an instance/VM with atleast 2 CPU, 8GB RAM. User (required in AWS if metadata is not used).
2. Install the required tools
    - java
    - jq, curl, wget, net-tools etc
    - Terrform - provisioning and resource creation
    - ansible (edit default config settting) - configure the servers
    - packer - to create AMI
    - AZ CLI
    - AWS CLI
    - Docker
    - reboot
3. To establish connection between server and AzureDevOps UI, 
    - Azure DevOps Self-Hosted Agent Registration PAT/AAD for AzureDevOPS Registration
    - Change the hostname of the server and reeboot the system.
    - Open an agent pool in AzureDevOps UI, add new agent select LINUX and paste the instructions in the server.
    - Once the connection is established create an AMI.
- **PART-2:**
4. Creation of `azure-pipelines.yml`
    - Use powershell and Clone a repositoy whcih contain a java/Maven that can deploy the ROOT.war archive that build.sh
    - Delete the git folder(maps to git repo) and intialize git in order to push it into ADO.
    - Open Agentpool select agent add necessary User-defined capabilities.
    - Create a pipeline in ADO, since we are using self hosted replace `vmImage` with `name` demands User-defined capabilities.
    - Run the code YOU will see the job is successful at
        - Server
        - ADO UI. 