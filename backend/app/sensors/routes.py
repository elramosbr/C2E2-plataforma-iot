# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : routes.py
# Módulo  : API de Sensores
# Etapa   : E6.3.2
# Versão  : 1.0
# ================================================================

from fastapi import APIRouter, HTTPException

from app.sensors.service import get_sensor, list_sensors


router = APIRouter(
    prefix="/api/v1/sensors",
    tags=["Sensors"]
)


@router.get("")
def get_sensors():
    return list_sensors()

# ================================================================
# E6.3.2.1 — Consulta individual de sensor
# ================================================================

@router.get("/{sensor_id}")
def get_sensor_by_id(sensor_id: int):
    sensor = get_sensor(sensor_id)

    if sensor is None:
        raise HTTPException(
            status_code=404,
            detail="Sensor não encontrado",
        )

    return sensor