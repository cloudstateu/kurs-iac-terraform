locals {
  vnet_address_space            = var.vnet_address_space //x.x.0.0/16
  snet_app_address_prefix       = cidrsubnet(local.vnet_address_space, 7, 0) //x.x.0.0/23
  snet_data_address_prefix      = cidrsubnet(local.vnet_address_space, 8, 2) //x.x.2.0/24
  snet_endpoints_address_prefix = cidrsubnet(local.vnet_address_space, 8, 3) //x.x.3.0/24
  snet_jumphost_address_prefix  = cidrsubnet(local.vnet_address_space, 8, 4) //x.x.4.0/24
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resources.virtual-network}-${var.environment}-${var.project_name}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [local.vnet_address_space]
}

resource "azurerm_virtual_network_peering" "app_to_shared" {
  name                      = "${local.resources.virtual-network}-${var.environment}-${var.project_name}-01-to-${local.environments.shared}-${var.project_name}-01"
  remote_virtual_network_id = data.azurerm_virtual_network.shared.id
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
}

resource "azurerm_virtual_network_peering" "shared_to_app" {
  name                      = "${local.resources.virtual-network}-${local.environments.shared}-${var.project_name}-01-to-${var.environment}-${var.project_name}-01"
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  resource_group_name       = data.azurerm_resource_group.shared.name
  virtual_network_name      = data.azurerm_virtual_network.shared.name
}

resource "azurerm_subnet" "snet_app" {
  name                                           = "${local.resources.subnet}-${var.environment}-${var.project_name}-01-app"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [local.snet_app_address_prefix]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

resource "azurerm_subnet" "snet_data" {
  name                                           = "${local.resources.subnet}-${var.environment}-${var.project_name}-01-data"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [local.snet_data_address_prefix]
  enforce_private_link_endpoint_network_policies = true
  delegation {
    name = "${local.resources.subnet}-${var.environment}-${var.project_name}-01-mysql-flexible-servers"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "snet_endpoints" {
  name                                           = "${local.resources.subnet}-${var.environment}-${var.project_name}-01-endpoints"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [local.snet_endpoints_address_prefix]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
}

resource "azurerm_network_security_group" "nsg_snet_app" {
  name                = "${local.resources.network-security-group}-${var.environment}-${var.project_name}-01-sbn-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsg_snet_app_ingress" {
  name                        = "AllowIngressTraffic"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_snet_app.name
}

resource "azurerm_network_security_group" "nsg_snet_app_02" {
  name                = "${local.resources.network-security-group}-${var.environment}-${var.project_name}-02-sbn-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsg_snet_app_02_ingress" {
  name                        = "AllowIngressTraffic"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_snet_app_02.name
}

resource "azurerm_network_security_group" "nsg_snet_data" {
  name                = "${local.resources.network-security-group}-${var.environment}-${var.project_name}-01-sbn-data"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_snet_app" {
  subnet_id                 = azurerm_subnet.snet_app.id
  network_security_group_id = azurerm_network_security_group.nsg_snet_app.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_snet_data" {
  subnet_id                 = azurerm_subnet.snet_data.id
  network_security_group_id = azurerm_network_security_group.nsg_snet_data.id
}

locals {
  zones = {
    "blob"  = "privatelink.blob.core.windows.net"
    "mysql" = "privatelink.mysql.database.azure.com"
    "aks"   = "aks-app-${var.environment}.privatelink.${azurerm_resource_group.rg.location}.azmk8s.io"
    "acr"   = "privatelink.azurecr.io"
  }
}

resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each = local.zones

  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_links" {
  for_each = local.zones

  name                  = each.value
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_to_shared" {
  name                  = azurerm_private_dns_zone.private_dns_zones["aks"].name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zones["aks"].name
  virtual_network_id    = data.azurerm_virtual_network.shared.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_private_endpoint" "blob" {
  name                = "${local.resources.private-endpoint}-${var.environment}-${var.project_name}-01-blob"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "${local.resources.private-endpoint}-${var.environment}-${var.project_name}-01-blob-connection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.private_dns_zones["blob"].name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zones["blob"].id]
  }

  depends_on = [
    azurerm_private_dns_zone.private_dns_zones,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links
  ]
}

resource "azurerm_private_endpoint" "acr" {
  name                = "${local.resources.private-endpoint}-${var.environment}-${var.project_name}-01-acr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "${local.resources.private-endpoint}-${var.environment}-${var.project_name}-01-acr-connection"
    private_connection_resource_id = data.azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.private_dns_zones["acr"].name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zones["acr"].id]
  }

  depends_on = [
    azurerm_private_dns_zone.private_dns_zones,
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnet_links
  ]
}


