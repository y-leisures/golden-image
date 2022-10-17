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
  default = "learn-packer-linux-aws-docker-local"
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
      "echo \"Installing fluentd (td-agent)\"",
      "curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-jammy-td-agent4.sh | sh"
    ]
  }
  
  provisioner "shell" {
    inline = [
      "echo Installing base-packages",
      "sudo apt-get update",
      "until sudo apt-get install -qq -y git vim zsh tree expect language-pack-ja debian-goodies; do echo 'Retry' && sleep 6; done",
      "sudo echo `date`' - packer provisioned this AMI' > /home/ubuntu/packer_provisioners"
    ]
  }  
  
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing Nginx, Redis and other ones",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -qq -y nginx redis-server awscli",
      "echo \"FOO is $FOO\" > example.txt",
      "until sudo apt-get install -qq -y build-essential; do echo 'Retry' && sleep 6; done",
      "sudo echo `date`' - packer provisioned this AMI' > /home/ubuntu/packer_provisioners"
    ]
  }

  provisioner "shell" {
    environment_vars = [
    ]
    inline = [
      "echo Installing docker",
      "sudo apt-get update && sudo apt-get install -qq -y ca-certificates curl gnupg lsb-release",
      "sudo mkdir -p /etc/apt/keyrings && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" > docker.list && sudo mv docker.list /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
      "sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose",
      "sudo echo `date`' - packer provisioned this AMI' > /home/ubuntu/packer_provisioners"
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
