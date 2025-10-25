# packer/jeos.pkr.hcl
variable "iso_url"      { type = string, default = "https://cdimage.debian.org/debian-12.6.0-amd64-netinst.iso" }
variable "iso_checksum" { type = string, default = "sha256:REPLACE_WITH_REAL_SHA256" }
variable "ssh_user"     { type = string, default = "packer" }
variable "ssh_pass"     { type = string, default = "packer" }

source "qemu" "jeos" {
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum
  output_directory = "out/qemu"
  headless     = true
  ssh_username = var.ssh_user
  ssh_password = var.ssh_pass
  disk_size    = 20480
  http_directory = "packer/http"
  boot_wait    = "5s"
  boot_command = ["<esc><wait>auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
}

build {
  sources = ["source.qemu.jeos"]
  provisioner "ansible" { playbook_file = "ansible/jeos.yml" }
  post-processor "manifest" { output = "out/manifest.json" }
  post-processor "ovf" { output = "out/backup-jeos.ova" }
  post-processor "shell-local" { inline = ["bash tools/mkiso.sh out/backup-jeos.iso"] }
}
