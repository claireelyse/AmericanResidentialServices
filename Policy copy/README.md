# Azure Policy

### Naming standard

The Terraform naming standard for the resources is:
<ResourceIdentifier>_<PolicyPurpose>_<Scope>

Resource Identifier 
 - NW - Network
 - DB - Database
 - SA - Storage Account
 - VM - Virtual Machiene
 - KV - Key Vault
 - IAM - Identity and Access Management
 - DEF - Azure Defender

 >> I did not write an identifier for General Policies so they will just be named <PolicyPurpose>_<Scope>

### Workspace

The workspace for this Terraform file is "Policy" 

To create this workspace in an environment it does not exist run:
```terraform 
terraform workspace new Policy
```

To move into this workspace run:
```terraform 
terraform workspace select Policy
```

### Access
Azure Policies that will actually make changes in your environment will need an assignment resource as well as the Azure Policy. If you create one of these policies in the Azure Portal the access assignment will be created for you, However, in Terraform you need to create it seperately

## Networking 

### Subnets should be associated with a Network Security Group
Description: “Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517

Effect: AuditIfNotExists

Scope: American Residential Services

### Network interfaces should disable IP forwarding
Description: “This policy denies the network interfaces which enabled IP forwarding. The setting of IP forwarding disables Azure's check of the source and destination for a network interface. This should be reviewed by the network security team.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900

Effect: Deny

Scope: American Residential Services

### Network Watcher should be enabled
Description: “Network Watcher is a regional service that enables you to monitor and diagnose conditions at a network scenario level in, to, and from Azure. Scenario level monitoring enables you to diagnose problems at an end-to-end network level view. It is required to have a network watcher resource group to be created in every region where a virtual network is present. An alert is enabled if a network watcher resource group is not available in a particular region.”

Definition ID:

Effect: AuditIfNotExists

Scope: American Residential Services

## Databases

### Configure Azure SQL database servers diagnostic settings to Log Analytics workspace
Description: “Enables auditing logs for Azure SQL Database server and stream the logs to a Log Analytics workspace when any SQL Server which is missing this auditing is created or updated”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/7ea8a143-05e3-4553-abfe-f56bef8b0b70

Effect: DeployIfNotExists

Scope: American Residential Services

### Deploy SQL DB transparent data encryption
Description: “Enables transparent data encryption on SQL databases”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f

Effect: DeployIfNotExists

Scope: American Residential Services

### Configure SQL servers to have auditing enabled to Log Analytics workspace 
Description: “To ensure the operations performed against your SQL assets are captured, SQL servers should have auditing enabled. If auditing is not enabled, this policy will configure auditing events to flow to the specified Log Analytics workspace.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/25da7dfb-0666-4a15-a8f5-402127efd8bb

Effect: DeployIfNotExists

Scope: American Residential Services

### Enforce SSL connection should be enabled for MySQL database servers
Description: “Azure Database for MySQL supports connecting your Azure Database for MySQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/e802a67a-daf5-4436-9ea6-f6d821dd0c5d

Effect: Audit

Scope: American Residential Services

### Enforce SSL connection should be enabled for PostgreSQL database servers
Description: “Azure Database for PostgreSQL supports connecting your Azure Database for PostgreSQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/d158790f-bfb0-486c-8631-2dc6b4e8e6af

Effect: Audit

Scope: American Residential Services

### An Azure Active Directory administrator should be provisioned for SQL servers
Description: “Audit provisioning of an Azure Active Directory administrator for your SQL server to enable Azure AD authentication. Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/1f314764-cb73-4fc9-b863-8eca98ac36e9

Effect: AuditIfNotExists

Scope: American Residential Services

## Storage Account 

### Secure transfer to storage accounts should be enabled
Description: “Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9

Effect: Deny

Scope: American Residential Services

### Storage account public access should be disallowed
Description: “Anonymous public read access to containers and blobs in Azure Storage is a convenient way to share data but might present security risks. To prevent data breaches caused by undesired anonymous access, Microsoft recommends preventing public access to a storage account unless your scenario requires it.

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751

Effect: Deny

Scope: American Residential Services

