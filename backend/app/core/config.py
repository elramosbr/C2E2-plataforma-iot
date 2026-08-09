# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : config.py
# Módulo  : FastAPI + configuração + conexão SQLite
# Etapa   : E6.3.1
# Versão  : 1.0
# ================================================================

import os


class Settings:
    APP_NAME = "C2E2 API"
    APP_VERSION = "0.1.0"

    DATABASE_PATH = os.getenv(
        "C2E2_DB_PATH",
        "../database/c2e2.db"
    )


settings = Settings()