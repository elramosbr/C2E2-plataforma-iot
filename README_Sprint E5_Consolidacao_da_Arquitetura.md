# Sprint E5 – Consolidação da Arquitetura e Evolução do Dashboard

## Objetivo

Consolidar a arquitetura lógica do C2E2 antes da implementação da persistência em banco de dados, introduzindo um modelo centralizado para gerenciamento do estado dos sensores e evolução do Dashboard Node-RED.

---

## Principais alterações

### 1. Refatoração do fluxo MQTT

O processamento das mensagens foi reorganizado através das funções:

- Normalizar Payload
- Normalizar Gateway

eliminando duplicidade de processamento e padronizando os dados utilizados pelo Dashboard.

---

### 2. Modelo centralizado dos sensores

Foi criado o objeto de contexto:

flow.sensores

que mantém o estado completo de cada sensor.

Estrutura:

- id
- nome
- corrente
- potência
- RSSI
- SNR
- gateway
- memória
- uptime
- último update
- status online

Esta estrutura passa a representar a fonte única de informações dos sensores.

---

### 3. Buffer circular de histórico

Cada sensor passou a possuir um histórico próprio contendo as últimas leituras recebidas.

Objetivos:

- suporte a gráficos históricos
- cálculo de estatísticas
- preparação para persistência em banco
- futura implementação de análises temporais

---

### 4. Estatísticas globais

Foi implementado o cálculo automático de:

- Sensores Online
- Pacotes Recebidos
- RSSI Médio
- SNR Médio
- Corrente Total
- Potência Total

As estatísticas são disponibilizadas ao Dashboard através da função Normalizar Gateway.

---

### 5. Dashboard

A página Resumo passou a apresentar:

- Gateway
- Estado
- Tempo Ligado
- Memória
- Última atualização
- Sensores ativos
- Pacotes recebidos

Além das informações individuais de cada sensor.

---

### 6. Página Sistema

Foram adicionados indicadores de:

- RSSI Médio
- SNR Médio
- Corrente Total
- Potência Total

permitindo uma visão operacional da rede LoRa.

---

### 7. Página Diagnóstico

O histórico passou a possuir gráficos independentes para:

- Corrente
- RSSI
- SNR

Cada gráfico utiliza sua própria função de preparação dos dados, preservando a independência entre as variáveis monitoradas.

---

### 8. Padronização

Foi iniciada a padronização dos nomes internos dos atributos.

Exemplos:

- memoria_kb
- potencia
- corrente
- ultimo_update

Esta padronização reduz inconsistências e prepara o sistema para integração com banco de dados.

---

## Situação atual

Nesta etapa o sistema possui:

✓ Gateway LoRa operacional

✓ Comunicação MQTT

✓ Dashboard Node-RED

✓ Histórico de Corrente

✓ Histórico de RSSI

✓ Histórico de SNR

✓ Estatísticas globais

✓ Estrutura centralizada dos sensores

✓ Buffer circular de histórico

---

## Próxima Sprint

E6 – Persistência de Dados

Objetivos previstos:

- Modelagem do banco de dados
- Persistência das leituras
- Registro de eventos
- Base para alarmes
- Histórico permanente