### Storage accounts should allow access from trusted Microsoft services
Description: “Some Microsoft services that interact with storage accounts operate from networks that can't be granted access through network rules. To help this type of service work as intended, allow the set of trusted Microsoft services to bypass the network rules. These services will then use strong authentication to access the storage account.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd

Effect: Deny

Scope: American Residential services

## VM’s 

### Network interfaces should not have public Ips
Description: “This policy denies the network interfaces which are configured with any public IP. Public IP addresses allow internet resources to communicate inbound to Azure resources, and Azure resources to communicate outbound to the internet. This should be reviewed by the network security team.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114

Effect: Deny

Scope: Platform, Private

### Allowed virtual machine size SKUs
Description: “This policy enables you to specify a set of virtual machine size SKUs that your organization can deploy.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3

Effect: Deny

Scope: American Residential Services

Parameters: "standard_a1_v2","standard_a2_v2","standard_a2m_v2","standard_a4_v2","standard_a4m_v2","standard_a8_v2","standard_a8m_v2","standard_b12ms","standard_b16ms","standard_b1ms","standard_b2ms","standard_b4ms","standard_b8ms","standard_f16s_v2","standard_f2s_v2","standard_f4s_v2","standard_f8s_v2","standard_d16ds_v4","standard_d2ds_v4","standard_d4ds_v4","standard_d8ds_v4","standard_d16ds_v5","standard_d2ds_v5","standard_d4ds_v5","standard_d8ds_v5","standard_e16ds_v4","standard_e2ds_v4","standard_e4ds_v4","standard_e8ds_v4","standard_e16ds_v5","standard_e2ds_v5","standard_e4ds_v5","standard_e8ds_v5"

Notes: Sku’s might change based on processor needs

## Key Vault

### Resource logs in Key Vault should be enabled
Description: “Audit enabling of resource logs. This enables you to recreate activity trails to use for investigation purposes when a security incident occurs or when your network is compromised”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/cf820ca0-f99e-4f3e-84fb-66e913812d21

Effect: AuditifNotExists

Scope: American Residential Services

### Key vaults should have purge protection enabled
Description: “Malicious deletion of a key vault can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge key vaults. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted key vaults. No one inside your organization or Microsoft will be able to purge your key vaults during the soft delete retention period.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53

Effect: Deny

Scope: American Residential Services

### 5.3.1.6	Governance
Allowed locations

Description: “This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c

Effect: Deny

Scope: American Residential Services

### Allowed locations for resource groups
Description: “This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988

Effect: Deny

Scope: American Residential Services

Parameters: USCentral

### Configure Azure Activity logs to stream to specified Log Analytics workspace
Description: “Deploys the diagnostic settings for Azure Activity to stream subscriptions audit logs to a Log Analytics workspace to monitor subscription-level events”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f

Effect: DeployIfNotExists

Scope: American Residential Services

### Auto provisioning of the Log Analytics agent should be enabled on your subscription

Description: “To monitor for security vulnerabilities and threats, Azure Security Center collects data from your Azure virtual machines. Data is collected by the Log Analytics agent, formerly known as the Microsoft Monitoring Agent (MMA), which reads various security-related configurations and event logs from the machine and copies the data to your Log Analytics workspace for analysis. We recommend enabling auto provisioning to automatically deploy the agent to all supported Azure VMs and any new ones that are created.”

Effect: AuditIfNotExists

Scope: American Residential Services

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/475aae12-b88a-4572-8b36-9b712b2b3a17

### Subscriptions should have a contact email address for security issues
Description: “To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, set a security contact to receive email notifications from Security Center.”

Effect: AuditIfNotExists

Scope: American Residential Services

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7

### Email notification for high severity alerts should be enabled
Description: “To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, enable email notifications for high severity alerts in Security Center.”

Effect: AuditIfNotExists

Scope:  American Residential Services

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/6e2593d9-add6-4083-9c9b-4b7d2188c899

### Allowed resource types
Description: “This policy enables you to specify the resource types that your organization can deploy. Only resource types that support 'tags' and 'location' will be affected by this policy. To restrict all resources please duplicate this policy and change the 'mode' to 'All'.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c

Effect: Deny

Scope: Landing Zones

Parameters: Virtual Machines, Networks, Accounts, Vaults, SQL, Monitor

Notes: push separately over “Decommissioned”

