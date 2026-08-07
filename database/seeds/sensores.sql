-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : sensores.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

DELETE FROM sensores
WHERE id IN (1,2,3);

INSERT INTO sensores (

    id,
    gateway_id,
    nome,
    ambiente,
    tensao_nominal,
    ativo

)

VALUES

(
    1,
    1,
    'SCT013-001',
    'Banheiro',
    220,
    1
),

(
    2,
    1,
    'SCT013-002',
    'Sala',
    220,
    1
),

(
    3,
    1,
    'SCT013-003',
    'Boiler',
    220,
    1
);