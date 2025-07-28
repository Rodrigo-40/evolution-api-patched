# Dockerfile (na raiz do repo)

FROM atendai/evolution-api:v2.2.0

USER root

# Usando aspas simples no shell e aspas duplas no JS para evitar problemas
RUN node -e '\
  const fs = require("fs"); \
  const file = "/evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js"; \
  let src = fs.readFileSync(file, "utf8"); \
  /* remove async em close() */ \
  src = src.replace(/async close\(\)/g, "close()"); \
  /* remove await antes de this.socket.close() */ \
  src = src.replace(/await this\.socket\.close\(\)/g, "this.socket.close()"); \
  fs.writeFileSync(file, src); \
'

USER node
