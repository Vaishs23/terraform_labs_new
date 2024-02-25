import {
  id = "sg-03ebd1d2c530ee3ad"
  to = aws_security_group.my_default_sg
}

//paste the id and write the "to" value to define where you want to create the resouece and do terraform plan
//terraform will automaically create the resource block for you
//also, note that the region needs to be set as well, it can't pull from a different region 

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/23"
  tags = {
    Name = "${aws_security_group.my_default_sg.name}"
  }
}

//after doing terraform plan and terraform plan -generate-config-out=generated.tf //also change the name generated.tf as you wish 
//do terraform apply to apply the import
