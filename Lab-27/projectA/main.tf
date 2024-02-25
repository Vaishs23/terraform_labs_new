provider "aws" {
  region = "us-west-1"
}

//if you just call the module like this, it will use default values
module "my_vpc_default" {
  source = "../modules/aws_network"
}


//or you can pass values for different variables inside module block
module "my_vpc_staging" {
  source               = "../modules/aws_network"
  env                  = "stagging"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}