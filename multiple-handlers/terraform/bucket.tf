resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${local.prefix}-api-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl = "private"
}

data "archive_file" "these" {
  type = "zip"

  for_each = local.lambdas

  # source_dir  = local.source_root_path
  source_file = "${local.source_root_path}/${each.key}.py"
  output_path = "${local.archive_output_path}/${each.key}.zip"
}

resource "aws_s3_object" "these" {
  bucket = aws_s3_bucket.lambda_bucket.id

  for_each = data.archive_file.these

  key = basename(each.value.output_path)
  source = each.value.output_path

  # key    = "serverless-app.zip"
  # source = data.archive_file.these.output_path

  # etag = filemd5(data.archive_file.these.output_path)
  etag = filemd5(each.value.output_path)
}

data "archive_file" "packages" {
  type = "zip"

  source_dir  = "${local.packages_root_path}"
  output_path = "${local.archive_output_path}/${local.lambda_layer["filename"]}"
}


resource "aws_s3_object" "packages" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key = basename(data.archive_file.packages.output_path)
  source = data.archive_file.packages.output_path
  
  # key    = "serverless-app.zip"
  # source = data.archive_file.these.output_path

  # etag = filemd5(data.archive_file.these.output_path)
  etag = filemd5(data.archive_file.packages.output_path)
}