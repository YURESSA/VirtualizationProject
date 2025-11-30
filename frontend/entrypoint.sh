#!/bin/sh
# Загружаем переменные из .env
export $(grep -v '^#' /app/virtualization/frontend/.env | xargs)

# Генерируем Nginx конфиг из шаблона
envsubst '$BACKEND_URL' < /app/virtualization/frontend/nginx.conf.template > /etc/nginx/conf.d/default.conf

# Запускаем Nginx
exec nginx -g 'daemon off;'
