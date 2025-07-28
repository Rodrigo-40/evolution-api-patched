# Dockerfile (na raiz do repo)
FROM atendai/evolution-api:v2.2.0

# 1) Muda para root pra ter permissão de instalar pacotes
USER root

# 2) Instala GNU sed (o Alpine vem só com busybox-sed)
RUN apk update \
 && apk add --no-cache gnu-sed \
 && rm -rf /var/cache/apk/*

# 3) Aplica o patch no WebSocketClient do baileys:
#    - remove "async" de close()
#    - remove "await" antes de this.socket.close()
RUN gsed -i -E 's/\basync close\(\)/close()/g' \
      /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js \
 && gsed -i -E 's/await this\.socket\.close\(\)/this.socket.close()/g' \
      /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js

# 4) Volta para o usuário não-root (node)
USER node
