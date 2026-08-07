-- ======================================================
-- Projeto : C2E2 Plataforma IoT
-- Arquivo : 004_triggers.sql
-- Versão  : 1.0
-- Data    : 05/08/2026
-- ======================================================

/*
=================================================================

VERSÃO 1.0

Nesta versão da plataforma não são utilizados TRIGGERS.

Toda a lógica de negócio é executada pelo Node-RED, que é
responsável por:

- validação das mensagens MQTT;
- normalização dos dados;
- cálculo das estatísticas;
- persistência das medições;
- atualização do Dashboard.

Os triggers serão introduzidos em versões futuras apenas quando
forem necessários para automatizar regras diretamente no banco
de dados.

Possíveis evoluções:

- geração automática de eventos;
- atualização de estatísticas;
- retenção automática de histórico;
- auditoria de alterações.

=================================================================
*/