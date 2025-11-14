# -------- Base Image --------
FROM node:20-alpine

# -------- Set Work Directory --------
WORKDIR /app

# -------- Install Backend Dependencies --------
COPY backend/package.json backend/package-lock.json ./backend/
RUN cd backend && npm install

# -------- Copy Source Code --------
COPY backend ./backend

# -------- Generate Prisma Client --------
RUN cd backend && npx prisma generate

# -------- Expose Port --------
EXPOSE 10000

# -------- Start Backend Server --------
CMD ["node", "backend/server/index.js"]
