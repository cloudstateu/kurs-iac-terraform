resource "azurerm_resource_group" "jenkins_rg" {
  name     = "rg-jenkins"
  location = "West Europe"
}

resource "azurerm_virtual_network" "jenkins_vnet" {
  name                = "vnet-jenkins"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jenkins_rg.location
  resource_group_name = azurerm_resource_group.jenkins_rg.name
}

resource "azurerm_subnet" "jenkins_vnet_subnet" {
  name                 = "vnet-jenkins-subnet"
  resource_group_name  = azurerm_resource_group.jenkins_rg.name
  virtual_network_name = azurerm_virtual_network.jenkins_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "jenkins_pip" {
  name                = "pip-jenkins"
  allocation_method   = "Static"
  location            = azurerm_resource_group.jenkins_rg.location
  resource_group_name = azurerm_resource_group.jenkins_rg.name
}

resource "azurerm_network_interface" "example" {
  name                = "nic-jenkins"
  location            = azurerm_resource_group.jenkins_rg.location
  resource_group_name = azurerm_resource_group.jenkins_rg.name

  ip_configuration {
    name                          = "nic-jenkins-ip-config"
    subnet_id                     = azurerm_subnet.jenkins_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "jenkins-vm" {
  name                            = "vm-jenkins"
  admin_username                  = "azureuser"
  admin_password                  = "Kdu;_ufLCcX[3>+"
  disable_password_authentication = false
  location                        = azurerm_resource_group.jenkins_rg.location
  network_interface_ids           = [
    azurerm_network_interface.example.id,
  ]
  resource_group_name = azurerm_resource_group.jenkins_rg.name
  size                = "Standard_B2s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = filebase64("init-jenkins.txt")

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "random_string" "storage_suffix" {
  length  = 5
  special = false
  upper   = false
  lower   = true
}

output "jenkins-ip" {
  value = azurerm_public_ip.jenkins_pip.ip_address
}
