
# Subscription Configureation Template

#### Assumptions
- Two subscriptions ID's for a Production and non-production Set up
- The subscription is created in the AmericanResidential Services/LandingZone/Private Management Group
- The Network Peering to the Hub Vnet must be done manually. 
- Configure Azure Activity logs to stream to specified Log Analytics workspace must be configured manually to Pass Azure Policy.

#### Workspace
All Subscriptions will be deployed into the "Subscription" Template

#### Description
Configures 2 Subscriptions for production and non-proiduction workloads. Deployment of this template creates 42 resources.
 - 2 Subscriptions
 - 6 Resource Groups
 - 2 Vnets
 - 2 Vnet Locks
 - 2 Network Watcher
 - 30 Resources to configure Subscriptions to pass Azure Policy
 >> Alerts need a unique name, changing the name property requires a recreate of the alert resource. If you name multiple alerts the same thing, it will not fail or throw a warning. Every time you run a plan it will have you update the operation_name parameter and must be recreated with a unique name to solve the issue. 

#### Inputs
| Name | Description|
| ---| ------|
| sub_PRD | Subscription Id for Prod Subscription |
| sub_NPR | Subscription Id for Non-Prod Subscription |
| system |  System this Subscription will contain |
| businessowner | Email Distribution group that Ownes the Subscription |
| costcenter | Cost Center for the subscription |
| monthlybudget | Monthly budget for the Subscription |
| wiki | link to documentation |
| peer_PRD | Cidr address for the peer to on-premise network |
| peer_NPR | Cidr address for the peer to on-premise network |

#### Naming standard requirements
 | Resource | Name |
 | ---| ------|
 | Production Subscription | <SubscriptionName>_<PRD>-Vnet-<location> |
 | non-Production Subscription | <SubscriptionName>_<NPR>-Vnet-<location> |
 | Resource Group for Networking | <SubscriptionName>-Vnet-<location> |
 | Resource Group for Subscription Management | Mgmt |
 | Resource Group for Identity Management | Identity |
 | Vnet | <SubscriptionName>-Vnet-<location> |

