# Management Group Structure

Management Groups are used to organize Azure Subscriptions into use cases that follow similar usage patterns. Azure Policy is deployed at the Management Group level and inforces or audits enviroment rules such as service configuration. 

![ManagementGroup](/MG_Structure/ARS_LandingZone.PNG)

### Workspace

The workspace for this Terraform file is "ManagementGroup" 

To create this workspace in an environment it does not exist run:
```terraform 
terraform workspace new ManagementGroup
```

To move into this workspace run:
```terraform 
terraform workspace select ManagementGroup
```

## American Residential Services

The American Residential Services Mangement group is the first American Residential Services' Management Group under the Microsoft controlled default "Tenant Root Group". This is the scope at wich most Azure Policy will be assigned. The Management Groups below this scope inherit anything assigned at this scope and will be exempted out of specific Azure Policy based on business need and use case. 

## Platform

The Platform Mangement group is home to any resources need to keep the Azure environment running (Hub network, DNS Servers, Archive ect.). 

Subscription Examples:
- Platform Subscription
- Disaster Recovery

>>Only System Engineers should have access and any changes should go through change control. 

## Sandbox

Home for exception to the "Allowed Resource Type" Azure policy. Should be used sparingly and only with business need. 

## Decomissioned

The Decomissioned Mangement group is home to Subscriptions that are Deccomissioned. Azure does not delete Subscriptions so that it can maintain Cost data. Instead it sets Subscriptions to "Disabled" and deallocates any Resources that already exists. 

## Landing Zones

The Landing Zones Mangement group is home to most American Residential Services workloads. The management group is broken down into two main workload types "Public" and "Private". 

>> A "Reader" AD group is a great idea for managers and personel that would benifit from the overview of multiple project workloads. 

## Private

The Private Mangement group is home for any American Residential Services workload that is internal only. Most workloads should fit in this category and have connectivity back to on prem via the Vnet peered to the Platform hub Vnet. 

Subscription Examples:
- PowerBI Data Warehouse

>> This is the default Management Group where new Subscriptions are automatically put when they are Created. 

## Public

The Public Mangement group is home for any American Residential Services workload that is intended for Public use. Workloads that fit in this category will be approved ahead of time and be driven by business need. 

Subscription Examples:
- ARS Website
