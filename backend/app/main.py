# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : main.py
# Módulo  : Backend / API
# Etapa   : E6.3.1
# Versão  : 1.0
# ================================================================

from fastapi import FastAPI

from app.core.config import settings
from app.database.sqlite import get_connection
from app.sensors.routes import router as sensors_router
from app.measurements.routes import router as measurements_router


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION
)


app.include_router(sensors_router)
app.include_router(measurements_router)


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
