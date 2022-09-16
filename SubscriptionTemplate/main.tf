

# this is an example of what calling the SubscriptionTemplate Module looks like
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
    alias = "PowerBI_PRD"
    subscription_id = "feb10841-50c4-41bc-a22a-dc0c167ac400"   
}
provider "azurerm" {
    features {}
    alias = "PowerBI_NPR"
    subscription_id = "10e94870-6f8c-44a3-bda3-933731eda517"   
}


module "PowerBI" {
  source = "./SubscriptionTemplate"
    providers = {
    azurerm.sub_PRD = azurerm.PowerBI_PRD
    azurerm.sub_NPR = azurerm.PowerBI_NPR
  }
    sub_PRD = "feb10841-50c4-41bc-a22a-dc0c167ac400"
    sub_NPR = "10e94870-6f8c-44a3-bda3-933731eda517"
    system = "PowerBI"
    businessowner = "rmiles@ars.com"
    costcenter = "9700"
    monthlybudget = "3000"
    wiki = "NA"
    peer_PRD = "10.1.1.0/24"
    peer_NPR = "10.1.1.0/24"
}

