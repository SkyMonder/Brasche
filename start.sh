#!/bin/bash
set -e

echo "=== Установка Koivisto ==="
mkdir -p temp
cd temp

# Скачиваем последнюю стабильную версию Koivisto для Linux
wget -q https://github.com/Luecx/Koivisto/releases/download/v9.0/Koivisto-9.0-linux.zip
unzip -q Koivisto-9.0-linux.zip

# Копируем бинарный файл в корневую директорию
cp Koivisto-9.0-linux/Koivisto ../engine

cd ..
rm -rf temp
chmod +x ./engine

# Запускаем веб-сервер для связи с Lichess
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
