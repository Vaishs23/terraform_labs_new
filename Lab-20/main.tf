provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "servers" {
  //use count to create more servers using the same code
  count         = 4
  ami           = "ami-0e472933a1395e172"
  instance_type = "t3.micro"
  tags = {
    Name = "Server ${count.index + 1}"
  }
}

resource "aws_iam_user" "user" {
  count = length(var.iam_users)
  name  = element(var.iam_users, count.index)
}

//this way of creating users isn't ideal as it will change the users if you delete one user from the list of iam users

resource "aws_instance" "bastian_server" {
  count         = var.create_bastian == "YES" ? 1 : 0
  ami           = "ami-0e472933a1395e172"
  instance_type = "t3.micro"
  tags = {
    Name  = "Bastion Server"
    Owner = "Musa Ejaz"
  }
}