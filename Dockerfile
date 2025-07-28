# Dockerfile na raiz do repo

FROM atendai/evolution-api:v2.2.0

USER root

# instala o sed (busybox) e aplica o patch em duas etapas
RUN apk add --no-cache sed \
 && sed -i '/class WebSocketClient/,/}/ s/async close()/close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && sed -i '/class WebSocketClient/,/}/ s/await this\.socket\.close()/this.socket.close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

USER node
