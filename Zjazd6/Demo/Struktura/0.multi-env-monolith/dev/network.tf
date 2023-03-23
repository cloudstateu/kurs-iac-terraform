resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-app-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "snet_app" {
  name                                          = "sbn-app-01-app"
  resource_group_name                           = azurerm_resource_group.rg.name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = ["10.1.0.0/23"]
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
}

resource "azurerm_subnet" "snet_data" {
  name                                           = "sbn-app-01-data"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = ["10.1.2.0/24"]
  private_endpoint_network_policies_enabled = false
  delegation {
    name = "app-01-mysql-flexible-servers"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "snet_endpoints" {
  name                                           = "sbn-app-01-endpoints"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = ["10.1.3.0/24"]
  private_endpoint_network_policies_enabled = false
  private_link_service_network_policies_enabled  = false
}


resource "azurerm_private_endpoint" "blob" {
  name                = "pe-app-01-blob"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "pe-app-01-blob-connection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.blob.name
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.blob_link
  ]
}

resource "azurerm_private_endpoint" "acr" {
  name                = "pe-app-01-acr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "pe-app-01-acr-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.acr.name
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.acr_link
  ]
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "aks-app.privatelink.westeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_link" {
  name                  = "blob-link"
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_link" {
  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_link" {
  name                  = "aks-link"
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_link" {
  name                  = "acr-link"
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
