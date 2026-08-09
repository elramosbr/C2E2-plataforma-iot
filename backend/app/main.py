from fastapi import FastAPI

from app.core.config import settings
from app.database.sqlite import get_connection


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION
)


@app.get("/")
def root():
    return {
        "status": "ok",
        "service": settings.APP_NAME,
        "version": settings.APP_VERSION
    }


@app.get("/api/v1/health")
def health():
    database_status = "error"

    try:
        connection = get_connection()

        connection.execute("SELECT 1")

        connection.close()

        database_status = "ok"

    except Exception as exc:
        return {
            "status": "error",
            "api": "ok",
            "database": database_status,
            "error": str(exc)
        }

    return {
        "status": "ok",
        "api": "ok",
        "database": database_status
    }