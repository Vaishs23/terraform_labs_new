provider "aws" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "working" {}

data "aws_vpcs" "vpcs" {}

resource "aws_vpc" "prod" {}

data "aws_vpc" "prod" {}

resource "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Subnet-1"
    Info = "AZ: ${data.aws_availability_zones.working.names[0]} in Region: ${data.aws_region.current.description}"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Subnet-2"
    Info = "AZ: ${data.aws_availability_zones.working.names[1]} in Region: ${data.aws_region.current.description}"
  }
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

# output "aws_vpcs" {
#   value = data.aws_vpcs.vpc

# }

output "all_vpcs_ids" {
  value = data.aws_vpcs.vpcs.ids

}
