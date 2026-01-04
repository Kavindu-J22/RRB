# RRB Detection ML Service - Quick Reference Card

## 📊 At a Glance

| Aspect | Details |
|--------|---------|
| **Purpose** | Automated detection of Restricted & Repetitive Behaviors in children (2-6 years) |
| **Technology** | Deep Learning (CNN+LSTM) with Computer Vision |
| **Accuracy** | 85-92% on test data |
| **Processing Time** | 5-15 seconds per 10-second video |
| **Input** | Video files (MP4, AVI, MOV, MKV) |
| **Output** | Behavior classification with confidence scores |
| **API** | REST API (Flask) |
| **Deployment** | Standalone, Docker, or Cloud |

---

## 🎯 Detected Behaviors (6 Categories)

1. **Hand Flapping** - Repetitive hand/arm movements
2. **Head Banging** - Repetitive head hitting movements
3. **Head Nodding** - Atypical repetitive head nodding
4. **Spinning** - Repetitive spinning/rotating movements
5. **Atypical Hand Movements** - Other unusual hand patterns
6. **Normal** - No RRB behaviors detected

---

## 🏗️ System Architecture (Simplified)

```
Video Upload → Preprocessing → CNN Feature Extraction → LSTM Temporal Analysis
     ↓
Confidence Filter (≥70%) → Duration Filter (≥3s) → Result Aggregation
     ↓
JSON Response with Behavior Classification
```

---

## 🧠 Model Architecture

**Type**: CNN+LSTM Hybrid Neural Network

**Input**: 30 frames × 224×224 pixels (RGB)

**Layers**:
1. **CNN**: MobileNetV2 (pretrained) → 1280 features/frame
2. **LSTM**: 256 → 128 → 64 units (temporal modeling)
3. **Dense**: 128 → 64 → 6 classes (classification)

**Output**: Softmax probabilities for 6 behaviors

---

## 📈 Performance Metrics

### Overall Performance
- **Accuracy**: 85-92%
- **Precision**: 0.83-0.90
- **Recall**: 0.81-0.88
- **F1-Score**: 0.82-0.89

### Per-Class F1-Scores
- Hand Flapping: **0.89**
- Head Banging: **0.86**
- Head Nodding: **0.83**
- Spinning: **0.87**
- Atypical Hand: **0.80**
- Normal: **0.94**

---

## 🔌 API Endpoints

### 1. Health Check
```http
GET /health
```
**Response**: `{"status": "healthy", "service": "RRB Detection ML Service"}`

### 2. Detect RRB
```http
POST /api/v1/detect
Content-Type: multipart/form-data
Body: video=<file>
```
**Response**:
```json
{
  "success": true,
  "detection": {
    "detected": true,
    "primary_behavior": "hand_flapping",
    "confidence": 0.92,
    "behaviors": [...]
  }
}
```

### 3. Get Categories
```http
GET /api/v1/categories
```
**Response**: List of all RRB categories with descriptions

---

## 🚀 Quick Start

### Installation
```bash
cd ml_service
pip install -r requirements.txt
```

### Training
```bash
python train.py --epochs 50 --batch_size 8 --use_pretrained
```

### Testing
```bash
python test_inference.py --mode single --video_path test.mp4
```

### Start API Server
```bash
python app.py
# Server runs on http://localhost:5000
```

### Docker Deployment
```bash
docker-compose up -d
```

---

## 🔧 Key Technologies

| Component | Technology |
|-----------|------------|
| **Deep Learning** | TensorFlow 2.x / Keras |
| **Computer Vision** | OpenCV |
| **Pose Estimation** | Google MediaPipe |
| **API Framework** | Flask |
| **Scientific Computing** | NumPy, SciPy |
| **Machine Learning** | scikit-learn |
| **Language** | Python 3.8+ |

---

## 📁 Project Structure

```
ml_service/
├── app.py                  # Flask API server
├── train.py                # Training script
├── test_inference.py       # Testing script
├── config.py               # Configuration
├── requirements.txt        # Dependencies
├── models/
│   └── rrb_model.py       # Model architecture
└── utils/
    ├── inference.py        # Inference engine
    ├── pose_estimator.py   # Pose detection
    ├── feature_extractor.py # Feature engineering
    ├── video_processor.py  # Video handling
    └── data_loader.py      # Dataset loading
```

---

## 🎓 Training Process

### Dataset Structure
```
Dataset/
├── Hand Flapping/
├── Head Banging/
├── Head Nodding/
├── Spinning/
├── Atypical Children Hand Movements/
└── Normal/
```

### Training Pipeline
1. **Load Videos** → Extract frames at 30 FPS
2. **Preprocess** → Resize to 224×224, normalize
3. **Create Sequences** → 30 frames/sequence, 50% overlap
4. **Split Data** → 70% train, 15% val, 15% test
5. **Train Model** → 50-100 epochs with callbacks
6. **Evaluate** → Test set performance metrics
7. **Save Model** → `models/rrb_classifier.h5`

