provider "aws" {
  region = var.aws_region
}


locals {
  stage = var.apigw_stage

  runtime = var.lambda_runtime
  handler_name = var.lambda_common_handler_name
  lambdas = var.lambdas
  lambda_layer = var.lambda_layer

  module_path = abspath(path.module)
  parent_path = abspath("${local.module_path}/..")
  source_root_path = abspath("${local.parent_path}/src")
}
