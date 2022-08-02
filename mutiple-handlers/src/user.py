import json
from flask import Flask, make_response

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
        return _res(400, {"error" : "This is not a http request"})
    
    verb = event["httpMethod"]
    if verb == "GET":
        user_id = event["pathParameters"]["proxy"]
        if user_id == '':
            return _res(200, _get_users())
        return _res(200, _get_user(user_id))

    return _res(400, { "error":"Invalid a request."})


def _get_user(user_id: str) -> dict:
    result = [u for u in users if u.get('user_id') == user_id]
    return result[0] if len(result) > 0 else {}


def _get_users() -> dict:
    return {
        "list": users
    }


def _res(code, body):
    return {
        "statusCode": code,
        "body": json.dumps(body)
    }