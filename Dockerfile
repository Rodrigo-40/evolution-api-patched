# Dockerfile (na raiz do repo)
FROM atendai/evolution-api:v2.2.0

# 1) Troca para root pra poder instalar e editar arquivos
USER root

# 2) Instala o sed GNU (Debian/Ubuntu)
RUN apt-get update \
 && apt-get install -y sed \
 && rm -rf /var/lib/apt/lists/*

# 3) Aplica o patch no WebSocketClient do baileys
#    - remove a palavra-chave async de close()
#    - remove await antes de this.socket.close()
RUN sed -i \
    -E 's/\basync close\(\)/close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && sed -i \
    -E 's/await this\.socket\.close\(\)/this.socket.close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# 4) Volta pro usuário padrão (node) e expõe a porta padrão
USER node
