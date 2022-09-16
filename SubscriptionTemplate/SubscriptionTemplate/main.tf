

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
      configuration_aliases = [ azurerm.sub_PRD, azurerm.sub_NPR ]
    }
  }
}

locals {
  # Tennant specific variables
  location = "centralus"
  logAnalyticsWorkspaceId = "/subscriptions/16bb3252-df23-4e46-b6f5-bd09ed36dc51/resourcegroups/mgmt/providers/microsoft.operationalinsights/workspaces/platform"
  
  # Operations specific variables
  infracostcenter = "9700"
  technicalowner = "rmiles@ars.com"
  lastupdated = "${formatdate("MM/DD/YY", timestamp())}"
  
  #name subscription
  subname_PRD = trimspace(join("_", [var.system, "PRD"]))
  subname_NPR = trimspace(join("_", [var.system, "NPR"]))

  #set tags based on scope
  subtags = tomap({
    MonthlyBudget = var.monthlybudget,
    Wiki = var.wiki, 
    BusinessOwner = var.businessowner,
    CostCenter = var.costcenter,
    System = var.system})
  
  rgtags_PRD = tomap({
    System = var.system, 
    CostCenter = local.infracostcenter,
    Classification = "InternalOnly",
    LastUpdated = local.lastupdated,
    BusinessOwner = var.businessowner,
    TechnicalOwner = local.technicalowner
    Environment = "PRD"
    BusinessImpact = "Critical"
    }) 
  
  rgtags_NPR = tomap({
    System = var.system, 
    CostCenter = local.infracostcenter,
    Classification = "InternalOnly",
    LastUpdated = local.lastupdated,
    BusinessOwner = var.businessowner,
    TechnicalOwner = local.technicalowner
    Environment = "NPR"
    BusinessImpact = "Low"
    }) 

  # Set DNS Servers for the VNET
  dns = []
}


#data "azurerm_billing_enrollment_account_scope" "Ea" {
#  billing_account_name    = ""
#  enrollment_account_name = ""
#}

#===================================
# Subscription
# creates terraoform objects for the 2 subscriptions
#===================================
resource "azurerm_subscription" "sub_PRD" {
  provider = azurerm.sub_PRD
  subscription_name = local.subname_PRD
  subscription_id  = var.sub_PRD
  tags = local.subtags
    lifecycle {
        ignore_changes = [tags]
  }
}

resource "azurerm_subscription" "sub_NPR" {
  provider = azurerm.sub_NPR
  subscription_name = local.subname_NPR
  subscription_id  = var.sub_NPR
  tags =   local.subtags
    lifecycle {
        ignore_changes = [tags]
  }
}


# sets a security contact for the subscription
# passes Azure Policy SubEmail, Alerts
# "Subscriptions should have a contact email address for security issues"
resource "azurerm_security_center_contact" "SubEmail_PRD" {
  provider = azurerm.sub_PRD
  email = var.businessowner
  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_contact" "SubEmail_NPR" {
  provider = azurerm.sub_NPR
  email = var.businessowner
  alert_notifications = true
  alerts_to_admins    = true
}

# Configures Activity logs
# passes Azure Policy LogActivity
# Configure Azure Activity logs to stream to specified Log Analytics workspace

