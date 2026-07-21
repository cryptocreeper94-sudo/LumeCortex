FROM node:20-alpine

WORKDIR /app

# Install root dependencies (frontend)
COPY package*.json ./
RUN npm install

# Copy everything else (respects .dockerignore)
COPY . .

# Run frontend build (build.js)
RUN npm run build && \
    cp *.html dist/ && \
    cp manifest.json sw.js cortex-bridge.js ecosystem-badge.js dist/ && \
    cp *.png *.mp4 dist/ || true && \
    cp -r assets dist/assets || true && \
    cp -r public/* dist/ || true

# Install server dependencies (backend)
WORKDIR /app/server
RUN npm install --production

# Run the unified server from root
WORKDIR /app
EXPOSE 4000
CMD ["npm", "run", "start:server"]
