# terraform workspace new Policy

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
    subscription_id      = ""
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }               
}
provider "azurerm" {
    features {}
}


#===================================
# Variables
#===================================


variable "VmSKU_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow VM SKU limitations"
}

variable "Location_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow location limitations"
}

variable "location" {
  type    = string
  default = "centralus"
  description   = "Location of the Service"
}

variable "logAnalyticsWorkspace"{
  type    = string
  default = []
  description = "The log analytics workspace to log Azure activity Logs"
}

variable "AllowedResourceTypes"{
  type    = list(string)
  default = ["Virtual Machines", "Networks", "Accounts", "Vaults", "SQL", "Monitor"]
  description = "a list of allowed resources"
}

#===================================
# Data connections
#===================================
data "azurerm_management_group" "MG_ARS" {
  display_name = "AmericanResidentialServices"
}
#=============================================================================
# Governance
# Allowed Locations
# Allowed locations for resource groups
# Configure Azure Activity logs to stream to specified Log Analytics workspace
# Auto provisioning of the Log Analytics agent should be enabled on your subscription
# Subscriptions should have a contact email address for security issues
# Email notification for high severity alerts should be enabled
# Allowed resource types
# Require a Tag on Resources 
# Require a tag on resource groups
#An activity log alert should exist for specific Policy operations 
#An activity log alert should exist for specific Administrative operations 
#An activity log alert should exist for specific Security operations 
#=============================================================================
#===================================
# Allowed Locations
#===================================    
resource "azurerm_management_group_policy_assignment" "AllowedLocations_ARS" {
    name = "AllowedLocations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "listOfAllowedLocations": {
            "value": ["uscentral"]
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-AllowedLocations_ARS" {
  scope                = azurerm_management_group_policy_assignment.AllowedLocation_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.AllowedLocation_ARS.identity[0].principal_id
}

#===================================
# Allowed Locations for Resource Groups
#===================================    
resource "azurerm_management_group_policy_assignment" "RGAllowedLocations_ARS" {
    name = "RGAllowedLocations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "listOfAllowedLocations": {
            "value": ["uscentral"]
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-RGAllowedLocations_ARS" {
  scope                = azurerm_management_group_policy_assignment.RGAllowedLocation_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.RGAllowedLocation_ARS.identity[0].principal_id
}

#===================================
# Configure Azure Activity logs to stream to specified Log Analytics workspace
#===================================    
resource "azurerm_management_group_policy_assignment" "LogActivity_ARS" {
    name = "LogActivity"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "logAnalytics": {
            "value": "${var.logAnalyticsWorkspace}"
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-LogActivity_ARS" {
  scope                = azurerm_management_group_policy_assignment.LogActivity_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.LogActivity_ARS.identity[0].principal_id
}

#===================================
#Auto provisioning of the Log Analytics agent should be enabled on your subscription
#===================================
resource "azurerm_management_group_policy_assignment" "SubLogAnalytics_ARS" {
    name = "SubLogAnalytics"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/475aae12-b88a-4572-8b36-9b712b2b3a17"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-SubLogAnalytics_ARS" {
  scope                = azurerm_management_group_policy_assignment.SubLogAnalytics_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.SubLogAnalytics_ARS.identity[0].principal_id
}

#===================================
#Subscriptions should have a contact email address for security issues
#===================================
resource "azurerm_management_group_policy_assignment" "SubEmail_ARS" {
    name = "SubEmail"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-SubEmail_ARS" {
  scope                = azurerm_management_group_policy_assignment.SubEmail_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.SubEmail_ARS.identity[0].principal_id
}

#===================================
# Email notification for high severity alerts should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "Alerts_ARS" {
    name = "Alerts"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6e2593d9-add6-4083-9c9b-4b7d2188c899"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-Alerts_ARS" {
  scope                = azurerm_management_group_policy_assignment.Alerts_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.Alerts_ARS.identity[0].principal_id
}

#===================================
# Allowed resource types
#===================================
resource "azurerm_management_group_policy_assignment" "AllowedResources_ARS" {
    name = "AllowedResources"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"
    enforce = true
    not_scopes = var.Location_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "listOfResourceTypesAllowed": {
            "value": "${var.AllowedResourceTypes}"
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-AllowedResources_ARS" {
  scope                = azurerm_management_group_policy_assignment.AllowedResources_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.AllowedResources_ARS.identity[0].principal_id
}



#===================================
# Require a Tag on Resources 
#===================================

# System Tag
resource "azurerm_management_group_policy_assignment" "Tag_System" {
    name = "Tag_System"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "System"
            }
        }
        PARAMETERS
}
# Environment Tag
resource "azurerm_management_group_policy_assignment" "Tag_Environment" {
    name = "Tag_Environment"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "Environment"
            }
        }
        PARAMETERS
}
# CostCenter Tag
resource "azurerm_management_group_policy_assignment" "Tag_CostCenter" {
    name = "Tag_CostCenter"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "CostCenter"
            }
        }
        PARAMETERS
}
# Classification Tag
resource "azurerm_management_group_policy_assignment" "Tag_Classification" {
    name = "Tag_Classification"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "Classification"
            }
        }
        PARAMETERS
}
# LastUpdated Tag
resource "azurerm_management_group_policy_assignment" "Tag_LastUpdated" {
    name = "Tag_LastUpdated"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "LastUpdated"
            }
        }
        PARAMETERS
}