### Require a tag and its value on resources
Description: “Enforces a required tag and its value. Does not apply to resource groups.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62

Effect: Deny

Scope: American Residential Services

### Inherit a tag from the resource group if missing
Description: "Adds the specified tag with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070

Effect: Deny

Scope: American Residential Services

### An activity log alert should exist for specific Policy operations 
Description: "This policy audits specific Policy operations with no activity log alerts configured."

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858

Effect: AuditIfNotExists

Scope: American Residential Services

### An activity log alert should exist for specific Administrative operations 
Description: "This policy audits specific Administrative operations with no activity log alerts configured."

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a

Effect: AuditIfNotExists

Scope: American Residential Services

Notes: (Create, Update, or Delete Network Security Group; Create, Update, or Delete SQL Server Firewall Rule)

### An activity log alert should exist for specific Security operations 
Description: “This policy audits specific Security operations with no activity log alerts configured.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052

Effect: AuditIfNotExists

Scope: American Residential Services


## Identity and Access Management

### MFA should be enabled on accounts with owner permissions on your subscription
Description: “Multi-Factor Authentication (MFA) should be enabled for all subscription accounts with owner permissions to prevent a breach of accounts or resources.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/aa633080-8b72-40c4-a2d7-d00c03e80bed

Effect: AuditIfNotExists

Scope: American Residential Services

### External accounts with owner permissions should be removed from your subscription
Description: “External accounts with owner permissions should be removed from your subscription in order to prevent unmonitored access.”

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/f8456c1c-aa66-4dfb-861a-25d127b775c9

Effect: AuditIfNotExists

Scope: American Residential Services

Notes: Review external account access at quarterly.

## Azure Defender

### Azure Defender for App Service should be enabled
Description: “Azure Defender for App Service leverages the scale of the cloud, and the visibility that Azure has as a cloud provider, to monitor for common web app attacks.”

Effect: AuditIfNotExists

Definition ID: /providers/Microsoft.Authorization/policyDefinitions/2913021d-f2fd-4f3d-b958-22354e2bdbcb

### Azure Defender for Azure SQL Database servers should be enabled
Description: “Azure Defender for SQL provides functionality for surfacing and mitigating potential database vulnerabilities, detecting anomalous activities that could indicate threats to SQL databases, and discovering and classifying sensitive data.”

Effect: AuditIfNotExists

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/7fe3b40f-802b-4cdd-8bd4-fd799c948cc2

### Azure Defender for Key Vault should be enabled
Description: “Azure Defender for Key Vault provides an additional layer of protection and security intelligence by detecting unusual and potentially harmful attempts to access or exploit key vault accounts.

Effect: AuditIfNotExists

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/0e6763cc-5078-4e64-889d-ff4d9a839047

### Azure Defender for servers should be enabled
Description: “Azure Defender for servers provides real-time threat protection for server workloads and generates hardening recommendations as well as alerts about suspicious activities.”

Effect: AuditIfNotExists

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/4da35fc9-c9e7-4960-aec9-797fe7d9051d

### Azure Defender for Storage should be enabled
Description: “Azure Defender for Storage provides detections of unusual and potentially harmful attempts to access or exploit storage accounts.”

Effect: AuditIfNotExists

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/308fbb08-4ab8-4e67-9b29-592e93fb94fa

### Azure Kubernetes Service clusters should have Defender profile enabled
Description: “Microsoft Defender for Containers provides cloud-native Kubernetes security capabilities including environment hardening, workload protection, and run-time protection. When you enable the SecurityProfile.AzureDefender on your Azure Kubernetes Service cluster, an agent is deployed to your cluster to collect security event data. Learn more about Microsoft Defender for Containers in https://docs.microsoft.com/azure/defender-for-cloud/defender-for-containers-introduction?tabs=defender-for-container-arch-aks”

Effect: Audit

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/a1840de2-8088-4ea8-b153-b4c723e9cb01

### Microsoft Defender for Containers should be enabled
Description: “Microsoft Defender for Containers provides hardening, vulnerability assessment and run-time protections for your Azure, hybrid, and multi-cloud Kubernetes environments.”

Effect: AuditIfNotExists

Definition ID:  /providers/Microsoft.Authorization/policyDefinitions/1c988dd6-ade4-430f-a608-2a3e5b0a6d38
