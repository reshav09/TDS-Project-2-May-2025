import logging
from fastapi import FastAPI
from app.api import router as api_router
from core.config import API_TITLE, API_VERSION, API_DESCRIPTION

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler("app.log")],
)
logger = logging.getLogger(__name__)

# Initialize the FastAPI app
app = FastAPI(
    title=API_TITLE,
    description=API_DESCRIPTION,
    version=API_VERSION,
)

# Include the API router
app.include_router(api_router, prefix="/api")

@app.get("/")
async def root():
    """
    Root endpoint for the API.
    """
    return {
        "message": "Welcome to the Data Analysis Platform!",
        "title": API_TITLE,
        "version": API_VERSION,
        "description": API_DESCRIPTION,
    }

@app.get("/health")
async def health_check():
    """
    Health check endpoint.
    """
    return {"status": "ok"}