data "vkcs_networking_network" "extnet" {
  name = "internet"
}

resource "vkcs_networking_network" "network_redis" {
  name           = "Sokolova-redis-net"
  admin_state_up = true
}

resource "vkcs_networking_subnet" "subnet_redis" {
  name            = "Sokolova-redis-subnet"
  network_id      = vkcs_networking_network.network_redis.id
  cidr            = "192.168.200.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "vkcs_networking_router" "router_redis" {
  name                = "Sokolova-redis-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "int_redis" {
  router_id = vkcs_networking_router.router_redis.id
  subnet_id = vkcs_networking_subnet.subnet_redis.id
}
