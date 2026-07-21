FROM node:20-alpine

WORKDIR /app

# Install root dependencies (frontend)
COPY package*.json ./
RUN npm install

# Copy frontend source and compile
COPY build.js ./
COPY public ./public
COPY src ./src
COPY assets ./assets
RUN npm run build

# Install server dependencies (backend)
WORKDIR /app/server
COPY server/package*.json ./
RUN npm install --production
COPY server ./

# Run the unified server from root
WORKDIR /app
EXPOSE 4000
CMD ["npm", "run", "start:server"]
