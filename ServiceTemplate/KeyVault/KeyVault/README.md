# Storage Accounts – Blob Storage

#### Assumptions
Resource group already exists
Subnet already exists - find subnet ID 
- az network vnet subnet list -g MyResourceGroup --vnet-name MyVNet

#### Description
Storage Accounts store data objects including blobs, file shares, queues, tables, and disks. For the sake of this document, we will be evaluating blob storage specifically. Deployment of this template creates 3 resources.
 - 1 random number
 - 1 key vault
 - 1 lock

#### Inputs
| Name | Description|
| ---| ------|
|IpRules | Example to validate list of IP addresses. |
| SubnetId | The id of the subnet to connect into for private networking |
| System | Application or workload function Name. |
| Environment | The environment this resource belongs to. Determines change control practices | 
| CostCenter | Cost Center for chargeback|
| Classification | Data type/Data requirements |


#### Security Roles & Access Controls
- Are there any unique RBAC permissions needed to deploy or manage the resource?
    - 	User principals need Contributor to create Key Vaults but can give themselves access to list keys so be careful who had Contributor over the scope a Key Vault is kept in. 
    -	Use Service principals to manage key vault operations.
    -	Use a separate Key Vault for every application. 

#### Data Collection & Storage
Are there any security best practices for connecting to the data? (SSL, HTTPS, SMB, SAS tokens, Encryption etc.)
    - Enable Logging
What SKU’s are recommended and why? 
 - Standard

- What does Disaster recovery of the Data vs the resource look like?
    -	Turn on soft delete so that accidentally deleted keys can be recovered (set to 30 days).  
    -	Use Purge protection for accentual deletion of the Key Vault.

#### Security Policies & Recommendations
-	What Azure policies can be used to manage this resource and it’s configuration?
    -	Resource logs in Key Vault should be enabled
    -	Key vaults should have purge protection enabled

Ongoing Security Monitoring
-	How is this resource being logged? 
    -	Diagnostic settings are sent to Platform Log analytics
-	What sorts of alerts and metrics need to be set up to manage app performance?
    -	Azure defender will provide out of the box metrics so long as logs are sent to the Log Analytics Workspace.ace.

#### Developer Operations (DevOps)
-	What does an Ideal deployment of this resource look like as Infrastructure as Code?
    -	Azure_Base\ServiceTemplate\KeyVault\main.tf
-	What does continuous integration and code deployment to this resource look like? 
    -	Service Template Infrastructure as Code should be kept in a Repository that development teams have access to pull from. Pipelines can be set up to deploy services for each
-	What does release management look like for development teams and System Engineer teams?
    -	As a new requirement for storage accounts has been updated by System Engineer teams it will be pushed into the main branch of the repo. The development teams will have access to pull the main branch for uses in their project deployments.
-	What sorts of Load testing and Auto scaling requirements are needed for this resource?
    -	No load testing or auto scaling requirements are needed outside of Microsoft testing.
-	Naming standard requirements
    -	<SystemTag><EnvironmentTag><number> 
        -	3-24 character string
        -	containing only 0-9, a-z, A-Z, and -.

#### Checklist
 - [x]	Create Terraform Resource Template in Azure DevOps
 - [x]	Deploy Azure Policy for Logging
 -  [x]	Deploy Azure Policy for Azure Defender
 -  [x]	Deploy Azure Policy for Best Practices
 -  [x]	Update Azure Policy Documentation



