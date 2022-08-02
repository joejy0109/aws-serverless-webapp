import json

def res(code, body):
    return {
        "statusCode": code,
        "body": json.dumps(body)
    }