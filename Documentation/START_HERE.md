# 🚀 RRB Detection System - START HERE

## Quick Start (3 Simple Steps)

### Step 1: Open 3 Command Prompt Windows

Press `Win + R`, type `cmd`, press Enter. Repeat 3 times to have 3 separate windows.

---

### Step 2: Start Services in Each Window

#### 🔵 Window 1 - ML Service (Port 5000)
Copy and paste these commands:
```cmd
cd E:\RRB\ml_service
set TF_USE_LEGACY_KERAS=1
set TF_CPP_MIN_LOG_LEVEL=2
python app.py
```

**Wait for this message:**
```
Starting server on port 5000...
* Running on http://0.0.0.0:5000
```

✅ **ML Service is running!** Keep this window open.

---

#### 🟢 Window 2 - Backend (Port 3000)
Copy and paste these commands:
```cmd
cd E:\RRB\backend
node server.js
```

**Wait for this message:**
```
🚀 RRB Detection Backend Server
📡 Server running on port 3000
✅ Server is ready to accept requests
```

✅ **Backend is running!** Keep this window open.

---

#### 🟡 Window 3 - Flutter App
Copy and paste these commands:

**For Web (Chrome):**
```cmd
cd E:\RRB\rrb_detection_app
flutter run -d chrome
```

**OR for Windows Desktop:**
```cmd
cd E:\RRB\rrb_detection_app
flutter run -d windows
```

**Wait for the app to build and launch** (first time takes 2-5 minutes)

✅ **Flutter App is running!** Keep this window open.

---

### Step 3: Test the System

1. **Verify Services are Running:**
   - Open browser: http://localhost:5000/health (ML Service)
   - Open browser: http://localhost:3000/health (Backend)

2. **Use the Flutter App:**
   - Register a new account
   - Login with your credentials
   - Record or upload a video
   - Wait for detection results

---

## 🎯 One-Click Start (Alternative)

Double-click this file:
```
E:\RRB\START_ALL_SERVICES.bat
```

This will automatically open 3 windows and start all services.

---

## ⚠️ Troubleshooting

### Problem: "Python not found"
**Solution**: Make sure Python 3.10 is installed and in PATH

### Problem: "Node not found"
**Solution**: Make sure Node.js is installed and in PATH

### Problem: "Flutter not found"
**Solution**: Make sure Flutter SDK is installed at C:\flutter

### Problem: Port already in use
**Solution**: Close any programs using ports 3000 or 5000, or restart your computer

### Problem: Cannot connect from phone
**Solution**: See `QUICK_START_GUIDE.md` for IP address configuration

---

## 📚 More Information

- **Detailed Guide**: `QUICK_START_GUIDE.md`
- **System Status**: `SYSTEM_STATUS_REPORT.md`
- **Troubleshooting**: See QUICK_START_GUIDE.md

---

## 🛑 How to Stop

Press `Ctrl + C` in each command window, or simply close all 3 windows.

---

## ✅ System Requirements

- ✅ Python 3.10 installed
- ✅ Node.js 16+ installed
- ✅ Flutter SDK installed
- ✅ ML Model trained (already done)
- ✅ All dependencies installed (already done)

---

## 🎉 You're Ready!

All services are configured and ready to run. Just follow the 3 steps above!

**Need help?** Check `QUICK_START_GUIDE.md` for detailed instructions.

