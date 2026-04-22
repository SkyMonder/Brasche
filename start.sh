#!/bin/bash
set -e

echo "=== Установка GNU Chess ==="
# Устанавливаем движок и книгу дебютов из официального репозитория.
# Это гарантирует установку последней версии, совместимой с вашим окружением.
apt-get update && apt-get install -y gnuchess gnuchess-book

# Копируем бинарный файл в корень, чтобы наш Python-код мог его найти.
cp /usr/games/gnuchess ./engine
chmod +x ./engine

echo "=== Запуск GNU Chess ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
