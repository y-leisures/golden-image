variable "db_ami_prefix" {
  type    = string
  default = "bms-db"
}

build {
  name = "single-db"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing ansible packages",
      "until sudo apt-get update; do echo 'Retry' && sleep 6; done",
#      "until sudo apt-get install -y software-properties-common --no-install-recommends; do echo 'Retry' && sleep 6; done",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "until sudo apt-get install -y -qq ansible; do echo 'Retry' && sleep 6; done",
      "ansible-galaxy collection install community.general"
    ]
  }
  provisioner "ansible-local" {
    playbook_file = "./ansible/db-playbook.yaml"
    role_paths = [
      "ansible/roles/common",
      "ansible/roles/db",
      "ansible/roles/fluentd",
      "ansible/roles/db_backup",
    ]
  }

  post-processor "manifest" {
    output     = "db-manifest.json"
    strip_path = true
  }
}
