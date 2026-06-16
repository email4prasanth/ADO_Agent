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
    - Generate PAT in AzureDevOPS UI
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
#                                     AzureDevOps Part-1/2
## Creation of ADO Agent to run the jobs
### Launch server
- Take a linux server any cloud platform (azure) with 2 cpu, 8Gb RAM. 
    - use ssh@adminuser@<publicip>, enter passsword
### Install tools
```sh
vi bootstrap.sh
chmod +x bootstrap.sh
sudo ./bootstrap.sh
./bootstrap.sh 2>&1 | tee bootstrap.log
```
### Establish connection between server and AzureDevOps UI
#### How to add the above server as an agent?
- Go to AzureDevOps myapp project at the left side bottom we can find project settings
- Go to agent pools, click on add pool select self-hosted and name it as “AzureAgentPool”, add full access.
- ![](https://github.com/email4prasanth/AzureDevOps/blob/master/azuredevopsimage/05-getagent.png)
    <!-- - agentpool -->

- Login to AZURE change hostname to `azureadoagent` 
    ```
    sudo nano /etc/hostname
    azureadoagent #Replace the existing
    Check the tools terraform, ansible, packer, jq, curl, java (it will be there else install)
    reboot
    ```
#### PAT for AzureDevops Authentication
- For authentication - 37:45
    - Click on settting (right top corner) new tab on PAT
    - New token
    - Name- DevOpsADOToken
    - Organization - testingdkuttiado
    - Expire for 10 days
    - Scope -full access
    - Create
    - Copy and save
#### Creating AGENT in the server using AzureDevOps UI 
- Once you are in `/home/adminuser` click on `New Agent` select **Linux**, copy and paste in the ubuntu server, make sure you are using `adminuser` user.
```
 mkdir myagent && cd myagent
 - copy Download the agent, then open server
 wget https://vstsagentpackage.azureedge.net/agent/4.274.1/vsts-agent-linux-x64-4.274.1.tar.gz
 ll (agent got downloaded)
 tar xzvf https://vstsagentpackage.azureedge.net/agent/4.274.1/vsts-agent-linux-x64-4.274.1.tar.gz
 ll
 sudo rm -rf vsts-agent-linux-x64-4.274.1.tar.gz
 ./config.sh
 Y
 https://dev.azure.com/reachai/ (URL upto organization)
 Enter
 Token paste PAT
 Agent pool name : AzureAgentPool (for Azure)
 Enter agent name (press enter for azureadoagent) 
 - _work folder will create
 enter
./run.sh & 
```
- ./run.sh & (this apsersent (&) will run in the backed end even if you come out from the putty)
- 50:27 agent is ready.
#### Create an AMI to aviod the above steps
- create an AMI for future usage the total time consumed is 40 min if rg, subnet are created manually.
- If you want to launch using AMI use IAM role ``.
- We can see the default variable available in th linux agent click on capabilities we can target a specific and also add capability  AWS.
- **Next Step is to Clone the git hub  used for elastic bean stack**


#                                     AzureDevOps Part-2/2
## Creating azure-pipeline.yml
### Clone the git hub  used for elastic bean stack 
- create an empty folder `practice-ado` and open it by using powershell
```
git clone https://github.com/aws-samples/eb-tomcat-snakes.git myjavaapp
cd .\myjavaapp\
git remote -v
Remove git form the folder since we dont wont to push to git repo
git status
git init
```
<!-- - 06 ado-repo image -->
### Push code to AzureDevOps repo 
<!-- - image -->
```
git add .; git commit -m “java based code”
git branch
git remote add origin <>
git remote -v
git push origin master

```
- It will ask ID and password, Check the code is available or not, Then go to pipelines-54:38
- There are two types of pipelines
    - YAML Pipelines
    - Classic Pipelines is in GUI format only and in YAML format only in repo
- IQ: Ask to write YAML file
- open project settings -- agent pools -- LinuxAgentPool -- capabilites `AWS:YES` and AzureAgentPool -- capabilites `AZURE:YES`
- 57:09 - Creating a pipeline
pipelines- Create pipeline - azure repo git - myapp - starter pipeline
Check-1
Loop name: LinuxAgentPool
Demands -https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool-demands?view=azure-pipelines
- `AWS -equals YES` and with agent name - 1:00:40(49:50)
- 1:05:00 - the agents are working properly
    <!-- - 08-listening job -->
Check-2
Loop name: AzureAgentPool
Demands -
- `AZURE -equals YES` and with agent name 
- 1:05:00 - the agents are working properly
    <!-- - 08-listening job -->

