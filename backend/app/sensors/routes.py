# ================================================================
# Projeto : C2E2 — Plataforma IoT
# Arquivo : routes.py
# Módulo  : API de Sensores
# Etapa   : E6.3.2
# Versão  : 1.0
# ================================================================

from fastapi import APIRouter

from app.sensors.service import list_sensors


router = APIRouter(
    prefix="/api/v1/sensors",
    tags=["Sensors"]
)


@router.get("")
def get_sensors():
    return list_sensors()