# Input variable definitions

variable "prefix" {
  description = "A prefix of the resource name"
  type = string
  default = "jeongyong"
}

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "ap-northeast-2"
}


variable "apigw_stage" {
  type = string
  default = "$default"
}


variable "lambda_runtime" {
  type = string
  default = "python3.8"
}

variable "lambda_common_handler_name" {
  type = string
  default = "handler"
}

variable "lambda_layer" {

  type = map(string)
  default = {
    name = "serverless-python-layer"
    filename = "python-packages.zip"
  }
}


variable "lambdas" {
  type = map(string)
  default = {
    "cookbook" = "/cook",
    "helloworld" = "/hello",
    "user" = "/user"
  }
}