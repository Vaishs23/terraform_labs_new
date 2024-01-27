// set a provider, create a default vpc, create an elastic ip address, create an ec2 and link with eip, create security group,


provider "aws" {
  region = "us-west-2"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_eip" "web" {
  domain   = "vpc" # Need to be added in new versions of AWS Provider
  instance = aws_instance.web.id
  tags = {
    Name  = "EIP for WebServer Built by Terraform"
    Owner = "Musa Ejaz"
  }
}

//user_data_replace_on_change: will trigger a destroy and recreate when set to true
//create_before_destroy (bool): By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments. The create_before_destroy meta-argument changes this behavior so that the new replacement object is created first, and the prior object is destroyed after the replacement is created.
resource "aws_instance" "web" {
  ami                         = "ami-07a0da1997b55b23e" // Amazon Linux2
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data                   = file("user_data.sh") // Static File
  user_data_replace_on_change = true                 # Added in the new AWS provider!!!
  tags = {
    Name  = "WebServer Built by Terraform"
    Owner = "Musa Ejaz"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

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
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer SG by Terraform"
    Owner = "Musa Ejaz"
  }
}
