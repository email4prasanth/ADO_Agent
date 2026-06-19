# Plan of Action: Automated Infrastructure Provisioning via Azure DevOps & Terraform

This Plan of Action (POA) delivers a production-ready, multi-stage architecture blueprint to provision our specific Azure stack across **Development**, **QA**, and **Production** environments using **Terraform** and **Azure DevOps Pipelines**.

---

## 🏗️ 1. Project Directory & Workspace Layout
Organize our [Azure Repos](https://azure.com) directory structure to enforce strict separation of concerns using our defined module scheme.

```text 
ai_infra/
├── .gitignore
├── azure-pipelines.yml             # Main multi-stage pipeline configuration
├── ReadMe.md                       # Overview of the current repo
├── templates/                      
│   └── terraform-steps.yml         # Reusable step definitions (init, plan, apply)
└── ai_infra/
    └── backend-infra/
        ├── local.tf                # Local variable evaluation and maps
        ├── network.tf              # VNet, Subnets, and Private Endpoints
        ├── outputs.tf              # Resource IDs and connection strings
        ├── provider.tf             # AzureRM & AzureAD provider configurations
        ├── resource_group.tf       # Environment-scoped lifecycle groups
        ├── security_group.tf       # Network Security Groups (NSG) and firewall rules
        ├── aks.tf                   # Virtual Machine module mapping
        ├── main.tf                 # Component orchestration (KV, SWA, APIM, Redis, Postgres, Front Door)
        └── variables.tf            # Variable declarations (environment, location, SKUs)
```

---

## 🔒 2. Prerequisites & Remote State Setup
Configure our central control plane in Azure and Azure DevOps before initiating automation tasks.

### Azure Cloud Level
* **0. Region Lockdown**: Select a primary target region (e.g., `East US`) to establish data residency and low-latency peering.
* **1. Cost & Discovery Planning**: Establish enterprise subscription spending limits and create an initial inventory spreadsheet of required SKUs.
* **2. Core Management Resource Group (`rg-inlogicai-mgmt`)**:
  * **Self-Hosted DevOps Agent**: Provision a dedicated Ubuntu/Windows VM (Minimum specs: **2 vCPU, 8GB RAM**) configured with the Azure DevOps agent pool runtime.
  * **Bootstrap Key Vault**: Deploy an access-controlled Key Vault to securely manage long-lived service principal client secrets and administrative infrastructure keys.
* **3. State Management Storage Resource Group (`rg-inlogicai-tfstate`)**:
  * Create a unified, geo-redundant Azure Storage Account containing three separate access-isolated blob containers to store environment-specific state records:
    * `dev.terraform.tfstate`
    * `qa.terraform.tfstate`
    * `prod.terraform.tfstate`

### Azure DevOps Level
* **Repository Architecture**: Provision a single target Git repository under our enterprise organization workspace.
* **Branching Model**: Standardize our feature delivery workflow across three core environment branches: `dev`, `qa`, and `main` (Production).
* **Branch Protection Policies**: Enforce strict peer code reviews (Pull Requests) on `qa` and `main` branches. Require a successful Terraform validation and structural plan build run before merging code.

### Trust Relations & Authentication (Handshake)
* Create an **Azure Service Principal (SPN)** or utilize **Workload Identity Federation (OIDC)** within Azure Active Directory.
* Configure a secure **Azure Resource Manager Service Connection** inside Azure DevOps Project Settings using these credentials.
* Grant this Service Principal **Contributor** and **User Access Administrator** roles on target subscriptions, alongside explicit **Key Vault Secrets Officer** permissions to manage infrastructure workflows smoothly.

---

## 🛠️ 3. Resource Group & Naming Strategy
Enforce standard corporate governance across all provisioned modules using the definitive structural format: **Environment-ProjectName-ResourceName**.

```sh
┌───► [dev-inlogicai-rg]  ───► (Dev Stack: Low-cost SKUs, Single-instance DB)
┼───► [qa-inlogicai-rg]   ───► (QA Stack: Mirror of production baseline, lower tiers)
└───► [prod-inlogicai-rg] ───► (Prod Stack: Multi-zone High Availability, Premium Tiers)
```

---

## 📝 4. Terraform Core Module Engineering
Map our foundational configuration blocks inside the `ai_infra/backend-infra/` path to meet these standard enterprise requirements:

| Resource Type | Service Core Configuration Requirements |
| :--- | :--- |
| **Networking Hub** | **Azure Front Door Premium** handles global CDN routing, TLS termination, and WAF rules. Traffic routes to **API Management (APIM)** and **Static Web App** backends. |
| **Secrets & Keys** | **Azure Key Vault** deployed first with `purge_protection_enabled = true`. Modules store database passwords and keys via managed identity access. |
| **Compute Engine** | **Azure Virtual Machine** configured with custom SSH keys and an isolated network security group (NSG) allowing ingress only from verified jumpboxes. |
| **Web UI** | **Azure Static Web App** tied to standard SKUs with customized staging environments for QA validation checks. |
| **Storage & Images** | **Azure Blob Storage** for assets (with private endpoints) and **Azure Container Registry (ACR)** running the Premium tier for geo-replication. |
| **Data Layer** | **Azure Managed PostgreSQL (Flexible Server)** with High Availability enabled for `prod`, and **Azure Cache for Redis** for session optimization. Both use private endpoints. |
| **Observability** | **Azure Monitor** containing a unified Log Analytics Workspace. Diagnostic settings on all modules track logs and metrics. |

---

## 🚀 5. Multi-Stage Azure DevOps Pipeline
Implement this branch-conditional layout within our root `azure-pipelines.yml` file to handle progression across environments safely.

```sh
trigger:
  branches:
    include:
      - dev
      - qa
      - main

stages:
- stage: Validate
- stage: Security Scan
# ==========================================
# DEVELOPMENT LIFECYCLE
# ==========================================
- stage: Dev_Plan
- stage: Dev_Apply
# ==========================================
# QA LIFECYCLE
# ==========================================
- stage: QA_Plan
- stage: QA_Apply
# ==========================================
# PRODUCTION LIFECYCLE
# ==========================================
- stage: Prod_Plan
- stage: Prod_Apply
```
---

## 🔒 6. Governance & Environment Controls
Protect our environment workloads by configuring guardrails directly inside [Azure DevOps Environments](https://azure.com).

* **Manual Approvals**: Configure **Pipelines** ➡️ **Environments** ➡️ **Infrastructure-Prod**. Add an approval check requiring sign-off from our Release Manager or Lead Architect before executing `Prod_Apply`.
* **Exclusive Lock**: Enable the Exclusive Lock check on **Infrastructure-QA** and **Infrastructure-Prod** environments to prevent state corruption from overlapping concurrent pipeline runs.
* **Branch Restrictions**: Explicitly restrict deployment permissions on our QA and Production environments, limiting execution solely to matching target branch runs (`refs/heads/qa` and `refs/heads/main`).
* **Server Privilage** and **Database Privilage** are set at different levels manager(Readonly), devops, developers (read and write) access.

| Role            | Infrastructure | Database              | Key Vault       |
| --------------- | -------------- | --------------------- | --------------- |
| Manager         | Reader         | Read Only             | Reader          |
| Developer       | Reader         | Read/Write (Dev & QA) | Secrets User    |
| DevOps Engineer | Contributor    | Admin                 | Secrets Officer |
| Architect       | Owner          | Admin                 | Administrator   |
