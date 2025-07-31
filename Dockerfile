# Dockerfile optimizado para el proyecto de visualización molecular
FROM python:3.11-slim

# Etiquetas del proyecto
LABEL maintainer="tu-email@ejemplo.com"
LABEL description="Sistema de Visualización Molecular con RDKit + Gestos + IA"
LABEL version="1.0.0"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV FLASK_APP=main.py
ENV FLASK_ENV=production

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    # Para OpenCV
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libglib2.0-0 \
    # Para MediaPipe
    libgoogle-glog0v5 \
    # Utilidades generales
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements primero (para cache de Docker)
COPY requirements.txt .

# Instalar dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código
COPY . .

# Crear directorios necesarios
RUN mkdir -p static/uploads static/molecules logs

# Configurar permisos
RUN chmod +x main.py

# Exponer puerto
EXPOSE 8080

# Comando de inicio
CMD ["python", "main.py"]