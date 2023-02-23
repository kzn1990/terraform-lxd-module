resource "lxd_container" "vm" {

  name      = var.hostname
  image     = var.image
  profiles  = var.profiles
  wait_for_network = false
  remote    = var.target
  start_container = var.start_container

  limits = {
    cpu = var.cpu != "" ? var.cpu : null
    "cpu.allowance" = var.cpu_allowance != "" ? var.cpu_allowance : null
    memory = var.memory != "" ? var.memory : null
  }

  config = {
    "raw.lxc" = var.raw != "" ? var.raw : null
    "security.privileged" = "${var.privileged}"
    "user.access_interface" = "eth0"
    "security.nesting" = var.nesting != "" ? var.nesting : null
  }

  dynamic "device" {
    for_each = length(var.eth) > 0 ? var.eth : {}
    content {
      type = "nic"
      name = device.key
      properties = {
        nictype = "bridged"
        parent = device.value.parent
        hwaddr = device.value.mac
      }
    }
  }

  dynamic "device" {
    for_each =  length(var.disk) > 0 ? var.disk : {}
    content {
      type = "disk"
      name = device.key
      properties = {
        path = device.value.path
        source = device.value.source
      }
    }
  }

  file {
    content = "# The loopback network interface\nauto lo\niface lo inet loopback\n\nsource /etc/network/interfaces.d/*\n"
    target_file = "/etc/network/interfaces"
  }

  dynamic "file" {
    for_each = length(var.eth) > 0 ? var.eth : {}
    content {
      content = templatefile("${path.module}/templates/interfaces.tpl", {
        IP_ADDRESS = coalesce(file.value.ip, "null"),
        GW_ADDRESS = coalesce(file.value.gw, "null"), 
        NIC = file.key
      })
      target_file = "/etc/network/interfaces.d/${file.key}"
    }
  }

  lifecycle {
    ignore_changes = [
      file,
    ]
  }
}
