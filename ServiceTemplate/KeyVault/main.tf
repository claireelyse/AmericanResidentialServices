# this is an example of what calling the Storage account Module looks like
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

provider "azurerm" {
    features {}
    alias = "PowerBI_TEST"
    subscription_id = "10e94870-6f8c-44a3-bda3-933731eda517"   
}
#module "PowerBI_TEST" {
#  source = "./KeyVault"
#  providers = {
#    azurerm.subscription = azurerm.PowerBI_TEST
#  }
#    resourcegroupname = "Mgmt"
#    subnetid = "/subscriptions/10e94870-6f8c-44a3-bda3-933731eda517/resourceGroups/PowerBI_NPR-Vnet-centralus/providers/Microsoft.Network/virtualNetworks/PowerBI_NPR-Vnet-centralus/subnets/Subnet1"
#    system = "PowerBI"
#    environment = "NPR"
#    costcenter = "9700"
#    classification = "InternalOnly"
#}
