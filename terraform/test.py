import psycopg2
import time

import pytest


def test_postgres():
    print("Тестируем подключение к PostgreSQL...")

    try:
        conn = psycopg2.connect(
            host="158.160.112.15",
            port=5432,
            user="ukno_user",
            password="ukno_pass",
            dbname="ukno",
            connect_timeout=10
        )

        print("✅ УСПЕШНОЕ ПОДКЛЮЧЕНИЕ!")

        # Выполняем тестовые запросы
        cur = conn.cursor()

        # Версия PostgreSQL
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        print(f"🔧 Версия PostgreSQL: {version}")

        # Текущая база данных
        cur.execute("SELECT current_database();")
        db = cur.fetchone()[0]
        print(f"📊 Текущая база: {db}")

        # Список всех баз данных
        cur.execute("SELECT datname FROM pg_database WHERE datistemplate = false;")
        databases = [row[0] for row in cur.fetchall()]
        print(f"📋 Все базы данных: {', '.join(databases)}")

        # Информация о подключении
        cur.execute("SELECT inet_server_addr(), inet_server_port();")
        server_info = cur.fetchone()
        print(f"🌐 Сервер: {server_info[0]}:{server_info[1]}")

        cur.close()
        conn.close()

        print("\n🎉 PostgreSQL полностью настроен и доступен!")
        return True

    except Exception as e:
        pytest.fail(f"❌ Ошибка подключения к PostgreSQL: {e}")
        return False


if __name__ == "__main__":
    # Проверим несколько раз
    MAX_ATTEMPTS = 5

    for i in range(MAX_ATTEMPTS):
        print(f"\nПопытка {i + 1}/{MAX_ATTEMPTS}:")
        if test_postgres():
            break
        time.sleep(3)
    else:
        print("\n💥 Не удалось подключиться к PostgreSQL")
