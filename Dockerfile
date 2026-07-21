FROM node:20-alpine

WORKDIR /app

# Install root dependencies (frontend)
COPY package*.json ./
RUN npm install

# Copy everything else (respects .dockerignore)
COPY . .

# Run frontend build (build.js)
RUN npm run build

# Install server dependencies (backend)
WORKDIR /app/server
RUN npm install --production

# Run the unified server from root
WORKDIR /app
EXPOSE 4000
CMD ["npm", "run", "start:server"]
