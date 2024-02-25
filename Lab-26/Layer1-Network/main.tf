//tfstate backend shouldn't be saved on local - it can be deleted or lost easily. If a team needs to work on a project together, it's better to keep the backend remotely such as s3, etc.

provider "aws" {
  region = "eu-north-1"
}

data "aws_availability_zones" "available" {}

//need to create this bucket before this step
terraform {
  backend "s3" {
    bucket = "adv-it-terraform-remote-statee" //bucket where to save tfstate file or bucket - Name of the S3 Bucket
    key    = "dev/network/terraform.tfstate"  //Path to the state file inside the S3 Bucket
    region = "eu-north-1"                     //region where the bucket was created in
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name  = "${var.env}-vpc"
    Owner = "Musa Ejaz"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name  = "${var.env}-igw"
    Owner = "Musa Ejaz"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name  = "${var.env}-public-${count.index + 1}"
    Owner = "Musa Ejaz"
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name  = "${var.env}-route-public-subnets"
    Owner = "Musa Ejaz"
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