#===================================
#Require a tag on resource groups
#===================================
# BusinessImpact Tag
resource "azurerm_management_group_policy_assignment" "Tag_BusinessImpact" {
    name = "Tag_BusinessImpact"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessImpact"
            }
        }
        PARAMETERS
}
# BusinessOwner Tag
resource "azurerm_management_group_policy_assignment" "Tag_BusinessOwner" {
    name = "Tag_BusinessOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessOwner"
            }
        }
        PARAMETERS
}
# TechnicalOwner Tag
resource "azurerm_management_group_policy_assignment" "Tag_TechnicalOwner" {
    name = "Tag_TechnicalOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "TechnicalOwner"
            }
        }
        PARAMETERS
}

#===================================
#An activity log alert should exist for specific Policy operations 
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_PolicyOperations" {
    name = "Alert_PolicyOperations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
}
#===================================
#An activity log alert should exist for specific Administrative operations 
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_AdminOperations" {
    name = "Alert_AdminOperations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
}

#===================================
#An activity log alert should exist for specific Administrative operations 
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_AdminOperations" {
    name = "Alert_AdminOperations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = var.location
}

#===================================
# VM Sku's
#===================================

resource "azurerm_management_group_policy_assignment" "AllowedVirtualMachineSKUs_ARS" {
    name = "AllowedVirtualMachineSKU"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
    enforce = true
    not_scopes = var.VmSKU_exception
    identity {
        type = "SystemAssigned"
    }
    location = var.location
    parameters =  <<PARAMETERS
        {
          "listOfAllowedSKUs": {
            "value": ["standard_a1_v2","standard_a2_v2","standard_a2m_v2","standard_a4_v2","standard_a4m_v2","standard_a8_v2","standard_a8m_v2","standard_b12ms","standard_b16ms","standard_b1ms","standard_b2ms","standard_b4ms","standard_b8ms","standard_f16s_v2","standard_f2s_v2","standard_f4s_v2","standard_f8s_v2","standard_d16ds_v4","standard_d2ds_v4","standard_d4ds_v4","standard_d8ds_v4","standard_d16ds_v5","standard_d2ds_v5","standard_d4ds_v5","standard_d8ds_v5","standard_e16ds_v4","standard_e2ds_v4","standard_e4ds_v4","standard_e8ds_v4","standard_e16ds_v5","standard_e2ds_v5","standard_e4ds_v5","standard_e8ds_v5"]
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-AllowedVirtualMachineSKUs_ARS" {
  scope                = azurerm_management_group_policy_assignment.AllowedVirtualMachineSKUs_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.AllowedVirtualMachineSKUs_ARS.identity[0].principal_id
}