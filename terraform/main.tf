terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "class-schedule-rg"  # Name of the resource group where your storage account resides
  #   storage_account_name = "storageaccount"
  #   container_name       = "tfstate"                # Name of the blob container for state files
  #   key                  = "terraform.tfstate"      # The path/name of the state file within the container
  # }
}
provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# resource "azurerm_storage_account" "storage_account" {
#   name                     = "storageaccount"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
# }

module "vnet" {
  source = "./modules/vnet"

  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  prefix                       = var.prefix
  vnet_address_space           = var.vnet_address_space
  private_subnet_address_space = var.private_subnet_address_space
  public_subnet_address_space  = var.public_subnet_address_space
  bastion_subnet_address_space = var.bastion_subnet_address_space
  db_subnet_address_space      = var.db_subnet_address_space
  redis_subnet_address_space   = var.redis_subnet_address_space
  # bastion_nsg_id               = module.bastio_nsg.network_security_group_id
  postgre_nsg_id               = module.postgre_nsg.network_security_group_id
  redis_nsg_id                 = module.redis_nsg.network_security_group_id

  depends_on = [ module.app_nsg, module.backend_nsg, module.postgre_nsg, module.proxy_nsg, module.redis_nsg,]
}

module "app_nsg" {
  source                     = "./modules/nsg"
  resource_group_name        = azurerm_resource_group.rg.name
  use_for_each               = var.use_for_each
  custom_rules               = var.app_custom_rules
  destination_address_prefix = var.destination_address_prefix
  security_group_name        = var.app_nsg_name
  source_address_prefix      = var.source_address_prefix
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group.rg]
}
module "backend_nsg" {
  source                     = "./modules/nsg"
  resource_group_name        = azurerm_resource_group.rg.name
  use_for_each               = var.use_for_each
  custom_rules               = var.backend_custom_rules
  destination_address_prefix = var.destination_address_prefix
  security_group_name        = var.backend_nsg_name
  source_address_prefix      = var.source_address_prefix
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group.rg]
}

module "proxy_nsg" {
  source                     = "./modules/nsg"
  resource_group_name        = azurerm_resource_group.rg.name
  use_for_each               = var.use_for_each
  custom_rules               = var.proxy_custom_rules
  destination_address_prefix = var.destination_address_prefix
  security_group_name        = var.proxy_nsg_name
  source_address_prefix      = var.source_address_prefix
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group.rg]
}

# module "bastio_nsg" {
#   source                     = "./modules/nsg"
#   resource_group_name        = azurerm_resource_group.rg.name
#   use_for_each               = var.use_for_each
#   custom_rules               = var.bastion_custom_rules
#   destination_address_prefix = var.destination_address_prefix
#   security_group_name        = var.bastion_nsg_name
#   source_address_prefix      = var.source_address_prefix
#   tags                       = var.tags
#   depends_on                 = [azurerm_resource_group.rg]
# }

module "postgre_nsg" {
  source                     = "./modules/nsg"
  resource_group_name        = azurerm_resource_group.rg.name
  use_for_each               = var.use_for_each
  custom_rules               = var.postgre_custom_rules
  destination_address_prefix = var.destination_address_prefix
  security_group_name        = var.postgre_nsg_name
  source_address_prefix      = var.source_address_prefix
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group.rg]
}

module "redis_nsg" {
  source                     = "./modules/nsg"
  resource_group_name        = azurerm_resource_group.rg.name
  use_for_each               = var.use_for_each
  custom_rules               = var.redis_custom_rules
  destination_address_prefix = var.destination_address_prefix
  security_group_name        = var.redis_nsg_name
  source_address_prefix      = var.source_address_prefix
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group.rg]
}
module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = var.prefix
  subnet_id           = module.vnet.bastion_subnet_id
}

module "backend_vm" {
  source                       = "./modules/vm"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  prefix                       = var.prefix
  vm_name                      = "backend"
  vm_size                      = "Standard_B1s"
  admin_username               = var.admin_username
  os_disk_caching              = var.vm_os_disk_caching
  os_disk_storage_account_type = var.vm_os_disk_storage_account_type
  pub_key_path                 = var.vm_pub_key_path
  subnet_id                    = module.vnet.private_subnet_id
  nsg_id                       = module.backend_nsg.network_security_group_id
}

module "app_vm" {
  source                       = "./modules/vm"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  prefix                       = var.prefix
  vm_name                      = "app"
  vm_size                      = var.vm_size
  admin_username               = var.admin_username
  os_disk_caching              = var.vm_os_disk_caching
  os_disk_storage_account_type = var.vm_os_disk_storage_account_type
  pub_key_path                 = var.vm_pub_key_path
  subnet_id                    = module.vnet.private_subnet_id
  nsg_id                       = module.app_nsg.network_security_group_id
}

resource "azurerm_public_ip" "proxy_ip" {
  name                = "${var.prefix}-proxy-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "proxy_vm" {
  source                       = "./modules/vm"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  prefix                       = var.prefix
  vm_name                      = "proxy"
  vm_size                      = var.vm_size
  admin_username               = var.admin_username
  os_disk_caching              = var.vm_os_disk_caching
  os_disk_storage_account_type = var.vm_os_disk_storage_account_type
  pub_key_path                 = var.vm_pub_key_path
  subnet_id                    = module.vnet.public_subnet_id
  nsg_id                       = module.proxy_nsg.network_security_group_id
  public_ip_id                 = azurerm_public_ip.proxy_ip.id
}

module "redis_vm" {
  source                       = "./modules/vm"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  prefix                       = var.prefix
  vm_name                      = "redis"
  vm_size                      = "Standard_B1s"
  admin_username               = var.admin_username
  os_disk_caching              = var.vm_os_disk_caching
  os_disk_storage_account_type = var.vm_os_disk_storage_account_type
  pub_key_path                 = var.vm_pub_key_path
  subnet_id                    = module.vnet.redis_subnet_id
  nsg_id                       = module.redis_nsg.network_security_group_id
}

module "postgres" {
  source                 = "./modules/postgres"
  server_name            = var.postgre_server_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  existing_vnet_id       = module.vnet.vnet_id
  delegated_subnet_id    = module.vnet.postgre_subnet_id
  administrator_login    = var.postgre_admin_user
  administrator_password = var.postgre_admin_password
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/vars.yml.tpl", {
    app_private_ip      = module.app_vm.private_ip[0],
    app_vm_name         = module.app_vm.vm_name,
    backend_private_ip  = module.backend_vm.private_ip[0],
    backend_vm_name     = module.backend_vm.vm_name,
    proxy_private_ip    = module.proxy_vm.private_ip[0],
    proxy_public_ip     = azurerm_public_ip.proxy_ip.ip_address,
    proxy_vm_name       = module.proxy_vm.vm_name,
    postgre_hostname    = module.postgres.server_hostname,
    redis_private_ip    = module.redis_vm.private_ip[0],
    redis_vm_name       = module.redis_vm.vm_name,
    bastion_name        = module.bastion.bastion_name
  })

  # Define where the inventory file will be created.
  # Assuming your Ansible playbooks are in a parallel 'ansible' directory:
  filename = "${path.module}/../ansible/vars.yml"

  # Or if you want it in the current Terraform directory (less common for Ansible projects):
  # filename = "${path.module}/inventory.ini"
}