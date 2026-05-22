#include <Arduino.h>
#include <ArduinoJson.h>
#include <RadioLib.h>
#include "D:\Desenvolvimento\C2E2-plataforma-iot\firmware\comum\config.h"
// =========================
// CONFIG SENSOR
// =========================

#include "sensor_1.h"

// =========================
// HARDWARE
// =========================


#define PINO_SCT 1

SX1262 radio = new Module(8, 14, 12, 13);

// =========================
// CONTROLE
// =========================

unsigned long ultimoEnvio = 0;

unsigned long contador = 0;

// =========================
// RMS
// =========================

float calculaCorrenteRMS() {

    const int amostras = 1000;

    float offset = 0;

    // =========================
    // OFFSET DINÂMICO
    // =========================

    for(int i = 0; i < amostras; i++) {

        offset += analogRead(PINO_SCT);

        delayMicroseconds(200);
    }

    offset /= amostras;

    // =========================
    // RMS
    // =========================

    double somaQuadrados = 0;

    for(int i = 0; i < amostras; i++) {

        float leitura = analogRead(PINO_SCT);

        float valorCentralizado =
            leitura - offset;

        somaQuadrados +=
            valorCentralizado *
            valorCentralizado;

        delayMicroseconds(200);
    }

    float rmsADC =
        sqrt(somaQuadrados / amostras);

    // =========================
    // CALIBRAÇÃO
    // =========================

    float corrente =
        rmsADC * 0.0267;

    return corrente;
}

// =========================
// SETUP
// =========================

void setup() {

    Serial.begin(115200);

    delay(2000);

    Serial.println("=== C2E2 TX SENSOR ===");

    Serial.print("Sensor ID: ");
    Serial.println(SENSOR_ID);

    Serial.print("Sensor Nome: ");
    Serial.println(SENSOR_NOME);

    analogReadResolution(12);

    int state =
        radio.begin(LORA_FREQUENCY);
   
    if(state != RADIOLIB_ERR_NONE) {

        Serial.print("Erro LoRa: ");

        Serial.println(state);

        while(true);
    }

    Serial.println("LoRa OK");
    randomSeed(analogRead(0));

    int atrasoInicial =
        random(1000, 5000);

    Serial.print("Atraso inicial: ");

    Serial.println(atrasoInicial);

    delay(atrasoInicial);
}

// =========================
// LOOP
// =========================

void loop() {



if(millis() - ultimoEnvio >= 5000 + random(0,1000)) {

        ultimoEnvio = millis();

        contador++;

        float corrente =
            calculaCorrenteRMS();

        JsonDocument doc;

        doc["id"] = SENSOR_ID;

        doc["nome"] = SENSOR_NOME;

        doc["tipo"] = "corrente";

        doc["corrente"] = corrente;

        doc["heap"] =
            ESP.getFreeHeap();

        doc["count"] = contador;

        doc["uptime_ms"] =
            millis();

        char buffer[256];

        serializeJson(doc, buffer);

        int state =
            radio.transmit(buffer);

        if(state == RADIOLIB_ERR_NONE) {

            Serial.println("TX OK");

            Serial.println(buffer);

        } else {

            Serial.print("Erro TX: ");

            Serial.println(state);
        }
    }
}