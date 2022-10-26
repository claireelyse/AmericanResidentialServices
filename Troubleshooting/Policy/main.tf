# terraform workspace new Platform

# Configure the Azure provider
terraform {
  required_version = ">=0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
    }
  }
  backend "azurerm" {
    subscription_id      = "2aaaea6f-6f28-45c4-bbb3-f966dc631556"
    resource_group_name  = "Azure-Terraform"
    storage_account_name = "arsazureterraform"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }               
}
provider "azurerm" {
    features {}
}

locals{
  location = "centralus"
  DNS = [""]
  System = "Infrastructure"
  Environment = "PRD"
  CostCenter = "9700"
  Classification = "InternalOnly"
  MonthlyBudget = "NA"
  BusinessImpact = "Critical"
  BusinessOwner = "rmiles@ars.com"
  TechnicalOwner = "rmiles@ars.com"
  LastUpdated = "${formatdate("MM/DD/YY", timestamp())}"
  Alert_Id = "/subscriptions/16bb3252-df23-4e46-b6f5-bd09ed36dc51"
  Tags = {
        System = local.System
        Environment = local.Environment
        CostCenter = local.CostCenter
        Classification = local.Classification
        LastUpdated = local.LastUpdated
        MonthlyBudget = local.MonthlyBudget
        BusinessImpact = local.BusinessImpact
        BusinessOwner = local.BusinessOwner
        TechnicalOwner = local.TechnicalOwner
        }
}
#===================================
# Platform
#===================================
/**
data "azurerm_billing_enrollment_account_scope" "Ea" {
  billing_account_name    = ""
  enrollment_account_name = ""
}

**/

resource "azurerm_subscription" "SUB_Platform" {
  subscription_name = "Platform"
#  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.ea.id
  subscription_id = "16bb3252-df23-4e46-b6f5-bd09ed36dc51"
  tags = {
    Wiki = "NA",
    "MonthlyBudget" = "NA"
  }
}
provider "azurerm" {
    features {}
    alias = "Platform"
    subscription_id = "16bb3252-df23-4e46-b6f5-bd09ed36dc51"  
}


# sets a security contact for the subscription
# passes Azure Policy SubEmail, Alerts
# "Subscriptions should have a contact email address for security issues"
resource "azurerm_security_center_contact" "SubEmail" {
  provider = azurerm.Platform
  email = local.BusinessOwner
  alert_notifications = true
  alerts_to_admins    = true
}

# Configures Activity logs
# passes Azure Policy LogActivity
# Configure Azure Activity logs to stream to specified Log Analytics workspace

resource "azurerm_monitor_diagnostic_setting" "LogActivity" {
    name                           = "LogActivity"
    provider = azurerm.Platform
    target_resource_id             = local.Alert_Id
    log_analytics_workspace_id     = azurerm_log_analytics_workspace.LA_Platform.id
    log {
        category = "Administrative"
        enabled  = true
        }
    log {
        category = "Security"
        enabled  = true
        }
    log {
        category = "ServiceHealth"
        enabled  = true
        }        
    log {
        category = "Alert"
        enabled  = true
        }
    log {
        category = "Recommendation"
        enabled  = true
        }
    log {
        category = "Policy"
        enabled  = true
        }
    log {
        category = "Autoscale"
        enabled  = true
        }
    log {
        category = "ResourceHealth"
        enabled  = true
        } 
}

# Configures auto provisioning of Log analytics onto VM's
# passes Azure Policy SubLogAnalytics
# Auto provisioning of the Log Analytics agent should be enabled on your subscription
resource "azurerm_security_center_auto_provisioning" "SubLogAnalytics" {
  provider = azurerm.Platform
  auto_provision = "On"
}


    #===================================
    # Resource Group Mgmt
    #===================================
    resource "azurerm_resource_group" "RG_Mgmt"{
    provider = azurerm.Platform
    name     = "Mgmt"
    location = local.location
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
    }

        resource "azurerm_log_analytics_workspace" "LA_Platform" {
        provider = azurerm.Platform
        name                = "Platform"
        location            = local.location
        resource_group_name = azurerm_resource_group.RG_Mgmt.name
        retention_in_days   = 30
        tags = local.Tags
          lifecycle {
        ignore_changes = [
          # Ignore changes to tags, e.g. because a management agent
          # updates these based on some ruleset managed elsewhere.
          tags,
            ]
          }
        }
        resource "azurerm_management_lock" "LOCK_LA_Platform" {
        provider = azurerm.Platform
        name       = "Vnet Lock DO NOT DELETE"
        scope      = azurerm_log_analytics_workspace.LA_Platform.id
        lock_level = "CanNotDelete"
        }

  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_AdminOperations
  # "An activity log alert should exist for specific Admin operations"

  resource "azurerm_monitor_action_group" "Alert_Operations" {
  provider = azurerm.Platform
  name                = "Alert_Operations"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  short_name          = "Alrt_Op"
  email_receiver {
    name          = "Alert_Operations"
    email_address = local.BusinessOwner
    }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
  }
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_AdminOperations
  # "An activity log alert should exist for specific Policy operations"
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations1" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations1"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/write"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations2" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations2"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations3" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations3"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations4" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations4"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations5" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations5"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOperations6" {
  provider = azurerm.Platform
  name                = "Alert_AdminOperations6"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}


  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_PolicyOperations
  # "An activity log alert should exist for specific Policy operations"
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOperations1" {
    provider = azurerm.Platform
  name                = "Alert_PolicyOperations1"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"

  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOperations2" {
    provider = azurerm.Platform
  name                = "Alert_PolicyOperations2"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"

  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
  tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_SecurityOperations
  # "An activity log alert should exist for specific Policy operations"

  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOperations1" {
    provider = azurerm.Platform
  name                = "Alert_SecurityOperations1"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"

  criteria {
    operation_name = "Microsoft.Security/policies/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOperations2" {
    provider = azurerm.Platform
  name                = "Alert_SecurityOperations2"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"

  criteria {
    operation_name = "Microsoft.Security/securitySolutions/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOperations3" {
    provider = azurerm.Platform
  name                = "Alert_SecurityOperations3"
  resource_group_name = azurerm_resource_group.RG_Mgmt.name
  scopes              = [local.Alert_Id]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"

  criteria {
    operation_name = "Microsoft.Security/securitySolutions/delete"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Operations.id
  }
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
}
    
    #===================================
    # Resource Group Network
    #===================================
    resource "azurerm_resource_group" "RG_Network"{
    provider = azurerm.Platform
    name     = "Network"
    location = local.location
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
    }
    /**
        resource "azurerm_virtual_network" "Vnet_Platform" {
        provider = azurerm.Platform
        name                = "Vnet_Platform"
        resource_group_name = azurerm_resource_group.RG_Network.name
        address_space       = ["${var.Peer.Vnet_Platform}"]
        location            = local.location
        dns_servers         = local.dns
        }
        resource "azurerm_management_lock" "LOCK_Vnet_Platform" {
        name       = "Vnet Lock DO NOT DELETE"
        scope      = azurerm_virtual_network.Vnet_Platform.id
        lock_level = "CanNotDelete"
        }
        **/
    #===================================
    # Resource Group Identity
    #===================================
    resource "azurerm_resource_group" "RG_Identity"{
    provider = azurerm.Platform
    name     = "Identity"
    location = local.location
    tags = local.Tags
  lifecycle {
        ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
        ]
  }
    }
   
