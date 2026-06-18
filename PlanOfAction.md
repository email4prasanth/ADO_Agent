# Plan of Action: Automated Infrastructure Provisioning via Azure DevOps & Terraform

This Plan of Action (POA) delivers a production-ready, multi-stage architecture blueprint to provision your specific Azure stack across **Development**, **QA**, and **Production** environments using **Terraform** and **Azure DevOps Pipelines**.

---

## 🏗️ 1. Project Directory & Workspace Layout
Organize your [Azure Repos](https://microsoft.com) directory structure to enforce separation of concerns across your environments (**dev**, **qa**, **prod**).

```text
ai_infra/
.
├── .gitignore
├── azure-pipelines.yml             
├── templates/                      
│   └── terraform-steps.yml
└── ai_infra/
    └── backend-infra/
        ├── local.tf
        ├── network.tf
        ├── outputs.tf
        ├── provider.tf
        ├── resource_group.tf
        ├── security_group.tf
        └── vm.tf 
```

---

## 🔒 2. Prerequisites & Remote State Setup
Configure central control plane in Azure and Azure DevOps before executing any automation.
### Azure cloud level
0. Fix the region where to host the resources.
1. Cost Analysis and resource list
2. Dediated Resource group to 
 - Create Virtual machine for AzureDevOps Agent.
 - Key vault as contirbutor access to manage long-lived client secrets in Azure DevOps.
3. Dediated Resource group for Storage Account to store terraform state file for
  - development environment
  - qa environment
  - prod environmnet


### AzureDevOps level
- Name of the Repository under organisation.
- Naming convention of environmnets and branches.
- Brach protection rules.
- 
---

## 🛠️ 3. Resource Group & Naming Strategy
To manage costs and policies, organize your resources into lifecycle-specific Resource Groups **Environment-ProjectName-ResourceName**.

┌───► [dev-inlogicai-rg]  ───► (Dev Stack: Low-cost SKUs)
┼───► [qa-inlogicai-rg]   ───► (QA Stack: Testing Baseline)
└───► [prod-inlogicai-rg] ───► (Prod Stack: HA / Zone Redundant)
---

## 📝 4. Terraform Core Module Engineering
Design your local modules inside the `/modules` directory according to these architectural guidelines:

| Resource Type | Service Core Configuration Requirements |
| :--- | :--- |
| **Networking Hub** | **Azure Front Door Premium** handles global CDN routing, TLS termination, and Web Application Firewall (WAF) rule sets. Traffic routes directly to **API Management (APIM)** and the **Static Web App** backends. |
| **Secrets & Keys** | **Azure Key Vault** deployed first with `purge_protection_enabled = true`. Other modules store runtime secrets (e.g., Postgres passwords, Redis connection strings) here via managed identity access. |
| **Compute Engine** | **Azure Virtual Machine** configured with custom SSH keys and an isolated network security group (NSG) that allows ingress *only* from verified application jumpboxes. |
| **Web UI** | **Azure Static Web App** tied to standard SKUs with customized staging environments for QA validation checks. |
| **Storage & Images** | **Azure Blob Storage** for application assets (configured with private endpoints) and **Azure Container Registry (ACR)** running the Premium tier for automated geo-replication. |
| **Data Layer** | **Azure Managed PostgreSQL (Flexible Server)** with High Availability enabled for `prod`, and **Azure Cache for Redis** for session optimization. Both use private endpoints. |
| **Observability** | **Azure Monitor** containing a unified Log Analytics Workspace. Diagnostic settings on all modules track logs and metrics. |

---
## 🚀 5. Multi-Stage Azure DevOps Pipeline
Implement this YAML layout within `.azure-pipelines/azure-pipelines.yml`.
---
## 🔒 6. Governance & Environment Controls
Protect your production workload by configuring guardrails directly inside [Azure DevOps Environments](https://microsoft.com).

* **Manual Approvals**: Navigate to **Pipelines** ➡️ **Environments** ➡️ **Infrastructure-Prod**. Add a **Check** requiring explicit sign-off from team leads or a Release Manager before execution.
* **Exclusive Lock**: Enable the Exclusive Lock check on Production to ensure only a single pipeline run updates the infrastructure state at any given time.
* **Branch Restrictions**: Restrict deployment permissions for the QA and Production environments to runs originating from the `refs/heads/main` branch.