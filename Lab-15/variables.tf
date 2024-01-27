variable "aws_region" {
  description = "Region to provision the ec2"
  type = string
  default = "ca-central-1"
}

variable "instance_size" {
  description = "ec2 instance size to provision"
  type = string
  default = "t3.micro"
}

variable "port_list" {
  description = "List of ports to open for our webserver"
  type = list(any) //can also be list(string) or number
  default = [ "80", "443" ]
}

variable "tags" {
    description = "tags to apply to resources"
    type = map(any)
    default = {
      Owner = "Musa Ejaz"
      Environment = "Prod"
      Project = "Phoenix"
    }
  
}

variable "password_for_something" {
  description = "Password for rds"
  type = string
  sensitive = true
  validation {
    condition = length(var.password_for_something) == 10
    error_message = "Password must be 10 characs"
  }
}


//to input a value which is not default do terraform apply -var="password_for_something=1234567890" -var="port_list=["433", "400"]".. you can add more -var

//or another way to store env variables
# export TF_VAR_password_for_something=1234567812
# export TF_VAR_port_list=["10", "20"]
// terraform apply will use the env variables in this case
// print env variables in terminal by typing env
//or env | grep TF_VAR to print out variables with TF_VAR name


//another method is to create a terraform.tfvars file 


//we have two variable files vars_production.tfvars and vars_staging.tfvars, so to terraform apply write the below command:
//terraform apply -var-file="<name of file>" such as terraform apply -var-file="vars_staging.tfvars"

//https://developer.hashicorp.com/terraform/language/values/variables