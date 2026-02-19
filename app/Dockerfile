# Stage 1: Builder
FROM python:3.12-slim AS builder

WORKDIR /build
# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Create a virtual environment inside the container so we can easily copy it to the next stage
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.12-slim AS runtime

# Create a non-root user and group for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app
# Copy only the built virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy the application code
COPY src/ ./src/

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appuser /app
# Switch to the non-root user
USER appuser

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]