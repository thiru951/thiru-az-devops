resource "azurerm_virtual_network" "vnet" {
  name                = "thiru-vnet"
  location            = "centralindia"
  resource_group_name = "thiru-rg"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "thiru-subnet"
  resource_group_name  = "thiru-rg"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "thiru-pip"
  location            = "centralindia"
  resource_group_name = "thiru-rg"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "thiru-nic"
  location            = "centralindia"
  resource_group_name = "thiru-rg"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id         = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "thiru-nsg"
  location            = "centralindia"
  resource_group_name = "thiru-rg"

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "3389"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgassoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "thiru-winvm"
  resource_group_name = "thiru-rg"
  location            = "centralindia"
  size                = "Standard_B2s"

  admin_username = "azureuser"
  admin_password = "Password@12345!"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
