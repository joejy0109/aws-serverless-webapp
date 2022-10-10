locals {
  prefix = var.prefix

  stage = var.apigw_stage

  runtime = var.lambda_runtime
  handler_name = var.lambda_common_handler_name
  lambdas = var.lambdas
  lambda_layer = var.lambda_layer

  module_path = abspath(path.module)
  parent_path = abspath("${local.module_path}/..")
  source_root_path = abspath("${local.parent_path}/src")
  packages_root_path = abspath("${local.parent_path}/.packages")
  archive_output_path = abspath("${local.parent_path}/.output")
}

resource "random_string" "suffix" {
  length           = 8
  lower            = true
  upper            = false
  special          = false
  override_special = "/@£$"
}