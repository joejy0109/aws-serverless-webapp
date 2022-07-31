##
# API Gateway
##
resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    expose_headers    = ["*"]
    max_age           = 3600
  }
}


resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "v1"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


resource "aws_apigatewayv2_integration" "these" {
  for_each = aws_lambda_function.these

  api_id = aws_apigatewayv2_api.lambda.id

  # integration_uri    = aws_lambda_function.these.invoke_arn
  integration_uri    = each.value.invoke_arn
  # integration_type   = "HTTP_PROXY"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  # integration_method = "ANY"

  description = each.value.tags["route"]
}


resource "aws_apigatewayv2_route" "these" {
  for_each = aws_apigatewayv2_integration.these

  api_id = aws_apigatewayv2_api.lambda.id

  route_key = format("ANY %s", replace(each.value.description, "/:([\\w+?]+):/", "{$1}"))
  target    = "integrations/${each.value.id}"
}


resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"

  for_each      = aws_lambda_function.these
  function_name = each.value.function_name
  # function_name = aws_lambda_function.these.function_name
}
