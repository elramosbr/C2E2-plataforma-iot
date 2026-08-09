# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : sqlite.py
# Módulo  : FastAPI + configuração + conexão SQLite
# Etapa   : E6.3.1
# Versão  : 1.0
# ================================================================

import sqlite3

from app.core.config import settings


def get_connection() -> sqlite3.Connection:
    connection = sqlite3.connect(
        settings.DATABASE_PATH
    )

    connection.row_factory = sqlite3.Row

    return connection