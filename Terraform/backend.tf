terraform {
  backend "s3" {
    bucket = "projetos-terraform-maik-biazi"
    key    = "api-pessoas/terraform.tfstate"
    region = "us-east-1"
  }
}