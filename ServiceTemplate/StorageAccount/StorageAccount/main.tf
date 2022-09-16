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

#variable "iprules" {
#  type          = string
#  description   = "Example to validate list of IP addresses."
#  validation {
#      condition = can(cidrnetmask(var.iprules))
#      error_message = "Incorrect IP."
#  }
#}

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
  storageaccountname = lower(trimspace(join("", [var.system, var.environment, random_integer.int.id])))
  location = "centralus"
  lastupdated = "${formatdate("MM/DD/YY", timestamp())}"
}

# create the storage account
resource "azurerm_storage_account" "StorageAccount" {
  name                = local.storageaccountname
  resource_group_name = var.resourcegroupname
  provider = azurerm.subscription

  location                 = local.location
  account_kind              = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false

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


resource "azurerm_storage_account_network_rules" "StorageAccountNetwork"{
    storage_account_id = azurerm_storage_account.StorageAccount.id
    provider = azurerm.subscription
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.subnetid]
}

    resource "azurerm_management_lock" "LOCK_SA" {
    provider = azurerm.subscription
    name       = "Storage Account Lock DO NOT DELETE"
    scope      = azurerm_storage_account.StorageAccount.id
    lock_level = "CanNotDelete"
    notes      = "Contact your System Administrator"
    }
  
