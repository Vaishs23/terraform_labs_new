provider "aws" {
  region = "eu-north-1"
}


// to provide a different branch with modules
//  source    = "git@github.com:mejaz4/terraform_labs_new.git//Lab-27/modules/aws_test?ref=yourbranchname"
module "vpc_prod" {
  # source               = "../modules/aws_network"
  source               = "git@github.com:mejaz4/terraform_labs_new.git//Lab-27/modules/aws_network"
  env                  = "prod"
  vpc_cidr             = "10.200.0.0/16"
  public_subnet_cidrs  = ["100.200.1.0/24", "100.200.2.0/24", "100.200.3.0/24"]
  private_subnet_cidrs = ["100.200.11.0/24", "100.200.22.0/24", "100.200.33.0/24"]
  tags = {
    Owner   = "MUSA.NET"
    code    = "992880"
    Project = "SuperSayian"
  }
}

module "server_standalone" {
  # source    = "../modules/aws_test"
  source = "git@github.com:mejaz4/terraform_labs_new.git//Lab-27/modules/aws_test"
  //this subnet id is taken from the output.tf file of the module
  subnet_id = module.vpc_prod.public_subnet_ids[2]
  name      = "ADV-IT"
  message   = "Stand Alone Server"
}

//create more servers with count method
module "servers_loop_count" {
  # source    = "../modules/aws_test"
  source    = "git@github.com:mejaz4/terraform_labs_new.git//Lab-27/modules/aws_test"
  count     = length(module.vpc_prod.public_subnet_ids)
  name      = "ADV-IT"
  message   = "Hello from server in subnet ${module.vpc_prod.public_subnet_ids[count.index]} created by count loop"
  subnet_id = module.vpc_prod.public_subnet_ids[count.index]
}

//create more servers with for each
module "servers_loop_foreach" {
  source     = "../modules/aws_test"
  for_each   = toset(module.vpc_prod.public_subnet_ids)
  name       = "ADV-IT"
  message    = "Hello from server in subnet ${each.value} created by foreach loop"
  subnet_id  = each.value
  depends_on = [module.servers_loop_count]
}
