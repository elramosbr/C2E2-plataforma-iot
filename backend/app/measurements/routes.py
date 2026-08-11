# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : routes.py
# Módulo  : API de Medições
# Etapa   : E6.4.1
# Versão  : 1.0
# ================================================================

from fastapi import APIRouter, Query

from app.measurements.service import list_measurements


router = APIRouter(
    prefix="/api/v1/measurements",
    tags=["Measurements"],
)


# ================================================================
# E6.4.1 — Consulta histórica de medições
# ================================================================

@router.get("")
def get_measurements(
    sensor_id: int | None = None,
    limit: int = Query(default=100, ge=1, le=1000),
):
    return list_measurements(
        sensor_id=sensor_id,
        limit=limit,
    )
