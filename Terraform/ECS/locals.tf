locals {
  tag-name   = "api"
  account_id = data.aws_caller_identity.current.account_id


  vpc     = data.terraform_remote_state.vpc.outputs.vpc
  subnets = data.terraform_remote_state.vpc.outputs.subnets
}