# Лабораторная работа № 2 — Docker

Проект демонстрирует контейнеризацию Flask-приложения с использованием Docker и Docker Compose.

## Состав проекта

- Flask + Gunicorn — веб-приложение
- Nginx — обратный прокси-сервер
- PostgreSQL — база данных
- Docker Compose — управление сервисами

## Требования

- Docker
- Docker Compose

## Запуск

1. Создать файл переменных окружения:

   cp .env.example .env

2. Изменить POSTGRES_PASSWORD в .env.

3. Запустить сервисы:

   docker compose up -d --build

4. Проверить приложение:

   curl -i http://localhost/health

Ожидаемый HTTP-статус: 200 OK.

## Архитектура

Клиент -> Nginx -> Flask

PostgreSQL находится во внутренней сети backend.

Используются две Docker-сети:
- frontend: Nginx и Flask
- backend: Flask и PostgreSQL

На хост опубликован только порт 80 сервиса Nginx.

## Dockerfile

Реализованы:
- многоэтапная сборка builder/runtime;
- базовый образ с фиксированным тегом;
- запуск приложения от непривилегированного пользователя;
- ENV, EXPOSE, HEALTHCHECK;
- ENTRYPOINT в exec-форме.

## Проверка PostgreSQL Volume

Создать таблицу и запись:

docker compose exec -T postgres psql -U labuser -d labdb -c "CREATE TABLE IF NOT EXISTS persistence_test (message TEXT NOT NULL); INSERT INTO persistence_test VALUES ('Docker volume works');"

Пересоздать контейнеры:

docker compose down
docker compose up -d

Проверить сохранность записи:

docker compose exec -T postgres psql -U labuser -d labdb -c "SELECT * FROM persistence_test;"

Данные сохраняются в именованном томе pgdata.

## Публикация образа

Авторизоваться в Docker Hub:

docker login

Запустить скрипт:

./build-and-push.sh <dockerhub-user>/lab2-app:1.0

## Остановка

docker compose down

Команда не удаляет именованный том с данными.
