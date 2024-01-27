# > toset(["a", "b", "c"])
# [
#   "a",
#   "b",
#   "c",
# ]

variable "aws_users" {
  description = "List of IAM Users"
  default = [
    "musaejaz.net",
    "joshua.net",
    "kevin.net",
    "jessy.net",
    "robby.net",
    "katie.net",
    "laura.net",
    "josef.net"
  ]
}

variable "server_settings" {
  default = {
    web = {
      ami           = "ami-0e472933a1395e172"
      instance_size = "t3.small"
      root_disksize = 20
      encrypted     = true
    }
    app = {
      ami           = "ami-07dd19a7900a1f049"
      instance_size = "t3.micro"
      root_disksize = 10
      encrypted     = false
    }
  }
}

variable "create_bastian" {
  default = "YES"
}

