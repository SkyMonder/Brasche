#!/bin/bash
set -e
echo "=== Установка Berserk 13 ==="
mkdir -p temp
cd temp
# Ссылка на последнюю версию (убедитесь, что это правильный бинарник для Linux)
wget -q https://github.com/jhonnold/berserk/releases/download/13/berserk-13-linux-x64.zip
unzip -q berserk-13-linux-x64.zip
cp berserk-13-linux-x64 ../berserk_engine
cd ..
rm -rf temp
chmod +x ./berserk_engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
