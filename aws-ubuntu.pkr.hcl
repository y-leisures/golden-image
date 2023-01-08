packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "bms-web"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "ap-northeast-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing ansible packages",
      "sudo apt-get update",
      "sudo apt install software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "until sudo apt-get install -y -qq ansible; do echo 'Retry' && sleep 6; done",
      "ansible-galaxy collection install community.general"
    ]
  }
  provisioner "ansible-local" {
    playbook_file = "./ansible/playbook.yaml"
    # extra_arguments = ["--extra-vars"]
    role_paths = [
      "ansible/roles/common",
      "ansible/roles/web",
      "ansible/roles/fluentd",
      "ansible/roles/db_backup",
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
    #    custom_data = {
    #      my_custom_data = "example"
    #    }
  }
}
