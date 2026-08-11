# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : service.py
# Módulo  : API de Medições
# Etapa   : E6.4.1
# Versão  : 1.0
# ================================================================

from app.database.sqlite import get_connection


def list_measurements(
    sensor_id: int | None = None,
    limit: int = 100,
):
    """
    Retorna as medições mais recentes.

    Parâmetros:
        sensor_id: filtra as medições por sensor quando informado.
        limit: quantidade máxima de registros retornados.

    Retorno:
        Lista de dicionários com as medições.
    """

    connection = get_connection()

    try:
        query = """
            SELECT
                id,
                sensor_id,
                corrente,
                potencia,
                rssi,
                snr,
                memoria_kb,
                uptime_ms,
                gateway_timestamp_ms,
                sensor_timestamp_ms,
                mqtt_topic,
                recebido_em
            FROM medicoes
        """

        params = []

        if sensor_id is not None:
            query += """
                WHERE sensor_id = ?
            """
            params.append(sensor_id)

        query += """
            ORDER BY id DESC
            LIMIT ?
        """

        params.append(limit)

        cursor = connection.execute(query, params)

        rows = cursor.fetchall()

        measurements = []

        for row in rows:
            item = dict(row)

            # SQLite CURRENT_TIMESTAMP utiliza UTC.
            # A API explicita isso utilizando ISO 8601 + Z.
            if item["recebido_em"]:
                item["recebido_em"] = (
                    item["recebido_em"].replace(" ", "T") + "Z"
                )

            measurements.append(item)

        return measurements

    finally:
        connection.close()
