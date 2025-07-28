USER root

# 1) Instala gnu‑sed (regex estendidas)
RUN apk update && apk add --no-cache gnu-sed

# 2) Patch Baileys: remove async/await em .close() para evitar uncaughtException
RUN gsed -i -E \
    '/class WebSocketClient/,/^}/s/async close\(\)[^{]*/close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && gsed -i -E \
    '/this\.socket\.close\(\)/!b;N;s/await this\.socket\.close\(\)/this.socket.close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js
