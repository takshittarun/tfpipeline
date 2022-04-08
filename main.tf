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
  features {}

}

variable "storage_account_name" {
  type = string
  default = "storagetarun"
}

variable "network_name" {
  type = string
  default = "staging"
}

variable "vm_name" {
  type = string
  default = "stagingvm"

}

resource "azurerm_resource_group" "grp" {
  name = "appstore1987"
  location = "north europe"
}
resource "azurerm_virtual_network" "staging" {
  name = var.network_name
  location = azurerm_resource_group.grp.location
  resource_group_name = azurerm_resource_group.grp.name
  address_space = ["10.0.0.0/16"]

  subnet {
    address_prefix = "10.0.0.0/24"
        name = "default"
  } 
}

resource "azurerm_network_interface" "interface" {
  name = "default-interface"
  location = resource_group_name.location
  resource_group_name = resource_group_name.grp.name
  ip_configuration {
    name = "interfaceconfiguration"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
    name = var.vm_name
    location = azurerm_resource_group.grp.location
    resource_group_name = azurerm_resource_group.grp.name
    network_interface_ids = azurerm_network_interface.interface.id
  vm_size = "standard_DS1_V2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
storage_image_reference {
  publisher = "Canonical"
  offer = "UbuntuServer"
  sku = "18.04-LTS"
  version = "latest"
}
storage_os_disk {
  name = "osdisk1"
  caching = "ReadWrite"
  create_option = "FromImage"
  managed_disk_type = "Standard_LRS"
}
 os_profile {
    computer_name  = "stagingvm"
    admin_username = "azureadmin"
    admin_password = "Test@12345678"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}