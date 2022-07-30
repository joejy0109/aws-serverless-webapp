#!/bin/bash -e

REQUIREMENTS="$(pwd)/requirements.txt"

cd ./mutiple-handlers/package

pip install -r $REQUIREMENTS -t ./python/

rm -rf ./python/*dist-info

if [ -z "$(which zip)" ]; then
  sudo apt install -y zip
fi

zip -r python-packages.zip ./python