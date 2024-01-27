provider "aws" {
  region = "us-west-2"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    interpreter = ["python3", "-c"]
    command     = "print('Hello world using Pythom from Terraform') >> log.txt"
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $Name1 $Name2 $Name3 >> names.txt"
    environment = {
      Name1 = "John"
      Name2 = "Mark"
      Name3 = "Donald"
    }
  }
}

resource "aws_instance" "myserver" {
  ami           = "ami-0c65adc9a5c1b5d7c"
  instance_type = "t3.nano"
  provisioner "local-exec" {
    command = "echo ${aws_instance.myserver.private_ip} >> log.txt"
  }
}

resource "null_resource" "command5" {
  provisioner "local-exec" {
    command = "echo Terraform FINISH: $(date) >> log.txt"
  }
  depends_on = [
    null_resource.command1,
    null_resource.command2,
    null_resource.command3,
    null_resource.command4,
  aws_instance.myserver]
}
