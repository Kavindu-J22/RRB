# RRB Detection System - Flutter Mobile App

## 🎯 Overview

Complete Flutter mobile application for the RRB (Restricted and Repetitive Behaviors) Detection System. This app enables clinicians to record clinical observation videos of children aged 2-6 and receive AI-powered RRB detection results.

## ✅ Implementation Status: COMPLETE

All core features have been successfully implemented and are ready for testing.

## 📱 Features

### ✅ Implemented Features

1. **User Authentication**
   - JWT-based secure authentication
   - Login/logout functionality
   - Secure token storage
   - Auto-login on app restart

2. **Video Recording**
   - Camera integration with live preview
   - Start/stop recording controls
   - Permission handling (camera, microphone)
   - Video quality configuration (720p, 30fps)

3. **RRB Detection**
   - Video upload to ML service
   - Real-time processing with loading indicators
   - Confidence threshold filtering (≥70%)
   - Minimum detection duration filtering (≥3 seconds)

4. **Results Display**
   - Detection status (detected/not detected)
   - Primary behavior identification
   - Confidence scores with visual indicators
   - Multiple behavior detections
   - Occurrence counts and duration tracking
   - Color-coded behavior categories
   - Video metadata display

5. **UI/UX**
   - Material Design 3
   - Responsive layouts
   - Loading states and progress indicators
   - Error handling with toast notifications
   - Intuitive navigation
   - Professional clinical interface

## 🏗️ Architecture

### Technology Stack
- **Framework**: Flutter 3.38.5
- **Language**: Dart 3.10.4
- **State Management**: Provider pattern
- **HTTP Client**: http & dio packages
- **Secure Storage**: flutter_secure_storage
- **Camera**: camera package
- **Charts**: fl_chart

### Project Structure
```
rrb_detection_app/
├── lib/
│   ├── config/
│   │   └── app_config.dart          # App configuration
│   ├── models/
│   │   ├── user_model.dart          # User data model
│   │   └── detection_result_model.dart  # Detection results
│   ├── services/
│   │   ├── auth_service.dart        # Authentication API
│   │   └── video_service.dart       # Video & detection API
│   ├── providers/
│   │   └── auth_provider.dart       # Auth state management
│   ├── screens/
│   │   ├── splash_screen.dart       # Initial loading
│   │   ├── login_screen.dart        # User login
│   │   ├── home_screen.dart         # Main dashboard
│   │   ├── video_recording_screen.dart  # Video recording
│   │   └── results_screen.dart      # Detection results
│   └── main.dart                    # App entry point
├── android/                         # Android configuration
├── ios/                            # iOS configuration
└── pubspec.yaml                    # Dependencies
```

## 🚀 Quick Start

### Prerequisites
- ✅ Flutter 3.38.5 installed at `C:\flutter`
- ✅ VS Code with Flutter extension
- ✅ Android SDK (for Android development)
- ✅ Xcode (for iOS development - macOS only)

### Step 1: Fix Flutter PATH (If Needed)

**Option A: VS Code Only (Already Done)**
- `.vscode/settings.json` is already configured

**Option B: System-wide (Recommended)**
```bash
# Run the batch script
add_flutter_to_path.bat

# Then restart VS Code
```

### Step 2: Install Dependencies

```bash
cd rrb_detection_app
C:\flutter\bin\flutter.bat pub get
```

Or run the automated script:
```bash
setup_and_test_flutter_app.bat
```

### Step 3: Configure API URLs

Edit `lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://YOUR_BACKEND_IP:3000/api';
static const String mlServiceUrl = 'http://YOUR_ML_SERVICE_IP:5000/api/v1';
```

**For local testing:**
- Use your computer's local IP address (not localhost)
- Example: `http://192.168.1.100:3000/api`

### Step 4: Run the App

```bash
# Check for errors
C:\flutter\bin\flutter.bat analyze

# List available devices
C:\flutter\bin\flutter.bat devices

# Run on connected device/emulator
C:\flutter\bin\flutter.bat run

# Run in debug mode with hot reload
C:\flutter\bin\flutter.bat run --debug
```

