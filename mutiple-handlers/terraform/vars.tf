# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "ap-northeast-1"
}

variable "lambdas" {
  type = map(string)
  default = {
    "cookbook" = "/cookbook",
    "helloworld" = "/helloworld"
  }
}