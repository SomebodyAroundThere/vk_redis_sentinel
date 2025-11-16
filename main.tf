# Блок создания группы безопасности
resource "vkcs_networking_secgroup" "secgroup_test" {
  name        = "Sokolova_secgroup"
  description = "My security group"
}
# Блок создания правила для группы безопасности
resource "vkcs_networking_secgroup_rule" "secgroup_rule_test" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${vkcs_networking_secgroup.secgroup_test.id}"
}

resource "vkcs_compute_keypair" "ssh1" {
  # Название SSH-ключа. Ключ будет отображаться в настройках аккаунта на вкладке *Ключевые пары*
  name = "terraform_ssh_key1"
  # Путь до открытого ключа
  public_key = file("${path.module}/id_rsa1.pub")

}
resource "vkcs_compute_keypair" "ssh2" {
  # Название SSH-ключа. Ключ будет отображаться в настройках аккаунта на вкладке *Ключевые пары*
  name = "terraform_ssh_key2"
  # Путь до открытого ключа
  public_key = file("${path.module}/id_rsa2.pub")

}
resource "vkcs_compute_keypair" "ssh3" {
  # Название SSH-ключа. Ключ будет отображаться в настройках аккаунта на вкладке *Ключевые пары*
  name = "terraform_ssh_key3"
  # Путь до открытого ключа
  public_key = file("${path.module}/id_rsa3.pub")

}


data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

data "vkcs_images_image" "compute" {
  visibility = "public"
  default    = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "22.04"
  }
}

resource "vkcs_compute_instance" "compute1" {
  name                    = "Ubuntu-Sokolova-MS1"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = "${vkcs_compute_keypair.ssh1.name}"
  security_group_ids      = [vkcs_networking_secgroup.secgroup_test.id]
  availability_zone       = "MS1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }
  network {
    uuid = vkcs_networking_network.network_redis.id
  }

  depends_on = [
    vkcs_networking_network.network_redis,
    vkcs_networking_subnet.subnet_redis
  ]

}

resource "vkcs_compute_instance" "compute2" {
  name                    = "Ubuntu-Sokolova-GZ1"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = "${vkcs_compute_keypair.ssh2.name}"
  security_group_ids      = [vkcs_networking_secgroup.secgroup_test.id]
  availability_zone       = "GZ1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.network_redis.id
  }

  depends_on = [
    vkcs_networking_network.network_redis,
    vkcs_networking_subnet.subnet_redis
  ]

}

resource "vkcs_compute_instance" "compute3" {
  name                    = "Ubuntu-Sokolova-ME1"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = "${vkcs_compute_keypair.ssh3.name}"
  security_group_ids      = [vkcs_networking_secgroup.secgroup_test.id]
  availability_zone       = "ME1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.network_redis.id
  }

  depends_on = [
    vkcs_networking_network.network_redis,
    vkcs_networking_subnet.subnet_redis
  ]

}

resource "vkcs_networking_floatingip" "fip1" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_networking_floatingip" "fip2" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_networking_floatingip" "fip3" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip1" {
  floating_ip = vkcs_networking_floatingip.fip1.address
  instance_id = vkcs_compute_instance.compute1.id
}

output "instance_fip1" {
  value = vkcs_networking_floatingip.fip1.address
}
resource "vkcs_compute_floatingip_associate" "fip2" {
  floating_ip = vkcs_networking_floatingip.fip2.address
  instance_id = vkcs_compute_instance.compute2.id
}

output "instance_fip2" {
  value = vkcs_networking_floatingip.fip2.address
}
resource "vkcs_compute_floatingip_associate" "fip3" {
  floating_ip = vkcs_networking_floatingip.fip3.address
  instance_id = vkcs_compute_instance.compute3.id
}

output "instance_fip3" {
  value = vkcs_networking_floatingip.fip3.address
}

