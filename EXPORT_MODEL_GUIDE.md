# Model Export Guide for Raspberry Pi 5

Guide for exporting and optimizing your YOLO model for Raspberry Pi 5 deployment.

## 🎯 Best Export Format: ONNX

**Recommended**: Export to **ONNX** format for Raspberry Pi 5.

### Why ONNX?

✅ **Faster inference** than PyTorch on ARM processors  
✅ **Optimized for edge devices** with ONNX Runtime  
✅ **Cross-platform** compatibility  
✅ **Smaller model size** in some cases  
✅ **Better CPU utilization** on Raspberry Pi  

---

## 📋 Export Options Comparison

| Format | Speed | Size | Pi 5 Support | Recommendation |
|--------|-------|------|--------------|----------------|
| **ONNX** | ⭐⭐⭐⭐ | Medium | ✅ Excellent | **Best Choice** |
| **TensorFlow Lite** | ⭐⭐⭐⭐⭐ | Small | ✅ Excellent | Great for edge |
| **PyTorch (.pt)** | ⭐⭐⭐ | Large | ✅ Works | Current (OK) |
| **TorchScript** | ⭐⭐⭐ | Medium | ✅ Works | Good alternative |
| **TensorRT** | ⭐⭐⭐⭐⭐ | Small | ❌ No GPU | Not for Pi 5 |
| **CoreML** | ⭐⭐⭐⭐ | Small | ❌ Apple only | Not for Pi 5 |

---

## 🚀 How to Export to ONNX

### Method 1: Using Python Script

```python
from ultralytics import YOLO

# Load your model
model = YOLO('ultra.pt')

# Export to ONNX
model.export(
    format='onnx',
    imgsz=640,  # Input image size
    simplify=True,  # Simplify ONNX model
    opset=12  # ONNX opset version (12 is widely supported)
)

# This creates: ultra.onnx
```

### Method 2: Using Command Line

```bash
# Basic export
yolo export model=ultra.pt format=onnx

# With options
yolo export model=ultra.pt format=onnx imgsz=640 simplify=True opset=12
```

### Method 3: Using Ultralytics Web Interface

1. Open your model in Ultralytics
2. Go to **Export** tab
3. Select **ONNX**
4. Click **Export**

---

## 📦 Installing ONNX Runtime

After exporting, install ONNX Runtime on your Pi:

```bash
# On Raspberry Pi 5
pip install onnxruntime

# Or for better performance (if available):
pip install onnxruntime-gpu  # Only if you have GPU
```

---

## 🔄 Updating Your Code

### Option 1: Keep Current PyTorch (Easiest)

**No changes needed!** Your current `.pt` model works fine.

**Pros:**
- Already working
- No conversion needed
- Simple

**Cons:**
- May be slower than ONNX
- Larger model size

### Option 2: Switch to ONNX (Recommended for Performance)

1. **Export model to ONNX** (see above)

2. **Update detector** in `src/main.py`:

```python
# Change from:
from src.detectors.yolo_detector import YoloDetector

# To:
from src.detectors.yolo_detector_onnx import YoloDetectorONNX as YoloDetector

# Update initialization:
yolo_detector = YoloDetector('ultra.onnx')  # Use .onnx instead of .pt
```

3. **Install ONNX Runtime**:
```bash
pip install onnxruntime
```

---

## ⚡ Performance Comparison

### Expected Performance on Raspberry Pi 5:

| Format | FPS (640x640) | Memory | CPU Usage |
|--------|---------------|--------|-----------|
| PyTorch (.pt) | ~2-3 FPS | High | 80-90% |
| ONNX | ~4-6 FPS | Medium | 70-80% |
| TensorFlow Lite | ~5-7 FPS | Low | 65-75% |

**Note**: Actual performance depends on:
- Model complexity
- Image resolution
- Detection interval settings
- Other system processes

---

## 🎯 Recommendation for Your Project

### Current Setup (PyTorch)
✅ **Keep it if:**
- Performance is acceptable
- You want simplicity
- Detection interval is high (5+ frames)

### Switch to ONNX if:
- You need better performance
- You want faster inference
- You're processing many frames

### For Raspberry Pi 5:
**Best approach**: Start with PyTorch (current), then optimize to ONNX if needed.

---

## 📝 Export Checklist

- [ ] Export model to ONNX format
- [ ] Test ONNX model on Mac first
- [ ] Install `onnxruntime` on Pi
- [ ] Update detector code (optional)
- [ ] Test performance comparison
- [ ] Deploy optimized version

---

## 🔧 Quick Export Script

Save this as `export_to_onnx.py`:

```python
#!/usr/bin/env python3
"""Export YOLO model to ONNX format"""

from ultralytics import YOLO
import os

# Paths
model_path = 'ultra.pt'
output_dir = os.path.dirname(__file__)

# Load model
print(f"Loading model: {model_path}")
model = YOLO(model_path)

# Export to ONNX
print("Exporting to ONNX...")
model.export(
    format='onnx',
    imgsz=640,
    simplify=True,
    opset=12
)

print(f"✅ Export complete! Check for ultra.onnx in {output_dir}")
```

Run:
```bash
python3 export_to_onnx.py
```

---

## 💡 Tips

1. **Test on Mac first**: Export and test ONNX model on Mac before deploying to Pi
2. **Compare performance**: Test both formats and see the difference
3. **Keep original**: Always keep your `.pt` file as backup
4. **Simplify model**: Use `simplify=True` for smaller, faster ONNX models
5. **Optimize later**: You can always export later if needed

---

## 📊 Summary

**For Raspberry Pi 5:**
- **Current**: PyTorch (.pt) - ✅ Works fine
- **Optimized**: ONNX - ⚡ Better performance
- **Best**: Test both and choose based on your needs

**My Recommendation**: 
- Start with current PyTorch model (it works!)
- Export to ONNX if you need better performance
- The difference may not be critical if detection interval is high

---

**Last Updated**: February 2025




