terraform {
  backend "azurerm" {
    resource_group_name = "remote-back-rg"
    storage_account_name = "remoteback1"
    container_name = "tfstate-container"
    key = "terraform.tfstate"
  }
}