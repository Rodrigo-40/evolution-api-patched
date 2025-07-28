# Dockerfile (raiz do repo)

# 1) Base leve com node
FROM node:18-alpine AS builder
WORKDIR /app

# 2) Copia só o package.json e o lock para instalar deps
COPY package.json package-lock.json ./
RUN npm ci                # instaura devDependencies (inclui patch‑package)

# 3) Copia todo o resto do código (inclui patches/)
COPY . .

# 4) Aplica os patches (gerado pelo patch‑package)
RUN npx patch-package

# 5) (se você tiver build step, exemplo NestJS/TS)
#    ajuste esse comando para o seu build real
RUN npm run build

# -------------------------------------------------------------------------

# 6) Faz a imagem final a partir do builder
FROM node:18-alpine
WORKDIR /app

# 7) Copia só o que precisa para rodar
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# 8) Porta padrão (ajuste se for outra)
EXPOSE 3000

# 9) Comando de runtime (ajuste conforme seu start:prod)
CMD ["node", "dist/main"]
