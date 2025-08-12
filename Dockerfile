# Use official Python image as base
FROM python:3.9-slim

# Set working directory in container
WORKDIR /app

# Copy requirements first (for better caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY app.py .


# Set default environment variables
#ENV PYTHONUNBUFFERED=1 \
    #PORT=8000

# Expose the port the app runs on
EXPOSE 80

# Command to run the application
CMD ["python", "/app.py"]
