
source "qemu" "ubuntu-2204-live-server" {

  iso_checksum = "file:http://cdimage.ubuntu.com/ubuntu-server/daily-live/pending/SHA256SUMS"
  iso_urls     = [
    "iso/jammy-live-server-amd64.iso",
    "http://cdimage.ubuntu.com/ubuntu-server/daily-live/pending/jammy-live-server-amd64.iso"
  ]
  
  headless               = true
  accelerator            = var.accelerator
  http_directory         = "http"
  output_directory       = "output"
  vm_name                = "ubuntu2204-${local.timestamp}.${var.format}"
  memory                 = var.memory
  disk_size              = var.disk_size
  format                 = var.format
  disk_interface         = "virtio"
  net_device             = "virtio-net"
  vnc_port_min           = 6000
  vnc_port_max           = 6000
  ssh_handshake_attempts = 500
  ssh_pty                = true
  ssh_timeout            = "30m"
  ssh_username           = "ubuntu"
  ssh_password           = var.ssh_password
  shutdown_command       = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  boot_wait              = "20s"
  boot_command           = ["<cOn><cOff>", "<wait5>linux /casper/vmlinuz"," quiet"," autoinstall"," ds='nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/'","<enter>","initrd /casper/initrd <enter>","boot <enter>"]

}

build {

  #name = "gold"

  sources = ["source.qemu.ubuntu-2204-live-server"]

  provisioner "shell" {
    inline = ["echo Inline Provisioner example -> ${build.name} :: ${build.ID}"]
  }

  post-processor "shell-local" {
    inline = ["echo Hello World from ${source.type}.${source.name}"]
  }

}
