terraform {
  backend "s3" {
    bucket = "projetos-terraform-maik-biazi"
    key    = "api-pessoas/ECR/ecr.tfstate"
    region = "us-east-1"
  }
}