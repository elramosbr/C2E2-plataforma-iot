# Procedimento de Inicialização do Banco.

Sempre que um Raspberry novo for preparado, a sequência deverá ser:

1. git clone

2. git pull

3. sqlite3 c2e2.db

4. .read schema/001_schema.sql

5. .read schema/002_indexes.sql

6. .read schema/003_views.sql

7. .read seeds/gateway.sql

8. .read seeds/sensores.sql

9. iniciar Node-RED