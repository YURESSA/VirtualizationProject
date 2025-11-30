#!/bin/sh
set -e

# Проверяем, что BACKEND_URL есть в окружении
: "${BACKEND_URL:?Need to set BACKEND_URL}"

# Генерируем Nginx конфиг из шаблона
envsubst '${BACKEND_URL}' < /app/nginx.template.conf > /etc/nginx/conf.d/default.conf

# Запускаем Nginx
exec nginx -g 'daemon off;'
