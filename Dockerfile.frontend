# Étape 1 : Build du frontend
FROM node:18-alpine AS builder

WORKDIR /app

# Copier uniquement les fichiers du frontend
COPY frontend/package*.json ./

# Installer les dépendances
RUN npm ci --omit=dev

# Copier tout le code du frontend
COPY frontend/ .

# Construire l’application
RUN npm run build

# Étape 2 : Serveur web Nginx
FROM nginx:alpine

# Copier le build dans nginx
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

