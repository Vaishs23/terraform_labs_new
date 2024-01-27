provider "aws" {
  region = "ca-central-1"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

data "aws_availability_zones" "working" {}

resource "aws_security_group" "web" {
  name = "Web Security Group"
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Web Security Group"
    Owner = "Musa Ejaz"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "WebServer-Highly-Available-LC"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")
}
