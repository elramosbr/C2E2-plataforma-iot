#include <Arduino.h>
#include <WiFi.h>
#include <ArduinoJson.h>
#include "wifi_manager.h"
#include "mqtt_manager.h"
#include "lora_manager.h"
#include "D:\Desenvolvimento\C2E2-plataforma-iot\firmware\comum\config.h"
unsigned long ultimoHeartbeat = 0;
unsigned long ultimoPacote = 0;

void publicaHeartbeat() {
    JsonDocument doc; 
    doc["gateway"] = "gw01";
    doc["status"] = "online";
    doc["uptime_ms"] = millis();
    doc["heap"] = ESP.getFreeHeap();

    char buffer[256];
    serializeJson(doc, buffer);

    mqttClient.publish("c2e2/gateway/status", buffer);
    Serial.println("Heartbeat enviado");
}

void verificaWiFi() {
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("WiFi desconectado");
        WiFi.disconnect();
        conectaWiFi();
    }
}

void verificaMQTT() {
    if (!mqttClient.connected()) {
        Serial.println("MQTT desconectado");
        conectaMQTT();
    }
}

void verificaWatchdogLoRa() {

    static bool alertaEmitido = false;

    unsigned long tempoSemPacote =
        millis() - ultimoPacote;

    // 5 min sem pacote -> apenas alerta

    if (tempoSemPacote > 300000 &&
        !alertaEmitido) {

        Serial.println(
            "ALERTA: sem pacote LoRa > 5 min"
        );

        alertaEmitido = true;
    }

    // 30 min sem pacote -> reboot

    if (tempoSemPacote > 1800000) {

        Serial.println(
            "Watchdog crítico: reboot ESP32"
        );

        ESP.restart();
    }

    // voltou a receber -> limpa alerta

    if (tempoSemPacote < 300000) {
        alertaEmitido = false;
    }
}

void setup() {

    Serial.begin(115200);
    delay(2000);

    Serial.println("=== C2E2 Gateway ===");

    esp_reset_reason_t motivo = esp_reset_reason();

    Serial.print("Motivo do reboot: ");

    switch(motivo) {

        case ESP_RST_POWERON:
            Serial.println("POWERON");
            break;

        case ESP_RST_SW:
            Serial.println("SOFTWARE");
            break;

        case ESP_RST_PANIC:
            Serial.println("PANIC");
            break;

        case ESP_RST_INT_WDT:
            Serial.println("INT_WDT");
            break;

        case ESP_RST_TASK_WDT:
            Serial.println("TASK_WDT");
            break;

        case ESP_RST_WDT:
            Serial.println("WDT");
            break;

        case ESP_RST_DEEPSLEEP:
            Serial.println("DEEPSLEEP");
            break;

        case ESP_RST_BROWNOUT:
            Serial.println("BROWNOUT");
            break;

        default:
            Serial.println("OUTRO");
            break;
    }

    conectaWiFi();
    conectaMQTT();
    iniciaLoRa();

    ultimoPacote = millis();

    Serial.println("Gateway pronto");
}

void loop() {
    verificaWiFi();
    verificaMQTT();
    mqttClient.loop();

    if (millis() - ultimoHeartbeat > 30000) {
        publicaHeartbeat();
        ultimoHeartbeat = millis();
    }

    verificaWatchdogLoRa();

    String str;
    
    int state =
        radio.receive(str);
    
        Serial.print("STATE RX = ");
    Serial.println(state);
    if (state == RADIOLIB_ERR_NONE) {
        ultimoPacote = millis();

        float rssi = radio.getRSSI();
        float snr = radio.getSNR();

        JsonDocument doc;
        doc["rssi"] = rssi;
        doc["snr"] = snr;
        doc["gateway"] = "gw01";
        doc["timestamp_ms"] = millis();
        doc["heap"] = ESP.getFreeHeap();

        JsonDocument payloadRX;

        DeserializationError erroRX =
              deserializeJson(payloadRX, str);

        if(!erroRX) {
            doc["payload"] = payloadRX;

        } else {

             doc["payload_raw"] = str;
        }
        char buffer[512];
        serializeJson(doc, buffer);
    int sensorID = 0;

    if(!erroRX) {

      sensorID =
           payloadRX["id"] | 0;
    }

    String topico =
      "c2e2/sensores/" +
      String(sensorID);

    bool ok =
        mqttClient.publish(
           topico.c_str(),
           buffer
        );
        if (ok) {
            Serial.println("MQTT publish OK");
            Serial.println(buffer);
        } else {
            Serial.println("MQTT publish FALHOU");
        }
    } 
    else if (state == RADIOLIB_ERR_RX_TIMEOUT) {
        // Opcional: Serial.println("Timeout de recepção");
    } 
    else {
        Serial.print("Erro no rádio: ");
        Serial.println(state);
    }
} // <--- Chave que fecha o loop() que estava faltando