## Stage 1: сборка фронтенда
#FROM node:18-alpine AS build
#WORKDIR /app
#
## Копируем зависимости и устанавливаем
#COPY package*.json ./
#RUN npm install
#
## Копируем весь проект и собираем фронтенд
#COPY . .
#RUN npm run build
#
## Stage 2: Nginx с динамическим конфигом
#FROM nginx:stable-alpine
#
## Копируем собранный фронт
#COPY --from=build /app/dist /usr/share/nginx/html
#
## Копируем шаблон Nginx и скрипт entrypoint
#COPY nginx.template.conf /app/nginx.template.conf
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#
## Экспонируем порт
#EXPOSE 80
#
## Используем скрипт для генерации конфигурации и запуска Nginx
#ENTRYPOINT ["/entrypoint.sh"]

# 1. Stage сборки фронтенда
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 2. Stage Nginx
FROM nginx:alpine

# Устанавливаем envsubst
RUN apk add --no-cache gettext

WORKDIR /app

# Копируем фронтенд билд
COPY --from=build /app/dist /usr/share/nginx/html

# Копируем шаблон nginx и entrypoint
COPY nginx.template.conf /app/nginx.template.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Указываем entrypoint
ENTRYPOINT ["/entrypoint.sh"]
