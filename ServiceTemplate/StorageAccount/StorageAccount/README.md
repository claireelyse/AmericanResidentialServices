# Storage Accounts – Blob Storage

#### Assumptions
Resource group already exists
Subnet already exists - find subnet ID 
- az network vnet subnet list -g MyResourceGroup --vnet-name MyVNet

#### Description
Storage Accounts store data objects including blobs, file shares, queues, tables, and disks. For the sake of this document, we will be evaluating blob storage specifically. Deployment of this template creates 3 resources.
 - 1 random number
 - 1 storage Account
 - 1 storage account network rules
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
- 	Are there any unique RBAC permissions needed to deploy or manage the resource?
    - 	Unlike user principals, security principals need explicit rights to access blob data. Storage Blob Data Contributor will allow the security principal to read, write and delete containers and blobs. 
-	How is internal access to the resource provisioned?
    -	Users can create and access Storage accounts by provisioning the Contributor RBAC role using Azure AD authentication. 
    -	Services should prioritize using service principals first, then Shared Access Signature tokens to access blob data if Active directory authentication is not available. 

#### Data Collection & Storage
-	Are there any security best practices for connecting to the data? (SSL, HTTPS, SMB, SAS tokens, Encryption etc.)
    -	Use HTTPS connections to access storage account. 
    -	Keep storage account keys in Azure Key Vault and rotate your keys on a periodic basis.
    -	Disable public access to the storage account.
    -	Ensure that the TLS version is above the minimum required.
-	What does Disaster recovery of the Data vs the resource look like?
    -	 GRS – creates a read only a geo-redundant copy of the storage account.
    -	Turn on soft delete for blobs and containers to retrieve data that was deleted.
-	What SKU’s are recommended and why?  
    -	Azure general-purpose v2 (GPv2) is the most recent Microsoft recommended version.
    -	The SKU Standard_ZRS should work for most scenarios. For important Highly available applications use Standard_RA-GRS for a read only geo-redundant copy of your data. Be aware that replication may cause data loss and project teams will need to work through this checklist before the solution is production ready.
    -	Hot storage is best suited for active data operations. Cool or archive storage may be cheaper to store long term data but is more expensive for write operations and is not suitable for regular use. 

#### Security Policies & Recommendations
-	What Azure policies can be used to manage this resource and it’s configuration?
    -	Secure transfer to storage accounts should be enabled
    -	[Preview]: Storage account public access should be disallowed
    -	Storage accounts should allow access from trusted Microsoft services
    -	Azure Defender for Storage should be enabled
    -	Storage accounts should have the specified minimum TLS version
    -	[deprecated]Configure diagnostic settings for storage accounts to Log Analytics workspace – need to enforce this with IAC
Ongoing Security Monitoring
-	How is this resource being logged? 
    -	Diagnostic settings are sent to Platform Log analytics
-	What sorts of alerts and metrics need to be set up to manage app performance?
    -	Azure defender will provide out of the box metrics so long as logs are sent to the Log Analytics Workspace.

#### Developer Operations (DevOps)
-	What does an Ideal deployment of this resource look like as Infrastructure as Code?
    -	Azure_Base\ServiceTemplate\StorageAccount\main.tf
-	What does continuous integration and code deployment to this resource look like? 
    -	Service Template Infrastructure as Code should be kept in a Repository that development teams have access to pull from. Pipelines can be set up to deploy services for each
-	What does release management look like for development teams and System Engineer teams?
    -	As a new requirement for storage accounts has been updated by System Engineer teams it will be pushed into the main branch of the repo. The development teams will have access to pull the main branch for uses in their project deployments.
-	What sorts of Load testing and Auto scaling requirements are needed for this resource?
    -	No load testing or auto scaling requirements are needed outside of Microsoft testing.
-	Naming standard requirements
    -	<SystemTag><EnvironmentTag><number> 
        -	Global	
        -	3-24 characters 
        -	Lower case	
        -	Alphanumeric
#### Checklist
 - [x]	Create Terraform Resource Template in Azure DevOps
 - [x]	Deploy Azure Policy for Logging
 - [x]	Deploy Azure Policy for Azure Defender
 - [x]	Deploy Azure Policy for Best Practices
 - [x]	Update Azure Policy Documentation



