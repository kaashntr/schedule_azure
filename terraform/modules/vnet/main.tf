resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_address_space]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_address_space]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_address_space]
}

resource "azurerm_subnet" "postgre_subnet" {
  name                 = "AzureDatabaseSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.db_subnet_address_space]
  delegation {
    name = "postgresqlDelegation" # You can choose any unique name for the delegation
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "redis_subnet" {
  name                 = "AzureRedisSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.redis_subnet_address_space]
}

resource "azurerm_public_ip" "nat_public_ip" {
  name                = "${var.prefix}-nat-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "frontend_nat" {
  name                = "${var.prefix}-nat"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.frontend_nat.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "app_subnet_nat_assoc" {
  subnet_id     = azurerm_subnet.public_subnet.id
  nat_gateway_id = azurerm_nat_gateway.frontend_nat.id
}

# resource "azurerm_subnet_network_security_group_association" "bastion_assciation" {
#   subnet_id = azurerm_subnet.bastion_subnet.id
#   network_security_group_id = var.bastion_nsg_id
# }

resource "azurerm_subnet_network_security_group_association" "postgre_assciation" {
  subnet_id = azurerm_subnet.postgre_subnet.id
  network_security_group_id = var.postgre_nsg_id
}

resource "azurerm_subnet_network_security_group_association" "redis_assciation" {
  subnet_id = azurerm_subnet.redis_subnet.id
  network_security_group_id = var.redis_nsg_id
}