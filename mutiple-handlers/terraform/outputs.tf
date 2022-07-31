# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function."

  # value = [ for k, v in aws_lambda_function.these : v.function_name ]
  # or
  value =  (values(aws_lambda_function.these)[*].function_name)
  # or
  # value =  toset([ for v in aws_lambda_function.these : v.function_name ])
}

output "api_endpoint" {
  description = "Uri of the API Gateway."

  value = aws_apigatewayv2_api.lambda.api_endpoint
}