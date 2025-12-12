FROM node:18-alpine AS builder

WORKDIR /app

# Copier seulement les fichiers nécessaires au npm install
COPY package*.json ./

# Installer les dépendances
RUN npm ci --omit=dev

# Copier tout le code du frontend
COPY . .

# Construire l’application
RUN npm run build

# ---------------------------------------------------------------
# Phase NGINX pour servir les fichiers
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

