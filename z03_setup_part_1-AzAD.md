## AAD alternate to PAT
### Prerequisites
-  Azure DevOps organization connected to Microsoft Entra ID
-  User has:
    -   Agent Pool Administrator permissions
    -   Azure DevOps Project permissions
### Steps to establish
1. Create EntraID user
2. Materialize the Identity
3. Allow the Collection Permissions
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
Authentication Type: AAD

## You'll receive a device login code:
To sign in, use a web browser to open:

https://microsoft.com/devicelogin

Enter Code:
ABCD-EFGH
logged in change the paswd to India@2026!Agent6
now add authenticator
Open browser and finish

Agent pool name : AzureAgentPool (for Azure)
 Enter agent name (press enter for azureadoagent) 
 - _work folder will create
 enter
- Install Agent as Service
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
- Check Connection
./run.sh --once 

or

sudo systemctl status vsts.agent.*
```
### Create EntraID user
- In AzurePportal
```sh
Microsoft Entra ID → Users → New User
user - adoadmin@reachtechprasanthgmail.onmicrosoft.com
pswd - India@2026!Agent
- Add permission 
Azure DevOps Administrator
or
Agent Pool Administrator
```
## Materialize the Identity
- Add User to Azure DevOps
```sh
Organization Settings → Users → Add Users
adoadmin@reachtechprasanthgmail.onmicrosoft.com # add
Basic
Organization Settings → Agent Pools → AzureAgentPool → Security
# Grant
Administrator 

or 

Manage
Use
```
- Allow the Collection Permissions
```sh
Organization Settings → Permissions
- add the user under Project Collection Administrators
wait for 2 to 5 min
```
- Verify User Exists
```sh
Organization Settings → Users
```
- via browser use **adoadmin@reachtechprasanthgmail.onmicrosoft.com**, Open Profile,Organization Settings, Project
```sh
https://dev.azure.com/reachai
```
