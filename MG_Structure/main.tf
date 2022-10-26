# terraform workspace new ManagementGroup

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


#===================================
# Management groups
#===================================

#ARS
resource "azurerm_management_group" "ARS" {
  display_name = "AmericanResidentialServices"
}
/**
resource "azurerm_role_assignment" "ARS_Read" {
scope                = azurerm_management_group.ARS.id
role_definition_name = "Reader"
principal_id         = "" # id of the AD group or user
}
resource "azurerm_role_assignment" "ARS_SE" {
scope                = azurerm_management_group.ARS.id
role_definition_name = "Contributor"
principal_id         = "" # id of the AD group or user
}
**/
  #Platform
  resource "azurerm_management_group" "Platform" {
  display_name = "Platform"
  parent_management_group_id = azurerm_management_group.ARS.id
  } 

  #Sandbox
  resource "azurerm_management_group" "Sandbox" {
  display_name = "Sandbox"
  parent_management_group_id = azurerm_management_group.ARS.id
  } 

  #Decommissioned
  resource "azurerm_management_group" "Decommissioned" {
  display_name = "Decommissioned"
  parent_management_group_id = azurerm_management_group.ARS.id
  } 

  #Landing Zones
  resource "azurerm_management_group" "LandingZone" {
  display_name = "LandingZone"
  parent_management_group_id = azurerm_management_group.ARS.id
  } 
    #Private
    resource "azurerm_management_group" "Private" {
    display_name = "Private"
    parent_management_group_id = azurerm_management_group.LandingZone.id
    }   
    
    #Public
    resource "azurerm_management_group" "Public" {
    display_name = "Public"
    parent_management_group_id = azurerm_management_group.LandingZone.id
    } 



