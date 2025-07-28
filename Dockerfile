FROM atendai/evolution-api:v2.2.0
USER root

# Patch Baileys: troca async close()/await this.socket.close() por versões síncronas
RUN sed -i \
    -e 's/async close()/close()/g' \
    -e 's/await this.socket.close()/this.socket.close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js || true
