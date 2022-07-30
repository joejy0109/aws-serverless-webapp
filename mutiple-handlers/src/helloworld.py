import json


def handler(event, context):
    body = {
        "message": "This is a HelloWorld handler???!!!",
        "input": event,
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response


def get():
    return {"statusCode": 200, "body": "GET ok."}


def post():
    return {"statusCode": 200, "body": "POST ok."}


def put():
    return {"statusCode": 200, "body": "PUT ok."}


def delete():
    return {"statusCode": 200, "body": "DELETE ok."}
