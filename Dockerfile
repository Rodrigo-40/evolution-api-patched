FROM atendai/evolution-api:v2.2.0

# como a imagem é Alpine, instalamos sed
USER root
RUN apk update && apk add --no-cache sed

# volta pra user não-root
USER node

# no ENTRYPOINT, antes de iniciar a API,
# removemos async/await de close()
ENTRYPOINT [ "/bin/sh", "-c", "\
  sed -i -E 's/async[[:space:]]+close\\(\\)/close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js && \
  sed -i -E 's/await this\\.socket\\.close\\(\\)/this.socket.close()/' \
    /evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js && \
  exec node dist/main" ]
