-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 003_views.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

-- ============================================================
-- View - Última medição
-- ============================================================

CREATE VIEW IF NOT EXISTS vw_ultima_medicao AS

SELECT

    s.id,

    s.nome,

    s.ambiente,

    MAX(m.data_hora) AS ultima_medicao

FROM sensores s

LEFT JOIN medicoes m

ON s.id = m.sensor_id

GROUP BY

    s.id;