# Use an official Python slim image as the base
FROM python:3.11-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first to leverage Docker's layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers and their system dependencies
RUN playwright install --with-deps chromium

# Copy the rest of your application code into the container
COPY . .

# Command to run the Uvicorn server
# This will listen on all interfaces (0.0.0.0) and use the port provided by Railway ($PORT)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]