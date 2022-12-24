resource "aws_dynamodb_table" "users" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = merge(local.tags, {
    "db" : "dynamo"
  })
}

resource "aws_dynamodb_table_item" "users_item1" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserId": {"S": "ann91@gmail.com" },
  "Name": {"S": "Ann" },
  "Age": {"N": "18" },
  "Gender": {"S": "female" },
  "Address": {"S": "3415, Lewis Street, Lemont, Illinois" },
  "CreateAt": {"S": "2015-12-21T17:42:34Z" }
}
ITEM
}

resource "aws_dynamodb_table_item" "users_item2" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserId": {"S": "tom1981@lycos.com" },
  "Name": {"S": "Tom" },
  "Age": {"N": "22" },
  "Gender": {"S": "male" },
  "Address": {"S": "1744, Longview Avenue, New York" },
  "CreateAt": {"S": "2022-03-12T05:33:09Z" }
}
ITEM
}

resource "aws_dynamodb_table_item" "users_item3" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserId": {"S": "arina-awesome@naver.com" },
  "Name": {"S": "Ariana" },
  "Age": {"N": "29" },
  "Gender": {"S": "female" },
  "Address": {"S": "4741, Columbia Road, Philadelphia, Delaware" },
  "CreateAt": {"S": "2022-03-12T05:33:09Z" }
}
ITEM
}
