# Dockerfile (na raiz do repo)
FROM atendai/evolution-api:v2.2.0

# preciso de root pra editar node_modules
USER root

# 1) Aplica patch em websocket.js via Node, trocando async/await close() por close()
RUN node -e '
  const fs = require("fs");
  const file = "/evolution/node_modules/@adiwajshing/baileys/lib/Socket/Client/websocket.js";
  let src = fs.readFileSync(file, "utf8");
  // remove "async " antes de close()
  src = src.replace(/async close\(\)/g, "close()");
  // remove await neste trecho específico
  src = src.replace(/await this\.socket\.close\(\)/g, "this.socket.close()");
  fs.writeFileSync(file, src);
'

# volta a usar usuário não-root
USER node
