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
# Management groups
#===================================

#ARS
resource "azurerm_management_group" "MG_ARS" {
  display_name = "AmericanResidential Services"
  parent_management_group_id = ""
}
resource "azurerm_role_assignment" "MG_ARS_Read" {
scope                = azurerm_management_group.MG_ARS.id
role_definition_name = "Reader"
principal_id         = "" # id of the AD group or user
}

  #Platform
  resource "azurerm_management_group" "MG_Platform" {
  display_name = "Platform"
  parent_management_group_id = azurerm_management_group.MG_ARS.id
  subscription_ids = [
    ""
  ]
  } 

  #Sandbox
  resource "azurerm_management_group" "MG_Sandbox" {
  display_name = "Sandbox"
  parent_management_group_id = azurerm_management_group.MG_ARS.id
  subscription_ids = [
    ""
  ]
  } 

  #Decommissioned
  resource "azurerm_management_group" "MG_Decommissioned" {
  display_name = "Decommissioned"
  parent_management_group_id = azurerm_management_group.MG_ARS.id
  subscription_ids = [
    ""
  ]
  } 

  #Landing Zones
  resource "azurerm_management_group" "MG_LandingZone" {
  display_name = "LandingZone"
  parent_management_group_id = azurerm_management_group.MG_ARS.id
  subscription_ids = [
    ""
  ]
  } 
    #Private
    resource "azurerm_management_group" "MG_Private" {
    display_name = "Private"
    parent_management_group_id = azurerm_management_group.MG_LandingZone.id
    subscription_ids = [
      ""
    ]
    }   
    
    #Public
    resource "azurerm_management_group" "MG_Public" {
    display_name = "Public"
    parent_management_group_id = azurerm_management_group.MG_LandingZone.id
    subscription_ids = [
      ""
    ]
    } 
  


