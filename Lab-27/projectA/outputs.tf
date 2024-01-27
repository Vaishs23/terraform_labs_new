output "vpc_id" {
  value = module.my_vpc_default.vpc_id
}

output "vpc_cidr" {
  value = module.my_vpc_default.vpc_cidr
}

output "public_subnet_ids" {
  value = module.my_vpc_default.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.my_vpc_default.private_subnet_ids
}



//we can only print outputs in this project that have been defined in the module section of terraform


output "vpc_id_staging" {
  value = module.my_vpc_staging.vpc_id
}

output "vpc_cidr_staging" {
  value = module.my_vpc_staging.vpc_cidr
}

output "public_subnet_ids_staging" {
  value = module.my_vpc_staging.public_subnet_ids
}

output "private_subnet_ids_staging" {
  value = module.my_vpc_staging.private_subnet_ids
}
