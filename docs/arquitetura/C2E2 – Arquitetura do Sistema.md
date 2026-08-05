# C2E2 – Arquitetura do Sistema

## Objetivo

O C2E2 é uma plataforma IoT destinada ao monitoramento contínuo do consumo de energia elétrica utilizando sensores distribuídos via LoRa.

A arquitetura foi desenvolvida para ser modular, escalável e independente dos componentes de interface.

---

# Arquitetura Geral

Sensores ESP32 + SCT013

↓

LoRa

↓

Gateway ESP32

↓

WiFi

↓

MQTT Broker (Mosquitto)

↓

Node-RED

↓

SQLite

↓

FastAPI

↓

Flutter Web
---

# Componentes

## Sensores

Responsabilidades

- Medição de corrente
- RSSI
- SNR
- Heap
- Uptime
- Identificação

Tecnologia

- ESP32
- LoRa
- SCT013

---

## Gateway

Responsabilidades

- Recepção LoRa
- Encaminhamento MQTT
- Heartbeat
- Monitoramento

Tecnologia

- ESP32
- WiFi
- MQTT

---

## Broker MQTT

Responsabilidades

- Distribuição das mensagens
- Baixo acoplamento
- Escalabilidade

Tecnologia

- Eclipse Mosquitto

---

## Node-RED

Responsabilidades

- Normalização
- Dashboard
- Estatísticas
- Persistência
- Regras

Principais Fluxos

Normalizar Payload

↓

Selecionar Sensor

↓

Dashboard

↓

Banco SQLite

↓

Histórico

---

## SQLite

Responsabilidades

Persistência

Principais tabelas

gateway

sensores

leituras

eventos

---

## Backend

Responsabilidades

API REST

Consultas

Exportação

Autenticação

Tecnologia

FastAPI

Python

---

## Frontend

Responsabilidades

Dashboard Web

Histórico

Relatórios

Alertas

Tecnologia

Flutter Web

---

# Organização do Projeto

backend/

dashboard/

database/
    schema/
    migrations/
    seeds/
    backups/

datasets/

docker/

docs/

firmware/

hardware/

mobile/

research/

scripts/

tests/
---

# Fluxo dos Dados

Sensor

↓

LoRa

↓

Gateway

↓

MQTT

↓

Normalizar Payload

↓

Estatísticas

↓

Dashboard

↓

SQLite

↓

FastAPI

↓

Flutter

---

# Objetivos Arquiteturais

• Modularidade

• Escalabilidade

• Independência entre camadas

• Baixo acoplamento

• Alta disponibilidade

• Fácil manutenção

• Fácil expansão

---

# Tecnologias

ESP32

LoRa

WiFi

MQTT

Mosquitto

Node-RED

SQLite

Python

FastAPI

Flutter

Docker

Git

GitHub