FROM node:18-alpine

WORKDIR /app

# Copier les fichiers backend
COPY backend/package*.json ./
RUN npm install

COPY backend ./

EXPOSE 5000
CMD ["npm", "start"]

