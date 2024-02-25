provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-0c65adc9a5c1b5d7c"
  instance_type = "t3.micro"
  # key_name      = "Musa-key2-Mac"

  tags = {
    Name    = "My-New-Ubuntu-Server"
    Owner   = "Musa Ejaz"
    project = "Phoenix"
  }
}

//if a default vpc does not exist, then terraform will create a default vpc, but won't delete it upon terraform destroy
resource "aws_default_vpc" "default" {}

resource "aws_instance" "my_amazon" {
  ami           = "ami-0f3769c8d8429942f"
  instance_type = "t3.micro"

  tags = {
    Name   = "My-Amazon-Server"
    Owner  = var.owner_name
    vpc_id = aws_default_vpc.default.id
  }
}
