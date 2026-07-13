
#                                     AzureDevOps Part-1/2
## Creation of ADO Agent to run the jobs
### Launch server
- Take a linux server any cloud platform (azure) with 2 cpu, 8Gb RAM. 
    - use ssh@adminuser@<publicip>, enter passsword
### Install tools
```sh
sudo vi bootstrap.sh
sudo chmod +x bootstrap.sh
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
#### PAT/AAD for AzureDevops Authentication refer below

#### Create an AMI to aviod the above steps
- create an AMI for future usage the total time consumed is 40 min if rg, subnet are created manually.
- If you want to launch using AMI use IAM role ``.
- We can see the default variable available in th linux agent click on capabilities we can target a specific and also add capability  AWS.
- **Next Step is to Clone the git hub  used for elastic bean stack**





