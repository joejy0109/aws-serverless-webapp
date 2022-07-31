##
# Lambda
##
resource "aws_lambda_function" "these" {
  for_each = local.lambdas

  function_name = each.key

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  # s3_key    = aws_s3_object.serverless_app.key
  s3_key    = "${each.key}.zip"

  runtime = local.runtime
  handler = "${each.key}.${local.handler_name}"

  # source_code_hash = data.archive_file.these.output_base64sha256
  source_code_hash = filebase64sha256("${local.parent_path}/${each.key}.zip")

  role = aws_iam_role.lambda_exec.arn

  layers = [aws_lambda_layer_version.lambda_layer.arn]  # maximum 5

  tags = {
    route = each.value
  }
}


resource "aws_cloudwatch_log_group" "these" {
  for_each = aws_lambda_function.these

  # name = "/aws/lambda/${aws_lambda_function.these.function_name}"
  name = "/aws/lambda/${each.value.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = local.lambda_layer["name"]
  # filename   = local.lambda_layer["filename"] # for local

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = local.lambda_layer["filename"]

  compatible_runtimes = [local.runtime]

  # source_code_hash = ${filebase64sha256("${local.parent_path}/${local.lambda_layer["filename"]}")} # for local
  # source_code_hash = filebase64sha256(aws_s3_object.packages.body)
  source_code_hash = filebase64sha256(aws_s3_object.packages.source)

  depends_on = [aws_s3_object.packages]
}