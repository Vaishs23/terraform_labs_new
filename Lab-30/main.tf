//if you have pre existing resources on your account that you would like to define using terrafornm, write an empty resource block and then do terraform import <resource name> <some sort of id check docs>

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "node1" {
  ami           = "ami-0780837dd83465d73"
  instance_type = "t2.micro"
  //we can also add the vpc_security_group key here now that we have the resource
  vpc_security_group_ids = [aws_security_group.name.id]
  tags = {
    Name = "my web server"
  }
}

resource "aws_security_group" "name" {
  description            = "default VPC security group"
  revoke_rules_on_delete = false
  ingress {
    cidr_blocks      = []
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = true
    to_port          = 0
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }
  tags = {}
  //you can add stuff in tags now and the security group will get updated when you do terraform apply
}

//so first just write the resource block with anything, then do terraform import aws_instance.node1 <id of the instance in your region>
//then do terraform plan and keep matching the configuration manually until terraform says No changes

