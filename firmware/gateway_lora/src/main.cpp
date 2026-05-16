#include <Arduino.h>

#include "wifi_manager.h"
#include "mqtt_manager.h"
#include "lora_manager.h"

void setup() {

    Serial.begin(115200);
    delay(2000);

    Serial.println("=== C2E2 Gateway ===");

    Serial.println("Antes WiFi");

    conectaWiFi();

    Serial.println("Depois WiFi");

    conectaMQTT();

    Serial.println("Depois MQTT");

    iniciaLoRa();

    Serial.println("Gateway pronto");
}

void loop() {

    if(!mqttClient.connected()) {
        conectaMQTT();
    }

    mqttClient.loop();

    String str;

    int state = radio.receive(str);

    if(state == RADIOLIB_ERR_NONE) {

        Serial.println("Pacote LoRa:");
        Serial.println(str);

        mqttClient.publish(
            "c2e2/sensores/1",
            str.c_str()
        );

        Serial.println("Publicado MQTT");
    }
}