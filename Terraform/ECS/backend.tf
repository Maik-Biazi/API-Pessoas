terraform {
  backend "s3" {
    bucket = "projetos-terraform-maik-biazi"
    key    = "api-pessoas/ECS/ecs.tfstate"
    region = "us-east-1"
  }
}