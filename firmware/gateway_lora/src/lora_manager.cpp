#include <Arduino.h>
#include <RadioLib.h>

#include "lora_manager.h"
#include "config.h"

SX1262 radio = new Module(8, 14, 12, 13);

void iniciaLoRa() {

    Serial.println("Inicializando LoRa...");

    int state = radio.begin(LORA_FREQUENCY);

    if(state != RADIOLIB_ERR_NONE) {

        Serial.print("Erro LoRa: ");
        Serial.println(state);

        while(true);
    }

    radio.setOutputPower(10);

    Serial.println("LoRa OK");
}
