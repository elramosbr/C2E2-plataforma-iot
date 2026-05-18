#include <Arduino.h>
#include <WiFi.h>
#include <ArduinoJson.h>
#include "wifi_manager.h"
#include "mqtt_manager.h"
#include "lora_manager.h"

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
    if (millis() - ultimoPacote > 300000) {
        Serial.println("Watchdog LoRa acionado");
        ESP.restart();
    }
}

void setup() {
    Serial.begin(115200);
    delay(2000);

    Serial.println("=== C2E2 Gateway ===");
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

    uint8_t rxBuffer[256];
    int state = radio.receive(rxBuffer, sizeof(rxBuffer));

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

        size_t packetLength = radio.getPacketLength();

        String str = "";

        for(size_t i = 0; i < packetLength; i++) {

            str += (char)rxBuffer[i];
        }

        JsonObject payloadObj =
            doc["payload"].to<JsonObject>();

        payloadObj["raw"] = str;

        char buffer[512];
        serializeJson(doc, buffer);

        bool ok = mqttClient.publish("c2e2/sensores/1", buffer);

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