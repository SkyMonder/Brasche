#!/bin/bash
set -e

echo "=== Установка Booot 7.1 ==="
mkdir -p temp
cd temp
wget -q https://github.com/booot76/Booot-chess-engine/releases/download/7.1/booot-7.1-linux.zip
unzip -q booot-7.1-linux.zip
cp booot-7.1-linux/booot ../engine
cd ..
rm -rf temp
chmod +x ./engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
