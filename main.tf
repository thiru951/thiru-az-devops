resource "azurerm_windows_virtual_machine" "vm" {
  name                = "thiru-winvm"
  resource_group_name = "thiru-rg"
  location            = "centralindia"
  size                = "Standard_B1s"   # ✅ FIXED

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
