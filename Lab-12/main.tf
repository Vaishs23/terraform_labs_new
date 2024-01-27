provider "aws" {
  region = "ca-central-1"
}

# resource "aws_instance" "myserver" {
#     ami = ""
#     instance_type = "t3.micro"
# }

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazonglinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

data "aws_ami" "latest_windowsserver2019" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_amazonglinux_ami_id" {
  value = data.aws_ami.latest_amazonglinux.id
}

output "latest_windowsserver2019_ami_id" {
  value = data.aws_ami.latest_amazonglinux.id
}
