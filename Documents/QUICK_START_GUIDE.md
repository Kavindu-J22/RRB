# RRB Detection System - Quick Start Guide

## Overview
This guide will help you manually start all services for the RRB Detection System.

## System Architecture
The system consists of 3 main components:
1. **ML Service** (Python Flask) - Port 5000
2. **Backend API** (Node.js Express) - Port 3000
3. **Flutter Mobile App** - Runs on connected device/emulator

---

## Prerequisites

### 1. Python Environment
- Python 3.10 installed
- Required packages installed (see ml_service/requirements.txt)

### 2. Node.js Environment
- Node.js 16+ installed
- npm installed

### 3. Flutter Environment
- Flutter SDK installed (C:\flutter)
- Android Studio or VS Code with Flutter extension
- Android device/emulator or iOS simulator

---

## Step-by-Step Startup Instructions

### Step 1: Start ML Service (Python Flask - Port 5000)

1. Open a new Command Prompt or PowerShell window
2. Navigate to the ml_service directory:
   ```cmd
   cd E:\RRB\ml_service
   ```

3. Set environment variables and start the service:
   ```cmd
   set TF_USE_LEGACY_KERAS=1
   set TF_CPP_MIN_LOG_LEVEL=2
   python app.py
   ```

4. Wait for the message:
   ```
   ================================================================================
   RRB Detection ML Service
   ================================================================================
   Starting server on port 5000...
   * Running on http://0.0.0.0:5000
   ```

5. Verify the service is running:
   - Open browser: http://localhost:5000/health
   - Should return: `{"status":"healthy","service":"RRB Detection ML Service",...}`

**Keep this window open!**

---

### Step 2: Start Backend API (Node.js - Port 3000)

1. Open a **NEW** Command Prompt or PowerShell window
2. Navigate to the backend directory:
   ```cmd
   cd E:\RRB\backend
   ```

3. Install dependencies (first time only):
   ```cmd
   npm install
   ```

4. Start the backend server:
   ```cmd
   node server.js
   ```

5. Wait for the message:
   ```
   🚀 RRB Detection Backend Server
   📡 Server running on port 3000
   🌍 Environment: development
   🔗 ML Service URL: http://localhost:5000/api/v1
   
   ✅ Server is ready to accept requests
   ```

6. Verify the service is running:
   - Open browser: http://localhost:3000/health
   - Should return: `{"status":"ok","message":"RRB Detection Backend is running",...}`

**Keep this window open!**

---

### Step 3: Start Flutter Mobile App

1. Connect your Android device via USB or start an Android emulator
   - Enable USB Debugging on your device
   - Or start Android Emulator from Android Studio

2. Verify device is connected:
   ```cmd
   flutter devices
   ```

3. Open a **NEW** Command Prompt or PowerShell window
4. Navigate to the Flutter app directory:
   ```cmd
   cd E:\RRB\rrb_detection_app
   ```

5. Get Flutter dependencies (first time only):
   ```cmd
   flutter pub get
   ```

6. Run the Flutter app:
   ```cmd
   flutter run
   ```

7. Wait for the app to build and install on your device
   - First build may take 5-10 minutes
   - Subsequent builds will be faster

8. The app should launch automatically on your device

**Keep this window open to see logs!**

---

## Configuration for Physical Devices

If you're running the app on a **physical Android device** (not emulator), you need to update the API URLs:

### Find Your Computer's IP Address:
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter (e.g., 192.168.1.100)

### Update Flutter App Configuration:
1. Open: `E:\RRB\rrb_detection_app\lib\config\app_config.dart`
2. Replace `localhost` with your computer's IP address:
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:3000/api';
   static const String mlServiceUrl = 'http://192.168.1.100:5000/api/v1';
   ```
3. Save the file
4. Stop the Flutter app (press 'q' in the terminal)
5. Run again: `flutter run`

---

## Testing the System

### 1. Test ML Service
```cmd
curl http://localhost:5000/health
```

### 2. Test Backend
```cmd
curl http://localhost:3000/health
```

### 3. Test Flutter App
1. Open the app on your device
2. Register a new account
3. Login with your credentials
4. Record a short video (10-30 seconds)
5. Upload and wait for detection results

---

## Troubleshooting

### ML Service Issues

**Problem**: `ModuleNotFoundError` or import errors
**Solution**: Install required packages:
```cmd
cd E:\RRB\ml_service
pip install -r requirements.txt
```

**Problem**: Keras/TensorFlow compatibility errors
**Solution**: Ensure environment variable is set:
```cmd
set TF_USE_LEGACY_KERAS=1
```

**Problem**: Model not found
**Solution**: Verify model files exist:
- `E:\RRB\ml_service\models\rrb_classifier.h5`
- `E:\RRB\ml_service\models\label_encoder.pkl`

### Backend Issues

**Problem**: `Cannot find module` errors
**Solution**: Install dependencies:
```cmd
cd E:\RRB\backend
npm install
```

**Problem**: Port 3000 already in use
**Solution**: Kill the process using port 3000 or change port in `.env` file

### Flutter App Issues

**Problem**: No devices found
**Solution**: 
- Enable USB Debugging on Android device
- Or start Android Emulator from Android Studio

**Problem**: Build errors
**Solution**: Clean and rebuild:
```cmd
flutter clean
flutter pub get
flutter run
```

**Problem**: Cannot connect to backend
**Solution**: 
- Verify backend is running
- Check firewall settings
- Update IP address in app_config.dart (for physical devices)

---

## Stopping the Services

To stop all services:
1. Press `Ctrl+C` in each terminal window
2. Or simply close the terminal windows

---

## Quick Start Script

For convenience, you can use the automated startup script:
```cmd
E:\RRB\START_ALL_SERVICES.bat
```

This will open 3 separate windows for each service.

---

## Support

For issues or questions:
- Check the logs in each terminal window
- Verify all prerequisites are installed
- Ensure all ports (3000, 5000) are available
- Check network connectivity between services

---

## Summary

✅ ML Service: http://localhost:5000
✅ Backend API: http://localhost:3000
✅ Flutter App: Running on connected device

All services must be running simultaneously for the system to work properly.

