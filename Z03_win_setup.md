- Download the windows x64 zip file in the folder C:\agents
- unzip the folder
```sh
ls
cd C:\agents\vsts-agent-win-x64-5.276.0
.\config.cmd
Server URL: https://dev.azure.com/reachai/
Authentication type: PAT
Agent Pool: AzureAgentPool
Agent Name: winadoagent
Y
_work (enter)
Run agent as service: Y
Enable SERVICE_SID_TYPE_UNRESTRICTED: Y
User account: Press Enter (NT AUTHORITY\NETWORK SERVICE) Y
Prevent service starting immediately: N (or just press Enter)

```
- To remove agent
```sh
cd C:\agents\vsts-agent-win-x64-5.276.0
.\config.cmd remove
PAT
```
