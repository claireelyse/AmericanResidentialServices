terraform {
  required_version = ">=0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
    }
  }
  backend "azurerm" {
    subscription_id      = "91dbbf4c-74c2-48c7-b7d1-df738837090f"
    resource_group_name  = "cloud-shell-storage-southcentralus"
    storage_account_name = "cs710032002311bd94b"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }               
}
provider "azurerm" {
    features {}
}

variable "peer_NPR" {
  type = string
  default = "10.1.1.0/24"
  description   = "Cidr address for the peer to on-premise network"
  validation {
    condition     = can(cidrhost(var.peer_NPR, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
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
  Alert_Id = "/subscriptions/91dbbf4c-74c2-48c7-b7d1-df738837090f"
  rgtags_NPR = tomap({
    System = "", 
    CostCenter = "local.infracostcenter",
    Classification = "InternalOnly",
    LastUpdated = "local.lastupdated",
    BusinessOwner = "var.businessowner",
    TechnicalOwner = "local.technicalowner"
    Environment = "NPR"
    BusinessImpact = "Low"
    }) 

  ResourceGroup = "cloud-shell-storage-southcentralus"

}

        resource "azurerm_log_analytics_workspace" "LA_Platform" {
        name                = "Platform"
        location            = local.location
        resource_group_name = local.ResourceGroup
        retention_in_days   = 30
        tags = local.rgtags_NPR
          lifecycle {
        ignore_changes = [
          # Ignore changes to tags, e.g. because a management agent
          # updates these based on some ruleset managed elsewhere.
          tags,
            ]
          }
        }
# Configures Activity logs
# passes Azure Policy LogActivity
# Configure Azure Activity logs to stream to specified Log Analytics workspace

resource "azurerm_monitor_diagnostic_setting" "LogActivity" {
    name                           = "LogActivity"
    target_resource_id             = local.Alert_Id
    log_analytics_workspace_id     = "azurerm_log_analytics_workspace.LA_Platform.id"

     log {
        category = "Administrative"
        enabled  = true
        }
     log {
        category = "Alert"
        enabled  = true
        }
      log {
        category = "Autoscale"
        enabled  = true 
        }
      log {
        category = "Policy" 
        enabled  = true
        }
      log {
        category = "Recommendation" 
        enabled  = true 
        }
      log {
        category = "ResourceHealth" 
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
}


        #Vnet
        resource "azurerm_virtual_network" "Vnet_NPR" {
        name                = local.ResourceGroup
        resource_group_name = local.ResourceGroup
        address_space       = ["${var.peer_NPR}"]
        location            = local.location
        tags =   local.rgtags_NPR
        lifecycle {
        ignore_changes = [tags]
        }
        }
        resource "azurerm_management_lock" "LOCK_Vnet_NPR" {
        name       = "Vnet Lock DO NOT DELETE"
        scope      = azurerm_virtual_network.Vnet_NPR.id
        lock_level = "CanNotDelete"
        notes      = "Contact Your System Administrator"
        }


    resource "azurerm_resource_group" "NetworkWatcherRG"{
    name     = "NetworkWatcherRG"
    location = local.location
    }
        resource "azurerm_network_watcher" "NWW_Vnet_NPR" {
        name                = "NetworkWatcher_${local.location}"
        location            = local.location
        resource_group_name = "NetworkWatcherRG"
        tags =   local.rgtags_NPR
        lifecycle {
        ignore_changes = [tags]
        }
        }