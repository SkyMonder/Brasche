#!/bin/bash
set -e

echo "=== Установка ShashChess 41.1 ==="
mkdir -p temp
cd temp

# Скачивание и распаковка
wget -q https://github.com/amchess/ShashChess/releases/download/41.1/ShashChess-41.1-linux.zip
unzip -q ShashChess-41.1-linux.zip

# Перемещение бинарника в корневую директорию
cp ShashChess-41.1-linux/ShashChess ../engine
cd ..
rm -rf temp
chmod +x ./engine

exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
