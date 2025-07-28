# Na raiz do repo, arquivo chamado Dockerfile

FROM atendai/evolution-api:v2.2.0

# Precisamos de root para escrever dentro do node_modules
USER root

# 1) Instala o sed (busybox) e já aplica o patch dentro do mesmo RUN:
RUN apk add --no-cache sed \
 && sed -i '\|class WebSocketClient|,\|^}|{ \
      s|async close()|close()|g; \
      s|await this\.socket\.close()|this.socket.close()|g \
    }' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# Volta para o usuário não-root
USER node
