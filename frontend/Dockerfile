FROM node:18-alpine AS builder

WORKDIR /app

# Copier uniquement les fichiers npm
COPY package*.json ./

# Installer les dépendances
RUN npm ci --omit=dev

# Copier TOUT le code du frontend (contexte = frontend/)
COPY . .

# Build de l’application
RUN npm run build

# ------------------ PHASE NGINX ------------------

FROM nginx:alpine

# Adapter dist/build selon ton framework
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

