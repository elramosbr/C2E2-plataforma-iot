#include <Arduino.h>
#include <RadioLib.h>

SX1262 radio = new Module(8, 14, 12, 13);

int contador = 0;

void setup() {

    Serial.begin(115200);
    delay(2000);

    Serial.println("=== C2E2 TX ===");

    int state = radio.begin(903.875);

    if(state != RADIOLIB_ERR_NONE) {

        Serial.print("Erro LoRa: ");
        Serial.println(state);

        while(true);
    }

    Serial.println("LoRa TX OK");
}

void loop() {

    String payload = "{";
    payload += "\"id\":1,";
    payload += "\"msg\":\"HELLO\",";
    payload += "\"count\":";
    payload += contador;
    payload += "}";

    Serial.println("Transmitindo:");
    Serial.println(payload);

    int state = radio.transmit(payload);

    if(state == RADIOLIB_ERR_NONE) {

        Serial.println("TX OK");

    } else {

        Serial.print("Erro TX: ");
        Serial.println(state);
    }

    contador++;

    delay(3000);
}