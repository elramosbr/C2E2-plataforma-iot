-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 002_indexes.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

-- ============================================================
-- Índices da tabela GATEWAY
-- ============================================================

CREATE UNIQUE INDEX IF NOT EXISTS idx_gateway_identificacao
ON gateway(identificacao);

-- ============================================================
-- Índices da tabela SENSORES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_sensores_gateway
ON sensores(gateway_id);

CREATE INDEX IF NOT EXISTS idx_sensores_ambiente
ON sensores(ambiente);

-- ============================================================
-- Índices da tabela MEDICOES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_medicoes_sensor
ON medicoes(sensor_id);

CREATE INDEX IF NOT EXISTS idx_medicoes_recebido
ON medicoes(recebido_em);

CREATE INDEX IF NOT EXISTS idx_medicoes_sensor_recebido
ON medicoes(sensor_id, recebido_em);

CREATE INDEX IF NOT EXISTS idx_medicoes_gateway_timestamp
ON medicoes(gateway_timestamp_ms);

CREATE INDEX IF NOT EXISTS idx_medicoes_sensor_timestamp
ON medicoes(sensor_timestamp_ms);

-- ============================================================
-- Índices da tabela EVENTOS
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_eventos_sensor
ON eventos(sensor_id);

CREATE INDEX IF NOT EXISTS idx_eventos_data
ON eventos(data_hora);

CREATE INDEX IF NOT EXISTS idx_eventos_tipo
ON eventos(tipo);