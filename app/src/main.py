from fastapi import FastAPI, Response, status
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
import time

# Initialize tracing pipeline
provider = TracerProvider()
processor = BatchSpanProcessor(ConsoleSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

# We version the app for use when doing Helm rollouts and GitOps syncing.
app = FastAPI(title="Capstone Telemetry Service", version="0.1.0")

# Instrument the FastAPI app
FastAPIInstrumentor.instrument_app(app)

@app.get("/")
async def root():
    return {"message": "Traffic generator active"}

@app.get("/health")
async def health_check():
    # Kubernetes pings this endpoint to make sure the pod is alive
    return {"status": "healthy"}

@app.get("/cpu-stress")
async def cpu_stress():
    # Simulate heavy computation for HPA load testing
    end_time = time.time() + 0.5 # Burn CPU for 0.5 seconds
    while time.time() < end_time:
        pass
    return {"message": "CPU stress complete"}