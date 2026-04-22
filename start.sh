#!/bin/bash
set -e
echo "=== Установка Berserk ==="
mkdir -p temp
cd temp
wget -q https://github.com/jhonnold/berserk/releases/download/11/berserk-11-linux-x64.zip
unzip -q berserk-11-linux-x64.zip
cp berserk-11-linux-x64 ./berserk || true
cd ..
cp temp/berserk-11-linux-x64 ./berserk_engine 2>/dev/null || cp temp/berserk ./berserk_engine
chmod +x ./berserk_engine
rm -rf temp
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
