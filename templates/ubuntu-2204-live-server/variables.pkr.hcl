
variable "memory" {
  type        = number
  default     = 1024
  description = "Memory in mb to allocate to the resulting build"
}

variable "disk_size" {
  type        = string
  default     = "10G"
  description = "Disk size in mb to allocate to the resulting build"
}

variable "ssh_password" {
  sensitive   = true
  type        = string
  default     = "ubuntu"
  description = "SSH Password to use for connecting to the build"
}

variable "format" {
  type        = string
  default     = "qcow2"
  description = "Disk image format. Qemu supports 'qcow2' or 'raw'"
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
