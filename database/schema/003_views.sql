-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 003_views.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

-- ============================================================
-- View - Última medição por sensor
-- ============================================================

CREATE VIEW IF NOT EXISTS vw_ultima_medicao AS

SELECT

    s.id,

    s.nome,

    s.ambiente,

    COUNT(m.id) AS total_medicoes,

    MAX(m.recebido_em) AS ultima_medicao

FROM sensores s

LEFT JOIN medicoes m

    ON s.id = m.sensor_id

GROUP BY

    s.id,
    s.nome,
    s.ambiente;


-- ============================================================
-- View - Consumo atual
-- ============================================================

CREATE VIEW IF NOT EXISTS vw_consumo_atual AS

SELECT

    s.id,

    s.nome,

    s.ambiente,

    m.corrente,

    m.potencia,

    m.rssi,

    m.snr,

    m.recebido_em

FROM medicoes m

INNER JOIN sensores s

    ON s.id = m.sensor_id

WHERE m.id IN (

    SELECT MAX(id)

    FROM medicoes

    GROUP BY sensor_id

);