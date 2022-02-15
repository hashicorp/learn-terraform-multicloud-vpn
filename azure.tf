provider "azurerm" {
  features {}
}

terraform {}

resource "azurerm_resource_group" "resource_group" {
  name     = "resource_group"
  location = "westus2"
}

### Network


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet_1" {
  name                 = "subnet_1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "subnet_gateway" {

  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "public_ip_1" {
  name                = "virtual_network_gateway_public_ip_1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name


  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "public_ip_2" {
  name                = "virtual_network_gateway_public_ip_2"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  # Public IP needs to be dynamic for the Virtual Network Gateway
  allocation_method = "Dynamic"
}



### Virtual Machine
resource "azurerm_public_ip" "public_ip_vm" {
  name                = "public_ip_vm"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  allocation_method = "Static"
}

resource "azurerm_network_interface" "network_interface_vm" {
  name                = "network_interface_vm"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_vm.id
  }
}

data "template_file" "script" {
  template = "${file("${path.module}/scripts/backend_hashicups.yaml")}"
}

data "template_cloudinit_config" "backend" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.script.rendered
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  admin_password = "Plankton123!"

  network_interface_ids = [
    azurerm_network_interface.network_interface_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = data.template_cloudinit_config.backend.rendered

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  disable_password_authentication = false

}

### Outputs

output "azure_vm_public_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "azure_vm_private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}
