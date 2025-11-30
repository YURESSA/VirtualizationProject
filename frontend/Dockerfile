# Stage 1: сборка фронтенда
FROM node:18-alpine AS build
WORKDIR /app

# Копируем зависимости и устанавливаем
COPY package*.json ./
RUN npm install

# Копируем весь проект и собираем фронтенд
COPY . .
RUN npm run build

# Stage 2: Nginx с динамическим конфигом
FROM nginx:stable-alpine

# Копируем собранный фронт
COPY --from=build /app/dist /usr/share/nginx/html

# Копируем шаблон Nginx и скрипт entrypoint
COPY nginx.conf.template /app/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Экспонируем порт
EXPOSE 80

# Используем скрипт для генерации конфигурации и запуска Nginx
ENTRYPOINT ["/entrypoint.sh"]
