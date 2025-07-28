# Dockerfile (na raiz do repo)
FROM atendai/evolution-api:v2.2.0

# 1) Torna-se root para poder alterar node_modules
USER root

# 2) Aplica o patch em websocket.js usando Node puro
RUN node -e " \
  const fs = require('fs'); \
  const file = '/evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js'; \
  let src = fs.readFileSync(file, 'utf8'); \
  /* remove async em close() */ \
  src = src.replace(/async close\\(\\)/g, 'close()'); \
  /* remove await antes de this.socket.close() */ \
  src = src.replace(/await this\\.socket\\.close\\(\\)/g, 'this.socket.close()'); \
  fs.writeFileSync(file, src); \
"

# 3) Volta a usuário não-root
USER node
