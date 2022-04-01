
source "qemu" "ubuntu-2004-live-server" {

  iso_checksum = "file:https://releases.ubuntu.com/20.04/SHA256SUMS"
  iso_urls     = [
    "iso/ubuntu-20.04.4-live-server-amd64.iso",
    "https://releases.ubuntu.com/focal/ubuntu-20.04.4-live-server-amd64.iso"
  ]

  headless               = true
  accelerator            = "kvm"
  http_directory         = "http"
  output_directory       = "output"
  vm_name                = "ubuntu2004-${local.timestamp}.${var.format}"
  memory                 = var.memory
  disk_size              = var.disk_size
  format                 = var.format
  disk_interface         = "virtio"
  net_device             = "virtio-net"
  vnc_port_min           = 5900
  vnc_port_max           = 5900
  ssh_handshake_attempts = 500
  ssh_pty                = true
  ssh_timeout            = "30m"
  ssh_username           = "ubuntu"
  ssh_password           = var.ssh_password
  shutdown_command       = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  boot_wait              = "3s"
  boot_command           = ["<enter><enter><f6><esc><wait>","<bs><bs><bs><bs>","autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ","--- <enter>"]

}

build {

  #name = "gold"

  sources = ["source.qemu.ubuntu-2004-live-server"]

  provisioner "shell" {
    inline = ["echo Inline Provisioner example -> ${build.name} :: ${build.ID}"]
  }

  post-processor "shell-local" {
    inline = ["echo Hello World from ${source.type}.${source.name}"]
  }

}
