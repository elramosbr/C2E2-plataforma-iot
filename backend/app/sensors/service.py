# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : service.py
# Módulo  : API de Sensores
# Etapa   : E6.3.2
# Versão  : 1.0
# ================================================================

from app.database.sqlite import get_connection


def list_sensors():
    connection = get_connection()

    try:
        cursor = connection.execute(
            """
            SELECT
                id,
                gateway_id,
                nome,
                ambiente,
                tensao_nominal,
                observacao,
                ativo,
                criado_em
            FROM sensores
            ORDER BY id
            """
        )

        rows = cursor.fetchall()

        return [dict(row) for row in rows]

    finally:
        connection.close()