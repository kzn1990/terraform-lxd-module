# LXD module

Module for managing LXD servers with a static IP address.

## Module parameters

List of all parameters accepted by the module.

### Schema

  1. Required:
     * `hostname` (string) hostname of the deployed machine,
     * `target` (string) target server of the deployed machine,
     * `eth` (map) map of network interfaces (at least one required).
  2. Optional:
     * `profiles` (list) default profile `["inside"]`,
     * `cpu` (int) default `null`,
     * `cpu_allowance` default `null`,
     * `memory` (string) default `null`,
     * `disk` (map) default `null`,
     * `raw` (string) lxc.raw configuration default `null`,
     * `privileged` (string) default `false`,
     * `nesting` (bool) default `null`,
     * `raw` (string) default `null`,
     * `image` (string) default `images:debian/10`.

### Nested Schema `eth`

  1. Required:
     * `parent` (string) parent bridge to which the interface will be attached,
  2. Optional:
     * `ip` (string) IP address of the network interface along with the subnet mask,
     * `gw` (string) gateway for the network address,
     * `mac` (string) MAC address to overwrite the network interface.

### Nested Schema `disk`

  1. Required:
     * `path` (sting) absolute path to mount directory in the virtual machine,
     * `source` (string) absolute path to the folder on the host.

## Example usage

### Minimal module invocation

```terraform
module "test-vm" {
  source = "../modules/lxd/"
  hostname = "test-vm"
  target = "example.local"
  eth = {
    "eth0" = { parent = "br1" }
  }
}
```
### Full module invocation

```terraform
module "test-vm" {
  source = "../modules/lxd/"
  hostname = "test-container"
  profiles = ["default", "k8s"]
  target = "example.local"
  cpu = "2"
  cpu_allowance = "10%"
  memory = "4GB"
  eth = {
    "eth0" = { parent = "br1", ip = "192.168.7.14/24", gw = "192.168.7.254" },
    "eth1" = { parent = "br0", mac = "00:11:22:33:44:55", ip = "1.2.3.4/24" }
  }
  disk = {
    "tools" = { path = "/cm-tools", source = "/opt/cm-tools/" },
    "nfs" = { path = "/nfs", source = "/mnt/nfs-cm-corona24" }
  }
}
```
