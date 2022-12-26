import base64
import datetime
import json
from typing import Tuple
import boto3
from boto3.dynamodb.conditions import Key, Attr
from flask import Flask, make_response
from my_comm.my_response import res


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')


def handler(event, context):
    # return {"statusCode": 200, "body": "121212121"}

    print(event)
    print(context)

    if 'httpMethod' not in event:
        return res(400, {"error": "This is not a http request"})

    verb = event["httpMethod"]

    if verb == "GET":
        user_id = event["pathParameters"]["proxy"]
        if user_id == '':
            return res(200, _get_users())
        return res(200, _get_user(user_id))

    if verb == 'POST':
        ok, data = _parse_body(event)
        if not ok:
            return res(400, data)
        response = _put_user(data)
        return res(200, response)
    
    if verb == 'PUT':
        user_id = event["pathParameters"]["proxy"]
        ok, data = _parse_body(event)        
        if not ok:
            return res(400, data)
        response = _update_user(user_id, data)        
        return res(200, response)

    if verb == 'DELETE':
        user_id = event["pathParameters"]["proxy"]
        response = _delete_user(user_id)
        return res(200, response)

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
    #     KeyConditionExpression=Key('UserId').eq('')
    # )
    response = table.scan()
    items = response['Items']
    while 'LastEvaluatedKey' in response:
        print(response['LastEvaluatedKey'])
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
        items.extend(response['Items'])
    print(items)
    return items
   

def _put_user(item) -> dict:
    # item = {
    #     'UserId': 'joejy0109@gmail.com',
    #     'Name': '베트맨',
    #     'Age': 43,
    #     'Gender': 'male',
    #     'Address': '서울시 서초구 강남대로 327',
    #     'CreateAt': datetime.datetime.now().isoformat()
    # }
    item['CreatedAt'] = datetime.datetime.now().isoformat()
    response = table.put_item(Item=item)
    return response


def _update_user(user_id, item) -> dict:
    response = table.update_item(Key={
        'UserId': user_id
    },
    UpdateExpression = 'Set Age = :Age, Gender = :Gender, Address = :Address',
    ExpressionAttributeValues = {
        ':Age': item['Age'],
        ':Gender': item['Gender'],
        ':Address': item['Address'],
    },
    ReturnValues='UPDATED_NEW')
    return response


def _delete_user(user_id:str) -> dict:
    response = table.delete_item(Key={
        'UserId': user_id
    })
    return response


def _parse_body(event) -> Tuple[bool, dict]:
    if 'body' not in event:
        return False, {'error': 'Invalid request.(Not include payload)'}

    json_body = base64.b64decode(event['body'])
    json_data = json.loads(json_body)

    return True, json_data