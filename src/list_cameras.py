#!/usr/bin/env python3
"""
List all available cameras on the system
Helps identify which camera index corresponds to which camera
"""

import cv2
import sys

def list_cameras():
    """Try to open cameras and identify them"""
    print("🔍 Scanning for available cameras...\n")
    
    available_cameras = []
    
    # Try indices 0-10 (most systems won't have more than this)
    for i in range(11):
        cap = cv2.VideoCapture(i)
        if cap.isOpened():
            # Try to read a frame to confirm it's working
            ret, frame = cap.read()
            if ret and frame is not None:
                # Get camera properties
                width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
                height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
                fps = cap.get(cv2.CAP_PROP_FPS)
                
                # Try to get backend name (may not work on all systems)
                backend = cap.getBackendName()
                
                available_cameras.append({
                    'index': i,
                    'width': width,
                    'height': height,
                    'fps': fps,
                    'backend': backend
                })
                
                print(f"✅ Camera {i}:")
                print(f"   Resolution: {width}x{height}")
                print(f"   FPS: {fps}")
                print(f"   Backend: {backend}")
                print()
            
            cap.release()
    
    if not available_cameras:
        print("❌ No cameras found!")
        return
    
    print(f"\n📊 Summary: Found {len(available_cameras)} camera(s)")
    print("\n💡 Tips:")
    print("   - Camera 0 is usually the first/default camera (often OBS Virtual Camera)")
    print("   - Camera 1 is often the Mac's built-in camera")
    print("   - Try different indices in main.py: VIDEO_SOURCE = 1, 2, etc.")
    print("\n🔧 To use a specific camera, edit main.py and change:")
    print("   VIDEO_SOURCE = 0  # Change 0 to the camera index you want")
    
    return available_cameras

if __name__ == "__main__":
    try:
        list_cameras()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
        sys.exit(0)


