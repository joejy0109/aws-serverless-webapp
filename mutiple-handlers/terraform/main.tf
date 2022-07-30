provider "aws" {
  region = var.aws_region
}


locals {
  runtime = "python3.8"
  common_handler_name = "handler"

  module_path = abspath(path.module)
  parent_path = abspath("${local.module_path}/..")
  source_root_path = abspath("${local.parent_path}/src")
}
