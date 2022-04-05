
source "qemu" "ubuntu-2204-live-server" {

  iso_checksum = "file:http://cdimage.ubuntu.com/ubuntu-server/daily-live/pending/SHA256SUMS"
  iso_urls = [
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
  shutdown_command       = "echo '${var.ssh_password}' | sudo -S poweroff"

  boot_wait              = "20s"
  boot_command           = ["<cOn><cOff>", "<wait5>linux /casper/vmlinuz", " quiet", " autoinstall", " ds='nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/'", "<enter>", "initrd /casper/initrd <enter>", "boot <enter>"]

}

build {

  sources = ["source.qemu.ubuntu-2204-live-server"]

  # workaround for dealing with requirements that include roles and collections
  # See https://github.com/hashicorp/packer-plugin-ansible/issues/32

  provisioner "file" {
    source      = "ansible/requirements.yml"
    destination = "/tmp/"
  }

  # Runs on the VM being built.
  # 2204 ships with a modern enough version of ansible
  # that knows how to handle requirements.yml with both roles and collections
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-galaxy install -r /tmp/requirements.yml",
    ]
  }

  # Runs on the VM being built
  provisioner "ansible-local" {
    playbook_dir    = "ansible"
    command         = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file   = "ansible/playbook.yml"
    extra_arguments = ["-vvv"]
    # galaxy_command          = "ansible-galaxy"
    # galaxy_file             = "ansible/requirements.yml"
    clean_staging_directory = true
  }

  # Runs on the VM being built
  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }
  
  # Runs on the Packer host
  post-processor "shell-local" {
    inline = ["echo Build ${source.type}.${source.name} finished!"]
  }

}
