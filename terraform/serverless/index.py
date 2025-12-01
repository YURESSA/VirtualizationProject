from datetime import datetime, timedelta
import psycopg2
import os

DB_HOST = os.environ.get("POSTGRES_HOST")
DB_NAME = os.environ.get("POSTGRES_DB")
DB_USER = os.environ.get("POSTGRES_USER")
DB_PASSWORD = os.environ.get("POSTGRES_PASSWORD")


def handler(event, context):
    threshold = datetime.now() - timedelta(minutes=15)

    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cur = conn.cursor()
    cur.execute("""
                DELETE
                FROM reservations
                WHERE is_paid = false
                  AND booked_at < %s
                  AND is_cancelled = false RETURNING reservation_id;
                """, (threshold,))

    deleted = cur.fetchall()
    conn.commit()
    cur.close()
    conn.close()

    return {"deleted_count": len(deleted)}
