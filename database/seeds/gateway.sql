-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : gateway.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

DELETE FROM gateway WHERE id = 1;

INSERT INTO gateway (

    id,
    identificacao,
    descricao,
    instalado_em,
    ativo

)

VALUES (

    1,
    'GW-01',
    'Gateway LoRa Principal',
    'Instalação Residencial'
    1

);