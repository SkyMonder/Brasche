#!/bin/bash
set -e

echo "=== Установка PlentyChess 7.0.0 ==="
mkdir -p temp
cd temp
# Ссылка на официальный бинарник PlentyChess v7.0.0 для Linux
wget -q https://github.com/Yoshie2000/PlentyChess/releases/download/v7.0.0/PlentyChess-7.0.0-linux.zip
unzip -q PlentyChess-7.0.0-linux.zip
cp PlentyChess-7.0.0-linux/PlentyChess ../engine
cd ..
rm -rf temp
chmod +x ./engine
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
