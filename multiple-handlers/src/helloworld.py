import json


def handler(event, context):
    if 'httpMethod' not in event:
        return {"statusCode": 400, "error": "This is not a http request"}

    verb = event["httpMethod"]

    if verb == "GET":
        return get()    
    if verb == "POST":
        return post()
    if verb == "PUT":
        return put()
    if verb == "DELETE":
        return delete()

    return {"statusCode": 400, "error": "Invalid request."}


def get():
    return {"statusCode": 200, "body": "GET ok."}

def post():
    return {"statusCode": 200, "body": "POST ok."}

def put():
    return {"statusCode": 200, "body": "PUT ok."}

def delete():
    return {"statusCode": 200, "body": "DELETE ok."}
