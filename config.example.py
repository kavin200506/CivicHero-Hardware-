"""
Configuration Template for CivicHero Ironman
Copy this file to config.py and update with your settings
"""

# Firebase Configuration
CAMERA_ID = "your-camera-id-from-firebase"  # Get from Admin Dashboard > Cameras

# Video Source Configuration
# Options:
#   - "pi" or "picamera": Use Raspberry Pi Camera Module
#   - 0, 1, 2: USB camera index
#   - "rtsp://user:pass@ip:port/stream": RTSP stream URL
#   - "path/to/video.mp4": Local video file
VIDEO_SOURCE = 0  # Change to your camera source

# YOLO Model Path (relative to Ironman folder)
YOLO_MODEL_PATH = "ultra.pt"

# Detection Settings
DETECTION_INTERVAL = 5  # Process every N frames (higher = less CPU usage)
CONFIDENCE_THRESHOLD = 0.4  # YOLO confidence threshold (0.0-1.0)

# Reporting Settings
REPORT_COOLDOWN = 60  # Seconds between reports for same ROI (prevents duplicates)
COOLDOWN_FILE = "last_reported.json"  # File to store cooldown timestamps

# Video Display Settings
SHOW_DEBUG_WINDOW = True  # Set to False for headless operation
WINDOW_NAME = "CivicHeroH Edge Debug"

# Performance Settings (for Raspberry Pi)
VIDEO_WIDTH = 1920  # Camera resolution width
VIDEO_HEIGHT = 1080  # Camera resolution height
VIDEO_FPS = 30  # Frames per second

# Firebase Storage
STORAGE_BUCKET = "civicissue-aae6d.firebasestorage.app"  # Your Firebase Storage bucket

# Logging
ENABLE_LOGGING = True
LOG_FILE = "logs/ironman.log"  # Log file path




