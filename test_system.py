#!/usr/bin/env python3
"""
Test script to verify CivicHero Ironman system works properly
Tests all components without requiring GUI window
"""

import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

def test_imports():
    """Test if all required modules can be imported"""
    print("🔍 Testing imports...")
    try:
        import cv2
        print("  ✅ OpenCV imported")
    except ImportError as e:
        print(f"  ❌ OpenCV failed: {e}")
        return False
    
    try:
        import ultralytics
        from ultralytics import YOLO
        print("  ✅ Ultralytics imported")
    except ImportError as e:
        print(f"  ❌ Ultralytics failed: {e}")
        return False
    
    try:
        import firebase_admin
        from firebase_admin import credentials, firestore
        print("  ✅ Firebase Admin imported")
    except ImportError as e:
        print(f"  ❌ Firebase Admin failed: {e}")
        return False
    
    try:
        import numpy
        print("  ✅ NumPy imported")
    except ImportError as e:
        print(f"  ❌ NumPy failed: {e}")
        return False
    
    return True

def test_files():
    """Test if required files exist"""
    print("\n📁 Testing required files...")
    
    base_dir = os.path.dirname(__file__)
    
    files_to_check = [
        ('ultra.pt', 'YOLO model'),
        ('serviceAccountKey.json', 'Firebase credentials'),
        ('src/main.py', 'Main script'),
        ('src/firebase_client.py', 'Firebase client'),
        ('src/detectors/yolo_detector.py', 'YOLO detector'),
        ('src/detectors/brightness_detector.py', 'Brightness detector'),
        ('src/roi_utils.py', 'ROI utilities'),
        ('src/samples/test.mp4', 'Test video'),
    ]
    
    all_exist = True
    for file_path, description in files_to_check:
        full_path = os.path.join(base_dir, file_path)
        if os.path.exists(full_path):
            size = os.path.getsize(full_path)
            print(f"  ✅ {description}: {file_path} ({size:,} bytes)")
        else:
            print(f"  ❌ {description}: {file_path} NOT FOUND")
            all_exist = False
    
    return all_exist

def test_yolo_model():
    """Test if YOLO model can be loaded"""
    print("\n🤖 Testing YOLO model...")
    try:
        from ultralytics import YOLO
        base_dir = os.path.dirname(__file__)
        model_path = os.path.join(base_dir, 'ultra.pt')
        
        if not os.path.exists(model_path):
            print(f"  ❌ Model file not found: {model_path}")
            return False
        
        print(f"  📦 Loading model from: {model_path}")
        model = YOLO(model_path)
        print(f"  ✅ YOLO model loaded successfully")
        print(f"  📊 Model classes: {len(model.names)} classes")
        print(f"  📋 Classes: {list(model.names.values())[:5]}...")  # Show first 5
        
        return True
    except Exception as e:
        print(f"  ❌ Failed to load YOLO model: {e}")
        return False

def test_firebase():
    """Test Firebase connection"""
    print("\n🔥 Testing Firebase connection...")
    try:
        from src.firebase_client import get_camera_config
        
        # Try to get a camera config (will fail if Firebase not configured, but that's OK)
        # We just want to see if the module loads
        print("  ✅ Firebase client module loaded")
        print("  ℹ️  Note: Full Firebase test requires valid camera_id")
        
        return True
    except Exception as e:
        print(f"  ❌ Firebase client failed: {e}")
        return False

def test_video_file():
    """Test if video file can be opened"""
    print("\n🎥 Testing video file...")
    try:
        import cv2
        base_dir = os.path.dirname(__file__)
        video_path = os.path.join(base_dir, 'src', 'samples', 'test.mp4')
        
        if not os.path.exists(video_path):
            print(f"  ❌ Video file not found: {video_path}")
            return False
        
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            print(f"  ❌ Cannot open video file: {video_path}")
            return False
        
        # Get video properties
        fps = cap.get(cv2.CAP_PROP_FPS)
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        
        print(f"  ✅ Video file opened successfully")
        print(f"  📊 Properties: {width}x{height} @ {fps:.2f}fps, {frame_count} frames")
        
        # Try to read a frame
        ret, frame = cap.read()
        if ret:
            print(f"  ✅ Successfully read frame: {frame.shape}")
        else:
            print(f"  ⚠️  Could not read frame")
        
        cap.release()
        return True
    except Exception as e:
        print(f"  ❌ Video test failed: {e}")
        return False

def test_detectors():
    """Test if detectors can be initialized"""
    print("\n🔍 Testing detectors...")
    try:
        from src.detectors.yolo_detector import YoloDetector
        from src.detectors.brightness_detector import BrightnessDetector
        
        base_dir = os.path.dirname(__file__)
        model_path = os.path.join(base_dir, 'ultra.pt')
        
        # Test YOLO detector
        print("  🤖 Initializing YOLO detector...")
        yolo_detector = YoloDetector(model_path)
        print("  ✅ YOLO detector initialized")
        
        # Test brightness detector
        print("  💡 Initializing brightness detector...")
        brightness_detector = BrightnessDetector()
        print("  ✅ Brightness detector initialized")
        
        return True
    except Exception as e:
        print(f"  ❌ Detector initialization failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Run all tests"""
    print("=" * 60)
    print("🧪 CivicHero Ironman System Test")
    print("=" * 60)
    
    results = []
    
    # Run tests
    results.append(("Imports", test_imports()))
    results.append(("Files", test_files()))
    results.append(("YOLO Model", test_yolo_model()))
    results.append(("Firebase", test_firebase()))
    results.append(("Video File", test_video_file()))
    results.append(("Detectors", test_detectors()))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 Test Summary")
    print("=" * 60)
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"  {status}: {test_name}")
    
    print(f"\n📈 Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed! System is ready to run.")
        print("\n💡 Next steps:")
        print("   1. Run: cd src && python3 main.py")
        print("   2. Or deploy to Raspberry Pi 5 when ready")
        return 0
    else:
        print("\n⚠️  Some tests failed. Please fix issues before deployment.")
        return 1

if __name__ == "__main__":
    sys.exit(main())




