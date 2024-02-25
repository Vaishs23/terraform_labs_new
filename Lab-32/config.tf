terraform {
  backend "s3" {
    bucket = "my---buckeeettt"
    key    = "prod/terraform.tfstate"
    region = "eu-west-2"
  }
}
