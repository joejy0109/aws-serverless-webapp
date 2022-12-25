#!/bin/bash -e

REQUIREMENTS="$(pwd)/requirements.txt"
LOCAL_PACKAGE_PATH="$(pwd)/extentions/python"

cd ./multiple-handlers/.packages

# install packages from the global repository
pip install -r $REQUIREMENTS -t ./python/ -U
# install packages from the local
pip install $LOCAL_PACKAGE_PATH/my_comm -t ./python/


find . -type d -name "*dist-info" -exec rm -rf "{}" +
find . -type d -name "__pycache__" -exec rm -rf "{}" +