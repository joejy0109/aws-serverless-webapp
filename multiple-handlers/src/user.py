import base64
import datetime
import json
import boto3
from flask import Flask, make_response
from my_comm.my_response import res


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')


users = [
    {
        "user_id": "child12",
        "user_name": "wolber Rin",
        "age": 12,
        "dept": "Develer"
    },
    {
        "user_id": "flask999",
        "user_name": "flank jin",
        "age": 36,
        "dept": "QA"
    },
    {
        "user_id": "oldman",
        "user_name": "val killmer",
        "age": 64,
        "dept": "operation"
    }
]


def handler(event, context):
    # return {"statusCode": 200, "body": "121212121"}

    if 'httpMethod' not in event:
        return res(400, {"error": "This is not a http request"})

    verb = event["httpMethod"]

    if verb == "GET":
        user_id = event["pathParameters"]["proxy"]
        if user_id == '':
            return res(200, _get_users())
        return res(200, _get_user(user_id))

    if verb == 'POST':
        # payload = base64.b64decode(event['body']).decode('utf-8')
        # return res(200, {"body": json.loads(payload)})
        return res(200, {'result': _post_user()})
    
    if verb == 'PUT':
        return res(200, {'THIS': 'PUT'})

    if verb == 'DELETE':
        return res(200, {'THIS': 'DELETE'})

    return res(400, {"error": f"Invalid a request HTTP Method: {verb}"})


def _get_user(user_id: str) -> dict:
    # result = [u for u in users if u.get('user_id') == user_id]
    # return result[0] if len(result) > 0 else {}
    result = table.get_item(Key = {
        'UserId': user_id
    })

    return result['Item']


def _get_users() -> dict:
    # return {
    #     "list": users
    # }
    result = table.query(
        KeyConditionExpression=Key('UserId')
    )
    return result['items']


def _post_user() -> dict:
    result = table.put_item(
        {
            'UserId': 'joejy0109@gmail.com',
            'Name': '조정용',
            'Age': 43,
            'Gender': 'male',
            'Address': '경기도 용인시 기흥구 서그내로 31',
            'CreateAt': datetime.datetime.now().isoformat()
        }
    )
    return result


def _put_user(item) -> dict:
    result = table.update_item(key={
        'UserId': item['UserId']
    },
    UpdateExpression = 'Set Age = :Age, Gender = :Gender',
    ExpressionAttributeValues = {
        'Age': 43,
        'Gender': 'male',
    })
    return result


def _delete_user(user_id:str) -> dict:
    result = table.delete_item(Key={
        'UserId': user_id
    })
    return result