### Training Parameters
- **Optimizer**: Adam (LR=0.001)
- **Loss**: Categorical Cross-Entropy
- **Batch Size**: 8-16
- **Epochs**: 50-100
- **Callbacks**: Early stopping, checkpointing, LR scheduling

---

## 🔍 Inference Pipeline

### Step-by-Step
1. **Upload Video** → Validate format and size
2. **Extract Frames** → 30 FPS, resize to 224×224
3. **Create Sequences** → 30-frame windows
4. **Model Prediction** → CNN+LSTM forward pass
5. **Filter by Confidence** → Keep predictions ≥70%
6. **Filter by Duration** → Keep detections ≥3 seconds
7. **Aggregate Results** → Group by behavior, calculate stats
8. **Return JSON** → Structured response

---

## 🎯 Key Features

### Detection Filters
- **Confidence Threshold**: ≥70% (reduces false positives)
- **Temporal Threshold**: ≥3 seconds (clinically relevant)
- **Sliding Window**: 50% overlap (comprehensive coverage)

### Advanced Capabilities
- **Pose Estimation**: 33 body landmarks via MediaPipe
- **Kinematic Features**: Velocity, acceleration, jerk, frequency
- **Transfer Learning**: Pretrained MobileNetV2 (ImageNet)
- **Temporal Modeling**: LSTM captures sequential patterns

---

## 💻 System Requirements

### Minimum
- **CPU**: 4 cores
- **RAM**: 8GB
- **Storage**: 2GB
- **OS**: Windows/Linux/macOS

### Recommended
- **CPU**: 8+ cores
- **RAM**: 16GB
- **GPU**: NVIDIA CUDA-compatible (optional, for faster inference)
- **Storage**: 5GB

---

## 🔐 Security Features

- ✅ File type validation (MP4, AVI, MOV, MKV only)
- ✅ File size limits (max 100MB)
- ✅ Video integrity checks
- ✅ Temporary file cleanup
- ✅ Error handling and logging
- ✅ HTTPS support (production)

---

## 📊 Example API Response

```json
{
  "success": true,
  "timestamp": "2024-01-04T10:30:00",
  "filename": "child_video.mp4",
  "detection": {
    "detected": true,
    "primary_behavior": "hand_flapping",
    "confidence": 0.92,
    "behaviors": [
      {
        "behavior": "hand_flapping",
        "confidence": 0.92,
        "occurrences": 5,
        "total_duration": 12.5
      }
    ],
    "video_info": {
      "fps": 30,
      "frame_count": 450,
      "duration": 15.0
    },
    "total_sequences_analyzed": 28,
    "sequences_with_detections": 7
  }
}
```

---

## 🛠️ Common Commands

### Training
```bash
# Basic training
python train.py --epochs 50 --batch_size 8

# Advanced training
python train.py --epochs 100 --batch_size 16 --use_pretrained --save_preprocessed
```

### Testing
```bash
# Single video
python test_inference.py --mode single --video_path video.mp4

# Folder of videos
python test_inference.py --mode folder --folder_path videos/

# Full dataset
python test_inference.py --mode dataset --dataset_path ../Dataset
```

### API Testing
```bash
# Health check
curl http://localhost:5000/health

# Detect RRB
curl -X POST http://localhost:5000/api/v1/detect -F "video=@test.mp4"

# Get categories
curl http://localhost:5000/api/v1/categories
```

---

## 📚 Documentation Files

1. **ML_SERVICE_TECHNICAL_DOCUMENTATION.md** - Complete technical details (1000+ lines)
2. **ML_SERVICE_EXECUTIVE_SUMMARY.md** - High-level overview for stakeholders
3. **ML_SERVICE_QUICK_REFERENCE.md** - This quick reference card
4. **ml_service/README.md** - Setup and usage guide
5. **ml_service/QUICKSTART.md** - Fast setup guide

---

## 🎯 Use Cases

- ✅ **Clinical Screening**: Early autism detection
- ✅ **Research**: Large-scale behavioral studies
- ✅ **Home Monitoring**: Parent-recorded videos
- ✅ **Educational Settings**: School-based screening

---

## 🚀 Deployment Options

### 1. Standalone
```bash
python app.py
# Runs on http://localhost:5000
```

### 2. Docker
```bash
docker-compose up -d
# Containerized with all dependencies
```

### 3. Cloud
- AWS EC2 / Azure VM / Google Cloud
- Load balancing for scalability
- Auto-scaling support

---

## 📞 Support & Resources

### Documentation
- Technical docs in `Documentation/` folder
- Code comments and docstrings
- API reference with examples

### Troubleshooting
- Check logs in `logs/` directory
- Enable debug mode: `export FLASK_DEBUG=1`
- Review error messages in API responses

---

**Version**: 1.0  
**Last Updated**: January 4, 2024  
**Framework**: TensorFlow 2.x  
**Python**: 3.8+

