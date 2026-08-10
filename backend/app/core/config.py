# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : config.py
# Módulo  : FastAPI + configuração + conexão SQLite
# Etapa   : E6.3.1
# Versão  : 1.0
# C2E2 - Configuração da aplicação
# Arquivo : /backend/app/core/config.py
#
# Responsabilidade:
# Centralizar as configurações da API e do banco SQLite.
# O caminho do banco pode ser definido pela variável de ambiente
# C2E2_DB_PATH.
# Se a variável não existir, utiliza o banco do próprio projeto, 
# adequado para o desenvolvimento local.
# ================================================================

import os
from pathlib import Path

class Settings:
    APP_NAME = "C2E2 API"
    APP_VERSION = "0.1.0"

    PROJECT_ROOT = Path(__file__).resolve().parents[3]

    DATABASE_PATH = os.getenv(
        "C2E2_DB_PATH",
        str(PROJECT_ROOT / "database" / "c2e2.db"),
    )


settings = Settings()
