provider "aws" {
  region = "ca-central-1"
}

locals {
  Owner_name = "Musa Ejaz"
}

data "aws_ami" "myserver" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}
resource "aws_instance" "myserver" {
  ami                    = data.aws_ami.myserver.id
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "musa-key-ca-central-1"
  tags = {
    Name  = "My EC2 with remote exec"
    Owner = local.Owner_name
  }
  provisioner "remote-exec" {
    inline = [ 
        "mkdir /home/ec2-user/terraform",
        "cd /home/ec2-user/terraform",
        "touch hello.txt",
        "echo 'Terraform was here...' > terraform.txt"
     ]
     connection {
       type = "ssh"
       user = "ec2-user"
       host = self.public_ip //same as -> aws_instance.myserver.public_ip
       private_key = file("musa-key-ca-central-1.pem")
     }
  }
}

resource "aws_security_group" "web" {
  name = "My-SeucrtyGroup"
  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "SG by Terraform"
    Owner = local.Owner_name
  }
}


//after doing terraforn apply, do ssh into the ec2 instance
// type in terminal:
// ssh -i musa-key-ca-central-1.pem ec2-user@<input IP address here>