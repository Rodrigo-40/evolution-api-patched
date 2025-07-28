# Dockerfile
FROM atendai/evolution-api:v2.2.0

USER root

# instala GNU sed (para usar gsed)
RUN apk update && apk add --no-cache gnu-sed

# patch no WebSocketClient para remover async close() e await que causam uncaughtException
RUN gsed -i -E '/class WebSocketClient/,/^}/s/async close\(\)/close()/' /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && gsed -i -E '/this\.socket\.close\(\)/!b;N;s/await this\.socket\.close\(\)/this.socket.close()/' /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# volta ao usuário padrão (opcional)
USER node
