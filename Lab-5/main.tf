# Build WebServer during Bootstrap

provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"

dynamic "ingress" {
    for_each = ["80", "8080", "443", "1000", "8443"]
    content {
    description = "Allow port HTTP"
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

  ingress {
    description = "Allow port SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/16"]
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
