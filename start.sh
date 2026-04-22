#!/bin/bash
set -e

echo "=== Установка Halogen 12 ==="
mkdir -p temp
cd temp

# Скачивание бинарника Halogen для Linux
wget -q https://github.com/KierenP/Halogen/releases/download/v12/Halogen-12-linux.zip
unzip -q Halogen-12-linux.zip

# Копирование бинарного файла в корневую директорию
cp Halogen-12-linux/Halogen ../engine

cd ..
rm -rf temp
chmod +x ./engine

# Запуск веб-сервера
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
