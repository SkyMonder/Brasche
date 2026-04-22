#!/bin/bash
set -e

echo "=== Установка инструментов для компиляции C++ ==="
apt-get update && apt-get install -y g++ make

echo "=== Клонирование и компиляция ShashChess ==="
git clone https://github.com/amchess/ShashChess.git
cd ShashChess/src

# Стандартная компиляция для C++ движков
make -j build ARCH=x86-64-bmi2

cp stockfish ../../
cd ../..
rm -rf ShashChess
chmod +x ./stockfish
# Обратите внимание: бинарник называется stockfish
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
