# Build WebServer during Bootstrap

provider "aws" {
  region = "ca-central-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "name" {
  ami                    = "ami-097300c6222ac2b2a"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Musa",
    l_name = "Ejaz",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
  })
  tags = {
    Name  = "Webserver built by Terraform"
    Owner = "Musa Ejaz"
  }
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"

  ingress {
    description = "Allow port HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Webserver SG by Terraform"
    Owner = "Musa Ejaz"
  }
}
