#include <WiFi.h>
#include <PubSubClient.h>
#include <Arduino.h>

#include "mqtt_manager.h"
#include "secrets.h"

WiFiClient espClient;
PubSubClient mqttClient(espClient);

void conectaMQTT() {

    mqttClient.setServer(MQTT_SERVER, 1883);

    while (!mqttClient.connected()) {

        Serial.print("Conectando MQTT...");

        if (mqttClient.connect("C2E2_GATEWAY")) {

            Serial.println("OK");

        } else {

            Serial.print("Falhou: ");
            Serial.println(mqttClient.state());

            delay(2000);
        }
    }
}
