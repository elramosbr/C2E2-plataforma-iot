#include <WiFi.h>
#include <Arduino.h>

#include "wifi_manager.h"
#include "secrets.h"

void conectaWiFi() {

    Serial.print("Conectando WiFi");

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }

    Serial.println("");
    Serial.println("WiFi conectado");
    Serial.println(WiFi.localIP());
}
