# 1) Puxamos a imagem oficial v2.2.0 do Evolution API
FROM atendai/evolution-api:v2.2.0

# 2) Como a base é Alpine, usamos apk para instalar o GNU sed
USER root
RUN apk update && \
    apk add --no-cache sed

# 3) Aplica o patch no WebSocketClient para remover async/await de close()
RUN sed -i -E 's/class WebSocketClient/,/^}/s/async close\(\)/close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js && \
    sed -i -E 's/await this\.socket\.close\(\)/this.socket.close()/g' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# 4) Volta ao usuário padrão
USER node
