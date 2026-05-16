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
