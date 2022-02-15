
# resource "azurerm_local_network_gateway" "local_network_gateway_1_tunnel1" {
#   name                = "local_network_gateway_1_tunnel1"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   gateway_address = aws_vpn_connection.vpn_connection_1.tunnel1_address

#   address_space = [
#     aws_vpc.vpc.cidr_block
#   ]
# }

# resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_1_tunnel1" {
#   name                = "virtual_network_gateway_connection_1_tunnel1"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   type                       = "IPsec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway.id
#   local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_1_tunnel1.id

#   shared_key = aws_vpn_connection.vpn_connection_1.tunnel1_preshared_key
# }

# resource "azurerm_local_network_gateway" "local_network_gateway_1_tunnel2" {
#   name                = "local_network_gateway_1_tunnel2"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   gateway_address = aws_vpn_connection.vpn_connection_1.tunnel2_address

#   address_space = [
#     aws_vpc.vpc.cidr_block
#   ]
# }

# resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_1_tunnel2" {
#   name                = "virtual_network_gateway_connection_1_tunnel2"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   type                       = "IPsec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway.id
#   local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_1_tunnel2.id

#   shared_key = aws_vpn_connection.vpn_connection_1.tunnel2_preshared_key
# }

# resource "azurerm_local_network_gateway" "local_network_gateway_2_tunnel1" {
#   name                = "local_network_gateway_2_tunnel1"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   gateway_address = aws_vpn_connection.vpn_connection_2.tunnel1_address

#   address_space = [
#     aws_vpc.vpc.cidr_block
#   ]
# }

# resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_2_tunnel1" {
#   name                = "virtual_network_gateway_connection_2_tunnel1"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   type                       = "IPsec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway.id
#   local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_2_tunnel1.id

#   shared_key = aws_vpn_connection.vpn_connection_2.tunnel1_preshared_key
# }

# resource "azurerm_local_network_gateway" "local_network_gateway_2_tunnel2" {
#   name                = "local_network_gateway_2_tunnel2"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   gateway_address = aws_vpn_connection.vpn_connection_2.tunnel2_address

#   address_space = [
#     aws_vpc.vpc.cidr_block
#   ]
# }

# resource "azurerm_virtual_network_gateway_connection" "virtual_network_gateway_connection_2_tunnel2" {
#   name                = "virtual_network_gateway_connection_2_tunnel2"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   type                       = "IPsec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway.id
#   local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_2_tunnel2.id

#   shared_key = aws_vpn_connection.vpn_connection_2.tunnel2_preshared_key
# }

# resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
#   name                = "virtual_network_gateway"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   type     = "Vpn"
#   vpn_type = "RouteBased"

#   active_active = true
#   sku = "VpnGw1"

#   ip_configuration {
#     name                          = azurerm_public_ip.public_ip_1.name
#     public_ip_address_id          = azurerm_public_ip.public_ip_1.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.subnet_gateway.id
#   }

#   ip_configuration {
#     name                          = azurerm_public_ip.public_ip_2.name
#     public_ip_address_id          = azurerm_public_ip.public_ip_2.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.subnet_gateway.id
#   }
# }

# resource "aws_vpn_gateway" "vpn_gateway" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "vpn_gateway"
#   }
# }

# resource "aws_vpn_connection" "vpn_connection_1" {
#   vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
#   customer_gateway_id = aws_customer_gateway.customer_gateway_1.id
#   type                = "ipsec.1"
#   static_routes_only  = true

#   tags = {
#     Name = "vpn_connection_1"
#   }
# }

# resource "aws_vpn_connection" "vpn_connection_2" {
#   vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
#   customer_gateway_id = aws_customer_gateway.customer_gateway_2.id
#   type                = "ipsec.1"
#   static_routes_only  = true

#   tags = {
#     Name = "vpn_connection_2"
#   }
# }

# resource "aws_vpn_connection_route" "vpn_connection_route_1" {
#   destination_cidr_block = azurerm_virtual_network.vnet.address_space[0]
#   vpn_connection_id      = aws_vpn_connection.vpn_connection_1.id
# }

# resource "aws_vpn_connection_route" "vpn_connection_route_2" {
#   destination_cidr_block = azurerm_virtual_network.vnet.address_space[0]
#   vpn_connection_id      = aws_vpn_connection.vpn_connection_2.id
# }

# resource "aws_route" "route_to_azure" {
#   route_table_id = aws_route_table.route_table.id

#   destination_cidr_block = azurerm_virtual_network.vnet.address_space[0]
#   gateway_id             = aws_vpn_gateway.vpn_gateway.id
# }

# data "azurerm_public_ip" "azure_public_ip_1" {
#   name                = "${azurerm_virtual_network_gateway.virtual_network_gateway.name}_public_ip_1"
#   resource_group_name = azurerm_resource_group.resource_group.name
# }

# data "azurerm_public_ip" "azure_public_ip_2" {
#   name                = "${azurerm_virtual_network_gateway.virtual_network_gateway.name}_public_ip_2"
#   resource_group_name = azurerm_resource_group.resource_group.name
# }

# resource "aws_customer_gateway" "customer_gateway_1" {
#   bgp_asn = 65000

#   ip_address = data.azurerm_public_ip.azure_public_ip_1.ip_address
#   type       = "ipsec.1"

#   tags = {
#     Name = "customer_gateway_1"
#   }
# }

# resource "aws_customer_gateway" "customer_gateway_2" {
#   bgp_asn = 65000

#   ip_address = data.azurerm_public_ip.azure_public_ip_2.ip_address
#   type       = "ipsec.1"

#   tags = {
#     Name = "customer_gateway_2"
#   }
# }