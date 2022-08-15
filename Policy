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
variable "location" {
  default = "centralus"
  description   = "Location of the Service"
}

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

#===================================
# Data connections
#===================================
data "azurerm_management_group" "MG_ARS" {
  display_name = "AmericanResidentialServices"
}

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
# VM Skus
#===================================
/**
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

#===================================
# Tagging
#===================================

# BU Tag
resource "azurerm_management_group_policy_assignment" "Tag_System" {
    name = "System_Tag"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"
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
resource "azurerm_role_assignment" "assignment-Tag_System_ARS" {
  scope                = azurerm_management_group_policy_assignment.Tag_System.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.Tag_System.identity[0].principal_id
}

**/
