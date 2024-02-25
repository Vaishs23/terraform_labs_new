variable "iam_users" {
  description = "List of IAM users to create"
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

variable "create_bastian" {
  description = "Provision Bastian Server Yes/No"
  default     = "YES"
}
