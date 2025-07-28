# Dockerfile (na raiz do repo)
FROM atendai/evolution-api:v2.2.0

USER root

# 1) Instalação do sed (Debian/Ubuntu já vem com o sed GNU)
RUN apt-get update && apt-get install -y sed \
    && rm -rf /var/lib/apt/lists/*

# 2) Aplica o patch no WebSocketClient para remover async/await de close()
RUN sed -i -E '/class WebSocketClient/,/^}/s/async close\(\)/close()/' /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && sed -i -E 's/await this\.socket\.close\(\)/this.socket.close()/g' /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# volta ao usuário não-root
USER node
