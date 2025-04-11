resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = "projetos-terraform-maik-biazi"

  versioning_configuration {
    status = "Enabled"
  }
}