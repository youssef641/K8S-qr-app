from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import qrcode
import os
from io import BytesIO
import validators
import hashlib

app = FastAPI()

# CORS Middleware Configuration
origins = [
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Directory to store QR codes locally
LOCAL_QR_DIR = "qr_codes"

# Ensure the directory exists
if not os.path.exists(LOCAL_QR_DIR):
    os.makedirs(LOCAL_QR_DIR)

# Serve static files from the qr_codes directory
app.mount("/static", StaticFiles(directory=LOCAL_QR_DIR), name="static")

@app.post("/generate-qr/")
async def generate_qr(url: str):
    # Validate the URL
    if not validators.url(url):
        raise HTTPException(status_code=400, detail="Invalid URL provided.")

    # Generate QR Code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    # Generate a unique file name using a hash of the URL
    hashed_url = hashlib.md5(url.encode()).hexdigest()
    file_name = f"{hashed_url}.png"
    file_path = os.path.join(LOCAL_QR_DIR, file_name)

    try:
        # Save the QR code image locally
        img.save(file_path, format='PNG')
        
        # Return the local file path
        return {"qr_code_path": f"/static/{file_name}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
