terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.99.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
subscription_id = "5a0855b9-426d-429e-83a9-ea7c4796e9a4"
tenant_id = "b4379ba6-6d53-47fe-b814-910057a92b2b"
features{}
}

 backend "azurerm" {
    resource_group_name   = "RG12"
    storage_account_name  = "strinfraterra"
    container_name        = "tstate"
    key   = "woGcRW115oKYd+fQB3wjTWIiD2/54vKa/0YME7ns+T0HcR/lZO89XEvGXare+/1FS7hGKF/htqa3+ASt0fAGxw=="
}

variable "resource_group_name"{
type = string
default = "appstore1987"
}

variable "storage_name"{
type = string
default = "storagetarun"
}

resource "azurerm_resource_group" "grp" {
name = var.resource_group_name
location = "north europe"
}

resource "azurerm_storage_account" "strterratest"{
name = var.storage_name
resource_group_name = azurerm_resource_group.grp.name
location = azurerm_resource_group.grp.location
account_tier = "standard"
account_replication_type = "LRS"
}
