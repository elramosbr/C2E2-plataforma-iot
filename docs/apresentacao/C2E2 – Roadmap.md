# C2E2 – Roadmap

## Visão Geral

O C2E2 (Controle do Consumo de Energia Elétrica) é uma plataforma IoT destinada ao monitoramento distribuído do consumo de energia elétrica utilizando sensores LoRa, Gateway ESP32, MQTT, Node-RED, SQLite e, futuramente, Backend FastAPI e Dashboard Web.

Este roadmap apresenta a evolução planejada do projeto.

---

# Situação Atual

## Sprint E1
- Estrutura inicial do projeto
- Organização dos diretórios
- Ambiente PlatformIO

Status:
✔ Concluído

---

## Sprint E2
- Gateway LoRa
- MQTT
- Comunicação ESP32 ⇄ Raspberry
- Watchdog

Status:
✔ Concluído

---

## Sprint E3
- Suporte multi-sensor
- Identificação dos sensores
- RSSI
- SNR
- Heap
- Gateway Status

Status:
✔ Concluído

---

## Sprint E4
- Dashboard Node-RED
- Página Resumo
- Página Sistema
- Página Diagnóstico

Status:
✔ Concluído

---

## Sprint E5
- Refatoração completa da arquitetura Node-RED
- Estatísticas em memória
- Buffer Circular
- Corrente Total
- Potência Total
- RSSI Médio
- SNR Médio
- Histórico Multi-Sensor

Status:
✔ Concluído

---

# Sprint E6 — Persistência SQLite

Objetivos

- Banco SQLite
- Schemas
- Views
- Índices
- Seeds
- Persistência automática das leituras
- Consultas históricas

Status

🟡 Em desenvolvimento

---

# Sprint E7 — Backend

Objetivos

- FastAPI
- API REST
- API MQTT
- Estatísticas
- Histórico
- Exportação CSV

Status

⚪ Planejado

---

# Sprint E8 — Dashboard Web

Objetivos

- Flutter Web
- Login
- Histórico
- Dashboards
- Relatórios

Status

⚪ Planejado

---

# Sprint E9 — Inteligência

Objetivos

- Detecção automática de anomalias
- Consumo esperado
- Alertas
- Tendências
- Predição

Status

⚪ Futuro

---

# Sprint E10 — Produção

Objetivos

- Docker
- Backup automático
- OTA
- Logs
- Monitoramento

Status

⚪ Futuro

---

# Visão Final

Sensores LoRa

↓

Gateway ESP32

↓

MQTT

↓

Node-RED

↓

SQLite

↓

FastAPI

↓

Flutter Web

↓

Relatórios / IA