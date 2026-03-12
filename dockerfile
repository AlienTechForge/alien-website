# Stage 1: 安裝依賴
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Stage 2: 建置應用
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ARG RESEND_API_KEY
ENV RESEND_API_KEY=$RESEND_API_KEY
RUN npm run build

# Stage 3: 執行階段（僅包含 standalone 產出）
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
