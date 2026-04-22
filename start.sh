#!/bin/bash
set -e

echo "=== Установка Berserk ==="
mkdir -p temp
cd temp
wget -q https://github.com/jhonnold/berserk/releases/download/20250218/berserk-20250218-linux.zip
python3 -c "import zipfile; zipfile.ZipFile('berserk-20250218-linux.zip').extractall()" || true
if [ -f "berserk-20250218-linux/berserk" ]; then
    cp berserk-20250218-linux/berserk ../engine
    chmod +x ../engine
else
    echo "Berserk не найден, пробуем альтернативную ссылку..."
    wget -q https://github.com/jhonnold/berserk/releases/download/20250101/berserk-20250101-linux.zip
    python3 -c "import zipfile; zipfile.ZipFile('berserk-20250101-linux.zip').extractall()" || true
    if [ -f "berserk-20250101-linux/berserk" ]; then
        cp berserk-20250101-linux/berserk ../engine
        chmod +x ../engine
    fi
fi
cd ..
rm -rf temp

echo "=== Запускаем движок Berserk ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
