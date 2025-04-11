resource "aws_ecr_repository" "api" {
  name         = "${local.tag-name}"
  force_delete = var.force_delete_repo
}


resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

resource "terraform_data" "builder_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 484907529967.dkr.ecr.us-east-1.amazonaws.com
    EOT
  }
  provisioner "local-exec" {
    working_dir = var.app_folder_api
    command     = "docker build -t api-pessoas ."
  }
  provisioner "local-exec" {
    working_dir = var.app_folder_api
    command     = "docker tag api-pessoas:latest 484907529967.dkr.ecr.us-east-1.amazonaws.com/api-pessoas:latest"
  }
  provisioner "local-exec" {
    working_dir = var.app_folder_api
    command     = "docker push 484907529967.dkr.ecr.us-east-1.amazonaws.com/api-pessoas:latest"
  }


}