-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 002_indexes.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

-- ============================================================
-- Índices
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_medicoes_sensor

ON medicoes(sensor_id);

CREATE INDEX IF NOT EXISTS idx_medicoes_data

ON medicoes(data_hora);

CREATE INDEX IF NOT EXISTS idx_eventos_sensor

ON eventos(sensor_id);

CREATE INDEX IF NOT EXISTS idx_eventos_data

ON eventos(data_hora);