resource "azurerm_monitor_diagnostic_setting" "LogActivity_PRD" {
    provider = azurerm.sub_PRD
    name                           = "LogActivity"
    target_resource_id             = "/subscriptions/${var.sub_PRD}"
    log_analytics_workspace_id     = local.logAnalyticsWorkspaceId
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
resource "azurerm_monitor_diagnostic_setting" "LogActivity_NPR" {
    provider = azurerm.sub_NPR
    name                           = "LogActivity"
    target_resource_id             = "/subscriptions/${var.sub_NPR}"
    log_analytics_workspace_id     = local.logAnalyticsWorkspaceId
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
resource "azurerm_security_center_auto_provisioning" "SubLogAnalytics_PRD" {
  provider = azurerm.sub_PRD
  auto_provision = "On"
}
resource "azurerm_security_center_auto_provisioning" "SubLogAnalytics_NPR" {
  provider = azurerm.sub_NPR
  auto_provision = "On"
}
#===================================
# Management RG
#===================================
    resource "azurerm_resource_group" "RG_Mgmt_PRD"{
    provider = azurerm.sub_PRD
    name     = "Mgmt"
    location = local.location
    tags =   local.rgtags_PRD
      lifecycle {
        ignore_changes = [tags]
  }
    }
    resource "azurerm_resource_group" "RG_Mgmt_NPR"{
    provider = azurerm.sub_NPR
    name     = "Mgmt"
    location = local.location
    tags =   local.rgtags_NPR
      lifecycle {
        ignore_changes = [tags]
  }
    }

  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_AdminOperations
  # "An activity log alert should exist for specific Policy operations"

  resource "azurerm_monitor_action_group" "Alert_Operations_PRD" {
  provider = azurerm.sub_PRD 
  name                = "Alert_Operations"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  short_name          = "Alert_Ops"
  email_receiver {
    name          = "Alert_Operations"
    email_address = var.businessowner
    }
  tags =   local.rgtags_PRD
    lifecycle {
        ignore_changes = [tags]
  }
  }
    resource "azurerm_monitor_action_group" "Alert_Operations_NPR" {
  provider = azurerm.sub_NPR 
  name                = "Alert_Operations"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  short_name          = "Alert_Ops"
  email_receiver {
    name          = "Alert_Operations"
    email_address = var.businessowner
    }
    tags =   local.rgtags_NPR
      lifecycle {
        ignore_changes = [tags]
  }
  }
  
#===================================
#Vnet rg
#===================================
    resource "azurerm_resource_group" "RG_VNET_PRD"{
    provider = azurerm.sub_PRD 
    name     = "${local.subname_PRD}-Vnet-${local.location}"
    location = local.location
    tags =   local.rgtags_PRD
    lifecycle {
        ignore_changes = [tags]
    }
    }
        #Vnet
        resource "azurerm_virtual_network" "Vnet_PRD" {
        provider = azurerm.sub_PRD 
        name                = azurerm_resource_group.RG_VNET_PRD.name
        resource_group_name = azurerm_resource_group.RG_VNET_PRD.name
        address_space       = ["${var.peer_PRD}"]
        location            = local.location
        dns_servers         = local.dns
        tags =   local.rgtags_PRD
        lifecycle {
        ignore_changes = [tags]
    }
        }
        resource "azurerm_management_lock" "LOCK_Vnet_PRD" {
        provider = azurerm.sub_PRD 
        name       = "Vnet Lock DO NOT DELETE"
        scope      = azurerm_virtual_network.Vnet_PRD.id
        lock_level = "CanNotDelete"
        notes      = "Contact ${var.businessowner}"
        }
        resource "azurerm_network_watcher" "NWW_Vnet_PRD" {
        provider = azurerm.sub_PRD
        name                = "${local.subname_PRD}-NWW-${local.location}"
        location            = local.location
        resource_group_name = "${local.subname_PRD}-Vnet-${local.location}"
        tags =   local.rgtags_PRD
        lifecycle {
        ignore_changes = [tags]
        }
        }
    resource "azurerm_resource_group" "RG_VNET_NPR"{
    provider = azurerm.sub_NPR
    name     = "${local.subname_NPR}-Vnet-${local.location}"
    location = local.location
    tags =   local.rgtags_NPR
    lifecycle {
        ignore_changes = [tags]
    }
    }
        #Vnet
        resource "azurerm_virtual_network" "Vnet_NPR" {
        provider = azurerm.sub_NPR
        name                = azurerm_resource_group.RG_VNET_NPR.name
        resource_group_name = azurerm_resource_group.RG_VNET_NPR.name
        address_space       = ["${var.peer_NPR}"]
        location            = local.location
        dns_servers         = local.dns
        tags =   local.rgtags_NPR
        lifecycle {
        ignore_changes = [tags]
        }
        }
        resource "azurerm_management_lock" "LOCK_Vnet_NPR" {
        provider = azurerm.sub_NPR
        name       = "Vnet Lock DO NOT DELETE"
        scope      = azurerm_virtual_network.Vnet_NPR.id
        lock_level = "CanNotDelete"
        notes      = "Contact ${var.businessowner}"
        }
        resource "azurerm_network_watcher" "NWW_Vnet_NPR" {
        provider = azurerm.sub_NPR
        name                = "${local.subname_NPR}-NWW-${local.location}"
        location            = local.location
        resource_group_name = "NetworkWatcherRG"
        tags =   local.rgtags_NPR
        lifecycle {
        ignore_changes = [tags]
        }
        }
#===================================
# Identity
#===================================
    resource "azurerm_resource_group" "RG_Identity_PRD"{
    provider = azurerm.sub_PRD
    name     = "Identity"
    location = local.location
    tags =   local.rgtags_PRD
    lifecycle {
        ignore_changes = [tags]
    }
    }
    resource "azurerm_resource_group" "RG_Identity_NPR"{
    provider = azurerm.sub_NPR
    name     = "Identity"
    location = local.location
    tags =   local.rgtags_NPR
    lifecycle {
        ignore_changes = [tags]
    }
    }

#===================================
# Cost Consumption limit
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription
#===================================

#resource "azurerm_monitor_action_group" "ActionGroup" {
#  provider = azurerm.sub_PRD
#  name                = "BudgetActionGroup"
#  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
#  short_name          = "BudgetGroup"
#  tags =   local.rgtags_PRD
#    lifecycle {
#        ignore_changes = [tags]
#    }
#}
#
#resource "azurerm_consumption_budget_subscription" "SubBudget_PRD" {
#  provider = azurerm.sub_PRD
#  name            = "${local.subname_PRD}_Budget"
#  subscription_id = "/subscriptions/${var.sub_PRD}"
#  amount     = var.monthlybudget
#  time_grain = "Monthly"
#    time_period {
#    start_date = "2022-09-01T00:00:00Z"
#  }
#  notification {
#    enabled   = true
#    threshold = 90.0
#    operator  = "EqualTo"
#    contact_emails = [
#      var.businessowner
#    ]
#    contact_groups = [
#      azurerm_monitor_action_group.ActionGroup.id,
#    ]
#    contact_roles = [
#      "Owner",
#    ]
#  }
#  notification {
#    enabled        = true
#    threshold      = 100.0
#    operator       = "GreaterThan"
#    threshold_type = "Forecasted"
#    contact_emails = [
#      var.businessowner
#    ]
#  }
#}
#resource "azurerm_consumption_budget_subscription" "SubBudget_NPR" {
#  provider = azurerm.sub_NPR
#  name            = "${local.subname_NPR}_Budget"
#  subscription_id = "/subscriptions/${var.sub_NPR}"
#  amount     = var.monthlybudget
#  time_grain = "Monthly"
#      time_period {
#    start_date = "2022-09-01T00:00:00Z"
#  }
#  notification {
#    enabled   = true
#    threshold = 90.0
#    operator  = "EqualTo"
#    contact_emails = [
#      var.businessowner
#    ]
#    contact_groups = [
#      azurerm_monitor_action_group.ActionGroup.id,
#    ]
#    contact_roles = [
#      "Owner",
#    ]
#  }
#  notification {
#    enabled        = true
#    threshold      = 100.0
#    operator       = "GreaterThan"
#    threshold_type = "Forecasted"
#    contact_emails = [
#      var.businessowner
#    ]
#  }
#}

#===================================
# Alert Policy
# An activity log alert should exist for specific Policy operations 
# An activity log alert should exist for specific Administrative operations 
# An activity log alert should exist for specific Security operations 
# https://portal.azure.com/#view/Microsoft_Azure_Monitoring_Alerts/AlertRulesBlade/subscriptions~/%5B%5D
#===================================

  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_AdminOperations
  # "An activity log alert should exist for specific Admin operations"
  #===================================
  resource "azurerm_monitor_action_group" "Alert_Ops_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_Ops_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  short_name          = "Alrt_Op"
  email_receiver {
    name          = "Alert_Ops"
    email_address = var.businessowner
    }
    tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [
      tags,
        ]
  }
  }
 resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps1_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps1_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
    tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps2_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps2_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps3_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps3_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps4_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps4_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps5_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps5_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps6_PRD" {
  provider = azurerm.sub_PRD
  name                = "Alert_AdminOps6_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_PolicyOperations
  # "An activity log alert should exist for specific Policy operations"
  #===================================
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOps1_PRD" {
    provider = azurerm.sub_PRD
  name                = "Alert_PolicyOps1_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"
  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOps2_PRD" {
    provider = azurerm.sub_PRD
  name                = "Alert_PolicyOps2_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"
  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_SecurityOperations
  # "An activity log alert should exist for specific Policy operations"
  #===================================
  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps1_PRD" {
    provider = azurerm.sub_PRD
  name                = "Alert_SecurityOps1_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/policies/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps2_PRD" {
    provider = azurerm.sub_PRD
  name                = "Alert_SecurityOps2_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/securitySolutions/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps3_PRD" {
    provider = azurerm.sub_PRD
  name                = "Alert_SecurityOps3_PRD"
  resource_group_name = azurerm_resource_group.RG_Mgmt_PRD.name
  scopes              = ["/subscriptions/${var.sub_PRD}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/securitySolutions/delete"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_PRD.id
  }
  tags =   local.rgtags_PRD
  lifecycle {
        ignore_changes = [tags]
  }
}



#===================================
# Alert Policy
# An activity log alert should exist for specific Policy operations 
# An activity log alert should exist for specific Administrative operations 
# An activity log alert should exist for specific Security operations 
# https://portal.azure.com/#view/Microsoft_Azure_Monitoring_Alerts/AlertRulesBlade/subscriptions~/%5B%5D
#===================================

  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_AdminOperations
  # "An activity log alert should exist for specific Admin operations"
  #===================================
  resource "azurerm_monitor_action_group" "Alert_Ops_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_Ops_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  short_name          = "Alrt_Op"
  email_receiver {
    name          = "Alert_Ops"
    email_address = var.businessowner
    }
    tags =   local.rgtags_NPR
    lifecycle {
            ignore_changes = [tags]
        }
  }
 resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps1_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps1_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
    tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps2_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps2_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"

  criteria {
    operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps3_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps3_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps4_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps4_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps5_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps5_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_AdminOps6_NPR" {
  provider = azurerm.sub_NPR
  name                = "Alert_AdminOps6_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Admin Activity Log Admin event is initiated"
  criteria {
    operation_name = "Microsoft.Network/networkSecurityGroups/securityRules/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_PolicyOperations
  # "An activity log alert should exist for specific Policy operations"
  #===================================
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOps1_NPR" {
    provider = azurerm.sub_NPR
  name                = "Alert_PolicyOps1_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"
  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_PolicyOps2_NPR" {
    provider = azurerm.sub_NPR
  name                = "Alert_PolicyOps2_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Whenever the Policy Activity Log Create policy assignment event is initiated"
  criteria {
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  #===================================
  # create an alert for any Azure Policy Deployments
  # passes Azure Policy Alert_SecurityOperations
  # "An activity log alert should exist for specific Policy operations"
  #===================================
  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps1_NPR" {
    provider = azurerm.sub_NPR
  name                = "Alert_SecurityOps1_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/policies/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}

  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps2_NPR" {
    provider = azurerm.sub_NPR
  name                = "Alert_SecurityOps2_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/securitySolutions/write"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}
  resource "azurerm_monitor_activity_log_alert" "Alert_SecurityOps3_NPR" {
    provider = azurerm.sub_NPR
  name                = "Alert_SecurityOps3_NPR"
  resource_group_name = azurerm_resource_group.RG_Mgmt_NPR.name
  scopes              = ["/subscriptions/${var.sub_NPR}"]
  description         = "Alerts Whenever the Security Activity Log write Security Solution event is initiated"
  criteria {
    operation_name = "Microsoft.Security/securitySolutions/delete"
    category       = "Security"
  }
  action {
    action_group_id = azurerm_monitor_action_group.Alert_Ops_NPR.id
  }
  tags =   local.rgtags_NPR
  lifecycle {
        ignore_changes = [tags]
  }
}

