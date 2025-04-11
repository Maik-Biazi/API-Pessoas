terraform {
  backend "s3" {
    bucket = "projetos-terraform-maik-biazi"
    key    = "api-pessoas/network/vpc.tfstate"
    region = "us-east-1"
  }
}