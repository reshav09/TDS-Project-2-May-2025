# Use an official Python slim image as the base
FROM python:3.11-slim

# Set environment variables for Python
ENV PYTHONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# ❗ FIX: Manually install system dependencies for Playwright
# This is crucial for running a headless browser in a slim Docker container.
RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    fonts-unifont \
    fonts-liberation \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first to leverage Docker's layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install only the browser, as we've already installed the system dependencies
RUN playwright install chromium

# Copy the rest of your application code into the container
COPY . .

# ❗ FIX: This is the correct command to run the Uvicorn server on Railway.
# It tells Uvicorn to listen on the port provided by Railway via the $PORT variable.
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT