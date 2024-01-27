provider "aws" {
  region = "us-east-1"
}

#1. create vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#2. create internet gateway
resource "aws_internet_gateway" "my-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My Gateway"
  }
}

#3. create custom route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gateway.id
  }
  tags = {
    Name = "Prod Route Table"
  }
}
#4. create a subnet
resource "aws_subnet" "prod-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

#5. associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}

#6. create security group to allow 22, 80, 443
resource "aws_security_group" "prod-sg" {
  name        = "Prod Security group"
  description = "Allow traffic inbound and outbound"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["22", "80", "443"]
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
    Name = "allow traffic"
  }
}

#7. create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "prod_network_interface" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.prod-sg.id]
}

#8. assign an eip to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.prod_network_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.my-gateway]
}

#9. create Ubuntu server and install apache2

resource "aws_instance" "my-instance" {
  ami               = "ami-085925f297f89fce1"
  instance_type     = "t3.micro"
  availability_zone = "us-east-1a"
  key_name          = "musa-key-pair"

  network_interface {
    network_interface_id = aws_network_interface.prod_network_interface.id
    device_index         = 0
  }
  user_data = <<-EOF
    #!bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo bash -c 'echo your very first web server > /var/www/html/index.html'
    EOF
  tags = {
    Name = "Web-server"
  }
}