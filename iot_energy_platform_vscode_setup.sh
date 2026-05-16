#!/bin/bash

# =========================================================
# C2E2 - VSCode Project Setup
# Target:
#   ESP32 + LoRa + MQTT + FastAPI + Raspberry Pi
# =========================================================

set -e

PROJECT_NAME="c2e2-plataforma-iot"

echo "========================================="
echo "Creating project structure..."
echo "========================================="

mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# =========================================================
# ROOT FILES
# =========================================================

touch README.md
cat > .gitignore << 'EOF'
# =========================
# Python
# =========================
__pycache__/
*.pyc
.venv/
.env

# =========================
# PlatformIO
# =========================
.pio/
.vscode/.browse.c_cpp.db*
.vscode/c_cpp_properties.json

# =========================
# Flutter
# =========================
.dart_tool/
build/
.flutter-plugins
.flutter-plugins-dependencies
.packages

# =========================
# Node
# =========================
node_modules/

# =========================
# OS
# =========================
.DS_Store
Thumbs.db

# =========================
# Logs
# =========================
*.log

# =========================
# Database
# =========================
*.db
*.sqlite

EOF

# =========================================================
# DOCS
# =========================================================

mkdir -p docs/{arquitetura,diagramas,esquematicos,tcc,imagens,apresentacao}

# =========================================================
# HARDWARE
# =========================================================

mkdir -p hardware/{kicad,esquemas,pcb,componentes,datasheets}

# =========================================================
# FIRMWARE
# =========================================================

mkdir -p firmware/no_sensor/{src,include,lib,test}
mkdir -p firmware/gateway_lora/{src,include,lib,test}

# PlatformIO - Sensor Node
cat > firmware/no_sensor/platformio.ini << 'EOF'
[env:heltec_wifi_lora_32_V3]
platform = espressif32
board = esp32-s3-devkitc-1
framework = arduino
monitor_speed = 115200
upload_speed = 115200

lib_deps =
    jgromes/RadioLib
    bblanchon/ArduinoJson
EOF

# PlatformIO - Gateway Node
cat > firmware/gateway_lora/platformio.ini << 'EOF'
[env:heltec_wifi_lora_32_V3]
platform = espressif32
board = esp32-s3-devkitc-1
framework = arduino
monitor_speed = 115200
upload_speed = 115200

lib_deps =
    jgromes/RadioLib
    knolleary/PubSubClient
    bblanchon/ArduinoJson
EOF

# =========================================================
# E2.1 - GATEWAY LORA -> WIFI -> MQTT
# =========================================================

mkdir -p firmware/gateway_lora/src

# CONFIG
cat > firmware/gateway_lora/src/config.h << 'EOF'
#ifndef CONFIG_H
#define CONFIG_H

#define LORA_FREQUENCY 903.875
#define MQTT_PORT 1883
#define MQTT_TOPIC_BASE "c2e2/sensores/"

#endif
EOF

# SECRETS
cat > firmware/gateway_lora/src/secrets.h << 'EOF'
#ifndef SECRETS_H
#define SECRETS_H

const char* WIFI_SSID = "SEU_WIFI";
const char* WIFI_PASSWORD = "SUA_SENHA";

const char* MQTT_SERVER = "192.168.1.104";

#endif
EOF

# WIFI MANAGER H
cat > firmware/gateway_lora/src/wifi_manager.h << 'EOF'
#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

void conectaWiFi();

#endif
EOF

# WIFI MANAGER CPP
cat > firmware/gateway_lora/src/wifi_manager.cpp << 'EOF'
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
EOF

# MQTT MANAGER H
cat > firmware/gateway_lora/src/mqtt_manager.h << 'EOF'
#ifndef MQTT_MANAGER_H
#define MQTT_MANAGER_H

#include <PubSubClient.h>

extern PubSubClient mqttClient;

void conectaMQTT();

#endif
EOF

# MQTT MANAGER CPP
cat > firmware/gateway_lora/src/mqtt_manager.cpp << 'EOF'
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
EOF

# LORA MANAGER H
cat > firmware/gateway_lora/src/lora_manager.h << 'EOF'
#ifndef LORA_MANAGER_H
#define LORA_MANAGER_H

#include <RadioLib.h>

extern SX1262 radio;

void iniciaLoRa();

