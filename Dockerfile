FROM ubuntu:24.04
ARG AUDIVERIS_VERSION=5.11.0
ENV DEBIAN_FRONTEND=noninteractive \
    AUDIVERIS_VERSION=${AUDIVERIS_VERSION} \
    OMR_WORKDIR=/tmp/emil-omr \
    PYTHONUNBUFFERED=1 \
    PATH=/opt/venv/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv python3-pip ca-certificates wget \
    openjdk-17-jre-headless tesseract-ocr \
    libgl1 libglib2.0-0 libx11-6 libxi6 libxext6 libxrender1 libxtst6 \
    libfreetype6 fonts-dejavu ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O /tmp/audiveris.deb \
    https://github.com/Audiveris/audiveris/releases/download/${AUDIVERIS_VERSION}/Audiveris-${AUDIVERIS_VERSION}-ubuntu24.04-x86_64.deb \
    && dpkg -i /tmp/audiveris.deb || (apt-get update && apt-get install -f -y && rm -rf /var/lib/apt/lists/*) \
    && rm -f /tmp/audiveris.deb

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel && \
    /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app
COPY omr-service.py /app/omr-service.py
COPY audio_transcriber.py /app/audio_transcriber.py

EXPOSE 8000
CMD ["/opt/venv/bin/uvicorn", "omr-service:app", "--host", "0.0.0.0", "--port", "8000"]
