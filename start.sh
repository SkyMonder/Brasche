#!/bin/bash
set -e

echo "=== Установка инструментов компиляции (FPC/Lazarus) ==="
# Устанавливаем компилятор Free Pascal и утилиты
sudo apt-get update
sudo apt-get install -y fpc lazarus

echo "=== Клонирование исходников Booot ==="
git clone https://github.com/booot76/Booot-chess-engine.git
cd Booot-chess-engine

echo "=== Компиляция Booot ==="
# Используем lazbuild для компиляции из командной строки[reference:3].
# За основу взята команда из официального issue.
lazbuild --build-mode=Release --bm-config="Release" Booot.lpi

# Ищем скомпилированный бинарник. Обычно он в папке lib/
find . -name "booot" -executable -type f -exec cp {} ../engine \;

cd ..
# Проверяем, что бинарник скопировался
if [ ! -f "./engine" ]; then
    echo "Ошибка: Не удалось найти бинарник Booot!"
    exit 1
fi

chmod +x ./engine

echo "=== Запуск Booot ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
