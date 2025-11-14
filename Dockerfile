# Use a slim Python image
FROM python:3.12-slim

WORKDIR /app

# Install system dependencies (if needed)
RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Set environment variables
ENV PORT 10000

# Expose port
EXPOSE 10000

# Run database migrations (if using prisma) and start server
CMD ["bash", "-c", "npx prisma migrate deploy && uvicorn main:app --host 0.0.0.0 --port $PORT"]

# Base image
FROM python:3.12-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y gcc g++ && rm -rf /var/lib/apt/lists/*

# Copy backend code
COPY backend/ ./backend/

# Install Python dependencies
COPY backend/requirements.txt ./backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Install Node + Prisma binaries
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Copy Prisma schema
COPY backend/prisma ./backend/prisma

# Generate Prisma client
RUN cd backend && npx prisma generate

# Run migrations
RUN cd backend && npx prisma migrate deploy

# Expose port
EXPOSE 10000

# Start FastAPI server
CMD ["python3", "backend/main.py"]

