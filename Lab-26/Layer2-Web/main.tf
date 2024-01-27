provider "aws" {
  region = "eu-north-1"
}


//use this terraform {} to store a state remotely
terraform {
  backend "s3" {
    bucket = "adv-it-terraform-remote-statee" //bucket where to save tfstate file
    key    = "dev/webserver/terraform.tfstate"  //object name in the bucket to save the terraform state
    region = "eu-north-1"                     //region where the bucket was created in
  }
}
//create more terraform blocks like this if you have more layers and need to references resources in different layers



//use data terraform_remote_state like this to get a state stored remotely
//this way can use Outputs from Remote State
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "adv-it-terraform-remote-statee" //bucket where to GET tfstate file
    key    = "dev/network/terraform.tfstate"  //object name in the bucket to GET the terraform state
    region = "eu-north-1"                     //region where the bucket was created in
  }
}




data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "web_server" {
  vpc_security_group_ids = [aws_security_group.webserver.id]
  instance_type          = "t3.micro"
  ami                    = data.aws_ami.latest_amazon_linux.id
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  user_data              = <<-EOF
#!/bin/bash
yum -y update
yum -y install httpd

myip = `curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by the Power of terraform with<font color="red">Remote State</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br?
</body>
</html>
service httpd start
chkconfig httpd on
EOF
  tags = {
    Name  = "${var.env}-WebServer"
    Owner = "Musa Ejaz"
  }
}

resource "aws_security_group" "webserver" {
  name   = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    //port 80 is open to the world due to ::0 cidr block
    cidr_blocks = ["0.0.0.0/0"]
  }
  //port 22 is ssh port so we need to limit cidr block
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.env}-web-server-sg"
    Owner = "Musa Ejaz"
  }
}