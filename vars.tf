variable "hostname" {
  type = string
}

variable "target" {
  type = string
}

variable "image" {
  type = string
  default = "images:debian/10"
}

variable "profiles" {
  type = list(string)
  default = ["default"]
}

variable "raw" {
  type = string
  default = ""
}

variable "privileged" {
  default = "false"
}

variable "memory" {
  type = string
  default = ""
}

variable "cpu" {
  type = string
  default = ""
}

variable "cpu_allowance" {
  type = string
  default = ""
}

variable "start_container" {
  default = true
}

variable "nesting" {
  type = string
  default = ""
}

variable "disk" {
  type = map(object({
    path = string
    source = string
  }))
  default = {}
}

variable "eth" {
  type = map(object({
    parent = string
    mac = optional(string)
    ip = optional(string)
    gw = optional(string)
  }))
}
