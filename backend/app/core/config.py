import os


class Settings:
    APP_NAME = "C2E2 API"
    APP_VERSION = "0.1.0"

    DATABASE_PATH = os.getenv(
        "C2E2_DB_PATH",
        "../database/c2e2.db"
    )


settings = Settings()