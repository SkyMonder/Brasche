#!/bin/bash
set -e

echo "=== Установка Berserk ==="
DOWNLOADED=false

# Функция для попытки скачать и распаковать
try_download() {
    local url=$1
    local output=$2
    echo "Попытка скачать с: $url"
    if wget -q --spider "$url"; then
        wget -q "$url" -O "$output"
        if [ -f "$output" ]; then
            echo "Файл $output успешно скачан."
            return 0
        fi
    fi
    echo "Не удалось скачать с $url"
    return 1
}

# Попытка 1: Скачать последнюю версию по тегу 'latest'
echo "Попытка 1: Поиск последней версии через GitHub API..."
LATEST_URL=$(curl -s https://api.github.com/repos/jhonnold/berserk/releases/latest | grep "browser_download_url.*linux-x64.zip" | cut -d '"' -f 4)
if [ -n "$LATEST_URL" ]; then
    if try_download "$LATEST_URL" "berserk-latest.zip"; then
        unzip -q berserk-latest.zip && chmod +x berserk && mv berserk ./berserk_engine && DOWNLOADED=true
    fi
fi

# Попытка 2: Скачать версию 13 (если первая не удалась)
if [ "$DOWNLOADED" = false ]; then
    echo "Попытка 2: Скачать Berserk 13..."
    try_download "https://github.com/jhonnold/berserk/releases/download/13/berserk-13-linux-x64.zip" "berserk-13.zip"
    if [ -f "berserk-13.zip" ]; then
        unzip -q berserk-13.zip && chmod +x berserk && mv berserk ./berserk_engine && DOWNLOADED=true
    fi
fi

# Попытка 3: Скачать с альтернативного сайта (если предыдущие не удались)
if [ "$DOWNLOADED" = false ]; then
    echo "Попытка 3: Скачать с Chessengeria..."
    try_download "https://www.chessengeria.com/files/berserk/berserk-13-linux.zip" "berserk-alt.zip"
    if [ -f "berserk-alt.zip" ]; then
        unzip -q berserk-alt.zip && chmod +x berserk && mv berserk ./berserk_engine && DOWNLOADED=true
    fi
fi

# Если все попытки не удались, используем Stockfish как запасной вариант
if [ "$DOWNLOADED" = false ]; then
    echo "Не удалось загрузить Berserk. Используем Stockfish в качестве запасного варианта."
    apt-get update && apt-get install -y stockfish
    cp /usr/games/stockfish ./berserk_engine
    chmod +x ./berserk_engine
fi

exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