#endif
EOF

# LORA MANAGER CPP
cat > firmware/gateway_lora/src/lora_manager.cpp << 'EOF'
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
EOF

# MAIN GATEWAY
cat > firmware/gateway_lora/src/main.cpp << 'EOF'
#include <Arduino.h>

#include "wifi_manager.h"
#include "mqtt_manager.h"
#include "lora_manager.h"

void setup() {

    Serial.begin(115200);
    delay(2000);

    Serial.println("=== C2E2 Gateway ===");

    conectaWiFi();

    conectaMQTT();

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
EOF

# Sensor main.cpp
cat > firmware/no_sensor/src/main.cpp << 'EOF'
#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    Serial.println("C2E2 - Nó Sensor Inicializado");
}

void loop() {
    delay(1000);
}
EOF

# Gateway main.cpp
cat > firmware/gateway_lora/src/main.cpp << 'EOF'
#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    Serial.println("C2E2 - Gateway LoRa Inicializado");
}

void loop() {
    delay(1000);
}
EOF

# =========================================================
# BACKEND
# =========================================================

mkdir -p backend/app/{api,servicos,mqtt,modelos,banco_dados,ml}

cat > backend/requirements.txt << 'EOF'
fastapi
uvicorn
paho-mqtt
sqlalchemy
psycopg2-binary
pandas
numpy
scikit-learn
tensorflow
prophet
EOF

cat > backend/app/main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"status": "IoT Energy Platform Backend Running"}
EOF

# =========================================================
# DATABASE
# =========================================================

mkdir -p database/{migrations,schema,seeds,backups}

# =========================================================
# DASHBOARD
# =========================================================

mkdir -p dashboard/{grafana,exports,web}

# =========================================================
# MOBILE
# =========================================================

mkdir -p mobile/{android,ios,lib,assets}

# =========================================================
# DOCKER
# =========================================================

mkdir -p docker/{mosquitto,postgres,grafana,compose}

cat > docker/compose/docker-compose.yml << 'EOF'
version: '3.9'

services:

  mosquitto:
    image: eclipse-mosquitto
    ports:
      - "1883:1883"
    volumes:
      - ../mosquitto:/mosquitto/config

  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: energy
      POSTGRES_PASSWORD: energy123
      POSTGRES_DB: energydb
    ports:
      - "5432:5432"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
EOF

# =========================================================
# DATASETS
# =========================================================

mkdir -p datasets/{raw,processed,predictions}

# =========================================================
# TESTS
# =========================================================

mkdir -p tests/{firmware,backend,integration}

# =========================================================
# SCRIPTS
# =========================================================

mkdir -p scripts

cat > scripts/start_backend.sh << 'EOF'
#!/bin/bash
cd backend
uvicorn app.main:app --reload
EOF

chmod +x scripts/start_backend.sh

# =========================================================
# RESEARCH
# =========================================================

mkdir -p research/{artigos,referencias,anotacoes}

# =========================================================
# VSCODE
# =========================================================

mkdir -p .vscode

cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "platformio.platformio-ide",
        "ms-python.python",
        "ms-azuretools.vscode-docker",
        "dart-code.flutter",
        "dart-code.dart-code",
        "mhutchie.git-graph"
    ]
}
EOF

cat > .vscode/settings.json << 'EOF'
{
    "editor.formatOnSave": true,
    "files.autoSave": "afterDelay",
    "terminal.integrated.defaultProfile.windows": "PowerShell"
}
EOF

# =========================================================
# README
# =========================================================

cat > README.md << 'EOF'
# IoT Energy Platform

Plataforma integrada IoT para monitoramento e otimização do consumo energético utilizando:

- ESP32-S3
- LoRa SX1262
- MQTT
- FastAPI
- PostgreSQL / TimescaleDB
- Grafana
- Flutter

## Architecture

Nós Sensores -> LoRa -> Gateway -> MQTT -> Backend -> Dashboard
EOF

# =========================================================
# GIT INIT
# =========================================================

git init

echo "========================================="
echo "Estrutura do projeto C2E2 criada com sucesso!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Open folder in VSCode"
echo "2. Install recommended extensions"
echo "3. Install PlatformIO"
echo "4. Test sensor-node upload"
echo "5. Configure Docker + Mosquitto"
echo ""
