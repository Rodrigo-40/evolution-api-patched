FROM atendai/evolution-api:v2.2.0

USER root

# Patch Baileys para tornar close() síncrono e evitar o uncaughtException
RUN sed -i '/class WebSocketClient/,/^}/s/async close()[^{]*/close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js && \
    sed -i '/this.socket.close()/!b;N; s/await this.socket.close()/this.socket.close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js
