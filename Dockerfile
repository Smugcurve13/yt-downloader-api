FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# copy requirements and install
COPY requirements.txt ./
RUN python -m pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# copy optional cookies file (if provided) and application
# copying cookies separately helps cache layers when cookies change infrequently
COPY cookies.txt /app/cookies.txt
COPY . /app

EXPOSE 8000

# Use uvicorn to run the app (production: no reload)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
