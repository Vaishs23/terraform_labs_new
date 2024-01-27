# creating resources in multiple AWS accounts and regions

//this is the main account and it will allow to assume roles in the other accounts. Make sure roles are created in the other AWS accounts
//trust relationship needs to be developed between this account and the other accounts
provider "aws" {
  region = "ca-central-1"
}


# creating provider with the roles

//this is the dev account
provider "aws" {
  region = "us-west-2"
  alias  = "DEV"

  assume_role {
    role_arn = "arn:aws:iam::831321341211:role/terraformRole"

    //arn of the role will go here
  }
}

provider "aws" {
  region = "ca-centra-1"
  alias  = "PROD"

  assume_role {
    role_arn = "arn:aws:iam::01390129301:role/terraformRole"

    //arn of the role will go here
  }
}

//creating vpcs for all accounts
resource "aws_vpc" "master_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Master VPC"
  }
}

resource "aws_vpc" "dev_vpc" {
  provider   = aws.DEV
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Dev VPC"
  }
}

resource "aws_vpc" "prod_vpc" {
  provider   = aws.PROD
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Dev VPC"
  }
}