import json
from multiprocessing.dummy import Array


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
    return {
        "ctx": json.dumps(context)
    }


def _get_user(user_id: str) -> dict:
    result = [u for u in users if u.get('user_id') == user_id]
    if len(result) > 0:
        return result[0]


def _get_users() -> Array(dict):
    return users
