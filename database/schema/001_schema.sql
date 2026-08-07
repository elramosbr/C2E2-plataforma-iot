-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 001_schema.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- Gateway
-- ============================================================

CREATE TABLE IF NOT EXISTS gateway (

    id              INTEGER PRIMARY KEY,

    identificacao   TEXT NOT NULL UNIQUE,

    descricao       TEXT,

    instalado_em    TEXT,

    ativo           INTEGER NOT NULL DEFAULT 1,

    criado_em       DATETIME DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================
-- Sensores
-- ============================================================

CREATE TABLE IF NOT EXISTS sensores (

    id                  INTEGER PRIMARY KEY,

    gateway_id          INTEGER NOT NULL,

    nome                TEXT NOT NULL,

    ambiente            TEXT NOT NULL,

    tensao_nominal      REAL NOT NULL DEFAULT 220,

    observacao          TEXT,

    ativo               INTEGER NOT NULL DEFAULT 1,

    criado_em           DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (gateway_id)

        REFERENCES gateway(id)

);

-- ============================================================
-- Medições
-- ============================================================

CREATE TABLE IF NOT EXISTS medicoes (

    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    
    sensor_id           INTEGER NOT NULL,

    corrente            REAL,

    potencia            REAL,

    rssi                REAL,

    snr                 REAL,

    memoria_kb          REAL,

    uptime_ms           INTEGER,

    gateway_timestamp_ms INTEGER,

    sensor_timestamp_ms INTEGER,

    mqtt_topic TEXT,

    payload_json TEXT,

    recebido_em DATETIME DEFAULT CURRENT_TIMESTAMP,
   
    FOREIGN KEY(sensor_id)

        REFERENCES sensores(id)

);

-- ============================================================
-- Eventos
-- ============================================================

CREATE TABLE IF NOT EXISTS eventos (

    id                  INTEGER PRIMARY KEY AUTOINCREMENT,

    data_hora           DATETIME NOT NULL,

    sensor_id           INTEGER,

    tipo                TEXT,

    descricao           TEXT,

    valor               REAL,

    FOREIGN KEY(sensor_id)

        REFERENCES sensores(id)

);