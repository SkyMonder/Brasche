#!/bin/bash
set -e
echo "=== Запуск API-сервиса ChessDB ==="
exec gunicorn -k uvicorn.workers.UvicornWorker -b 0.0.0.0:$PORT engine:app
