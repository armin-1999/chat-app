# آرمینگرام (armingram) - self-hosted messenger
# No native modules: SQLite comes from Node's built-in node:sqlite, so no compilers are needed.
FROM node:24-alpine
ENV NODE_ENV=production \
    PORT=3000 \
    DATA_DIR=/data \
    NODE_NO_WARNINGS=1 \
    RUN_AS_UID=1000 \
    RUN_AS_GID=1000
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY src ./src
COPY public ./public
RUN mkdir -p /data && chown -R node:node /data
# The server starts as root, chowns /data (bind mounts are often root-owned) and then
# drops to uid/gid 1000 (the 'node' user) before opening the database or the port.
VOLUME ["/data"]
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/api/health || exit 1
CMD ["node", "src/server.js"]
