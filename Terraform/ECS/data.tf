data "aws_caller_identity" "current" {}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "projetos-terraform-maik-biazi"
    key    = "api-pessoas/network/vpc.tfstate"
    region = "us-east-1"
  }
}