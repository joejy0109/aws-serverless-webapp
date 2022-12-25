import base64
import datetime
import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from flask import Flask, make_response
from my_comm.my_response import res


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')


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
        return res(200, {'response': _post_user()})
    
    if verb == 'PUT':
        return res(200, {'THIS': 'PUT'})

    if verb == 'DELETE':
        return res(200, {'THIS': 'DELETE'})

    return res(400, {"error": f"Invalid a request HTTP Method: {verb}"})


def _get_user(user_id: str) -> dict:
    # response = [u for u in users if u.get('user_id') == user_id]
    # return response[0] if len(response) > 0 else {}
    response = table.get_item(Key = {
        'UserId': user_id
    })
    if 'Item' in response:
        return response['Item']
    return {}


def _get_users() -> dict:
    # response = table.query(
    #     KeyConditionExpression=Key('UserId')
    # )
    response = table.scan()
    items = response['Items']
    while 'LastEvaluatedKey' in response:
        print(response['LastEvaluatedKey'])
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        items.extend(response['Items'])
    print(items)
    return items
   

def _post_user() -> dict:
    response = table.put_item(
        {
            'UserId': 'joejy0109@gmail.com',
            'Name': '조정용',
            'Age': 43,
            'Gender': 'male',
            'Address': '경기도 용인시 기흥구 서그내로 31',
            'CreateAt': datetime.datetime.now().isoformat()
        }
    )
    return response


def _put_user(item) -> dict:
    response = table.update_item(key={
        'UserId': item['UserId']
    },
    UpdateExpression = 'Set Age = :Age, Gender = :Gender',
    ExpressionAttributeValues = {
        'Age': 43,
        'Gender': 'male',
    })
    return response


def _delete_user(user_id:str) -> dict:
    response = table.delete_item(Key={
        'UserId': user_id
    })
    return response
