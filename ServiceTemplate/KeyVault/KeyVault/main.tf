# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
      configuration_aliases = [ azurerm.subscription ]
    }
  }
}

variable "resourcegroupname" {
  type = string
  description   = "The name of the Resource group to deploy into"
}


variable "subnetid"{
  type = string
  description   = "The id of the subnet to connect into for private networking"
}

#tags
variable "system" {
  type = string
  description   = "Application or workload function Name."
}
variable "environment" {
  type = string
  description   = "The environment this resource belongs to. Determines change control practices."
  validation {
    condition = contains(["PRD", "UAT", "QAT", "DEV", "TRN", "NPR"], var.environment)
    error_message = "Valid value is one of the following: PRD, UAT, QAT, DEV, TRN."
  }
}
variable "costcenter" {
  type = string
  description   = "Cost Center for chargeback"
}
variable "classification" {
  type = string
  description   = "Data type/Data requirements"
  validation {
    condition = contains(["Restricted", "Confidential", "InternalOnly", "Public"], var.classification)
    error_message = "Valid value is one of the following: Restricted, Confidential, InternalOnly, Public."
  }
}


# used in script
resource "random_integer" "int" {
  min = 100
  max = 999
}

locals {
  keyvaultname = lower(trimspace(join("", [var.system, var.environment, random_integer.int.id])))
  location = "centralus"
  lastupdated = "${formatdate("MM/DD/YY", timestamp())}"
}


resource "azurerm_key_vault" "KeyVault" {
  name                        = local.keyvaultname
  location                    = local.location
  resource_group_name         = var.resourcegroupname
  provider                    = azurerm.subscription

  enabled_for_disk_encryption = true
  tenant_id                   = "282406eb-0574-4f28-969c-27b3ce9f6229"
  soft_delete_retention_days  = 30
  purge_protection_enabled    = false
  sku_name = "standard"
 network_acls {
  default_action = "Deny"
  bypass = "AzureServices"
  virtual_network_subnet_ids = [var.subnetid]
 }

  tags = {
    System = var.system
    Environment = var.environment
    CostCenter = var.costcenter
    Classification = var.classification
    LastUpdated = local.lastupdated
  }
  lifecycle {
    ignore_changes = [tags]
    }
}

    resource "azurerm_management_lock" "LOCK_KV" {
    provider = azurerm.subscription
    name       = "Key Vault Lock DO NOT DELETE"
    scope      = azurerm_key_vault.KeyVault.id
    lock_level = "CanNotDelete"
    notes      = "Contact your System Administrator"
    }
  
