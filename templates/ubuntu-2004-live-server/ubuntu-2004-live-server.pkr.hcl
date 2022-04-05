
source "qemu" "ubuntu-2004-live-server" {

  iso_checksum = "file:https://releases.ubuntu.com/20.04/SHA256SUMS"
  iso_urls = [
    "iso/ubuntu-20.04.4-live-server-amd64.iso",
    "https://releases.ubuntu.com/focal/ubuntu-20.04.4-live-server-amd64.iso"
  ]

  headless               = true
  accelerator            = var.accelerator
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
  shutdown_command       = "echo '${var.ssh_password}' | sudo -S poweroff"

  boot_wait              = "3s"
  boot_command           = ["<enter><enter><f6><esc><wait>", "<bs><bs><bs><bs>", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ", "--- <enter>"]

}

build {

  sources = ["source.qemu.ubuntu-2004-live-server"]

  # workaround for dealing with requirements that include roles and collections
  # See https://github.com/hashicorp/packer-plugin-ansible/issues/32

  provisioner "file" {
    source      = "ansible/requirements.yml"
    destination = "/tmp/"
  }

  # Runs on the VM being built. Ensure latest ansible
  # 2004 ships with a relatively old version of ansible that does not
  # support requirments.yml that include both roles and collections
  # hence calling ansible-galaxy twice, one for installing roles one for collections
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-galaxy role install -r /tmp/requirements.yml",
      "ansible-galaxy collection install -r /tmp/requirements.yml"
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
