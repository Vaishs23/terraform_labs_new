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
    "josef.net",
    "John",
    "Robert",
    "paul",
    "victor",
    "dany"
  ]
}