## 📦 Dependencies

All dependencies are configured in `pubspec.yaml`:

- **State Management**: provider ^6.1.1
- **HTTP**: http ^1.1.2, dio ^5.4.0
- **Security**: flutter_secure_storage ^9.0.0, jwt_decoder ^2.0.1
- **Media**: camera ^0.10.5+9, video_player ^2.8.2, image_picker ^1.0.7
- **Storage**: path_provider ^2.1.2
- **UI**: flutter_spinkit ^5.2.0, fluttertoast ^8.2.4, fl_chart ^0.66.0
- **Permissions**: permission_handler ^11.2.0

## 🔧 Configuration

### App Settings (`lib/config/app_config.dart`)
```dart
- Confidence Threshold: 70%
- Min Detection Duration: 3.0 seconds
- Max Video Duration: 300 seconds (5 minutes)
- Min Video Duration: 10 seconds
- Video Quality: 720p
- Video FPS: 30
```

### RRB Categories
1. Hand Flapping (Red)
2. Head Banging (Orange)
3. Head Nodding (Yellow)
4. Spinning (Purple)
5. Atypical Hand Movements (Blue)
6. Normal (Green)

## 🔒 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
✅ Already configured:
- CAMERA
- RECORD_AUDIO
- WRITE_EXTERNAL_STORAGE
- READ_EXTERNAL_STORAGE
- INTERNET

### iOS (`ios/Runner/Info.plist`)
✅ Already configured:
- NSCameraUsageDescription
- NSMicrophoneUsageDescription
- NSPhotoLibraryUsageDescription
- NSPhotoLibraryAddUsageDescription

## 📱 App Flow

1. **Splash Screen** (2 seconds)
   - Checks authentication status
   - Navigates to Login or Home

2. **Login Screen**
   - Email/password authentication
   - JWT token storage
   - Error handling

3. **Home Screen**
   - Welcome message
   - Quick action buttons
   - Information card

4. **Video Recording**
   - Camera permission request
   - Live camera preview
   - Record/stop controls
   - Process confirmation

5. **Processing**
   - Upload to ML service
   - Loading indicator
   - Progress feedback

6. **Results Screen**
   - Detection status
   - Behavior details
   - Confidence scores
   - Visual charts
   - Video metadata

## 🧪 Testing

### Run Tests
```bash
C:\flutter\bin\flutter.bat test
```

### Code Analysis
```bash
C:\flutter\bin\flutter.bat analyze
```

### Build APK
```bash
C:\flutter\bin\flutter.bat build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 📚 Documentation

- `FLUTTER_SETUP_GUIDE.md` - Flutter installation and PATH setup
- `FLUTTER_APP_GUIDE.md` - Detailed app architecture guide
- `FLUTTER_APP_SETUP_COMPLETE.md` - Implementation summary

## 🔗 Integration

### Backend APIs (Node.js)
- `POST /api/auth/login` - User authentication
- `POST /api/auth/register` - User registration
- `POST /api/videos/upload` - Video upload
- `GET /api/results/:videoId` - Get results

### ML Service APIs (Python Flask)
- `POST /api/v1/detect` - RRB detection
- `GET /health` - Health check

## ⚠️ Important Notes

1. **Network Configuration**: Use local IP address, not localhost, for device testing
2. **Permissions**: Ensure all permissions are granted on first run
3. **Backend**: Ensure Node.js backend and ML service are running
4. **Model**: ML model must be trained before detection works

## 🎊 Status

**✅ READY FOR TESTING**

All features implemented:
- ✅ Authentication
- ✅ Video recording
- ✅ RRB detection
- ✅ Results display
- ✅ Permissions configured
- ✅ Error handling
- ✅ UI/UX complete

## 📞 Support

For issues or questions, refer to:
- Flutter documentation: https://docs.flutter.dev/
- Project documentation in this repository

