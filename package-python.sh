#!/bin/bash -e

REQUIREMENTS="$(pwd)/requirements.txt"

cd ./mutiple-handlers/packages

pip install -r $REQUIREMENTS -t ./python/

find . -type d -name "*dist-info" -exec rm -rf "{}" +
find . -type d -name "__pycache__" -exec rm -rf "{}" +