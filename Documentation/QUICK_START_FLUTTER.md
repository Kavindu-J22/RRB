# 🚀 RRB Detection Flutter App - Quick Start Guide

## ⚡ 3-Step Quick Start

### Step 1: Update API URLs (2 minutes)

Open `rrb_detection_app/lib/config/app_config.dart` and update:

```dart
static const String apiBaseUrl = 'http://192.168.1.100:3000/api';  // Your backend IP
static const String mlServiceUrl = 'http://192.168.1.100:5000/api/v1';  // Your ML service IP
```

**How to find your IP:**
```bash
# Windows
ipconfig

# Look for "IPv4 Address" under your active network adapter
# Example: 192.168.1.100
```

---

### Step 2: Connect Device or Start Emulator (1 minute)

**Option A: Real Android Device (Recommended)**
1. Enable Developer Options on your phone
2. Enable USB Debugging
3. Connect via USB
4. Allow USB debugging when prompted

**Option B: Android Emulator**
1. Open Android Studio
2. AVD Manager → Create/Start emulator

**Check devices:**
```bash
C:\flutter\bin\flutter.bat devices
```

---

### Step 3: Run the App (1 minute)

```bash
cd rrb_detection_app
C:\flutter\bin\flutter.bat run
```

**Or use the automated script:**
```bash
setup_and_test_flutter_app.bat
```

---

## 🎯 Test Flow

1. **App Opens** → Splash screen (2 seconds)
2. **Login Screen** → Enter credentials
   - Email: `test@example.com`
   - Password: `password123`
3. **Home Screen** → Click "Record New Video"
4. **Camera Screen** → Grant permissions → Record video (10-30 seconds)
5. **Processing** → Wait for detection
6. **Results Screen** → View RRB detection results

---

## 🔧 Common Issues & Solutions

### Issue: "No devices found"
**Solution:**
- For real device: Check USB debugging is enabled
- For emulator: Start emulator first
- Run: `C:\flutter\bin\flutter.bat devices`

### Issue: "Camera permission denied"
**Solution:**
- Grant camera and microphone permissions when prompted
- Or go to app settings and enable manually

### Issue: "Network error" or "Connection refused"
**Solution:**
- Ensure backend is running: `cd backend && npm start`
- Ensure ML service is running: `cd ml_service && python app.py`
- Use local IP address (192.168.x.x), NOT localhost
- Check firewall settings

### Issue: "Package not found" errors
**Solution:**
```bash
cd rrb_detection_app
C:\flutter\bin\flutter.bat pub get
```

---

## 📱 Build APK for Distribution

```bash
cd rrb_detection_app
C:\flutter\bin\flutter.bat build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

Install on device:
```bash
C:\flutter\bin\flutter.bat install
```

---

## 🎨 App Features

### ✅ Implemented
- User authentication (login/logout)
- Video recording with camera
- RRB detection processing
- Results visualization
- Confidence scores
- Behavior categorization
- Professional UI

### 🔜 Future Enhancements (Optional)
- Video history
- Export results to PDF
- Offline mode
- Multi-language support
- Dark mode

---

## 📊 App Configuration

Current settings in `lib/config/app_config.dart`:

```dart
App Name: RRB Detection
Confidence Threshold: 70%
Min Detection Duration: 3 seconds
Max Video Duration: 5 minutes
Min Video Duration: 10 seconds
Video Quality: 720p
Video FPS: 30
```

---

## 🔗 Backend Requirements

### Node.js Backend (Port 3000)
```bash
cd backend
npm install
npm start
```

### Python ML Service (Port 5000)
```bash
cd ml_service
pip install -r requirements.txt
python app.py
```

---

## 📚 Full Documentation

- `FLUTTER_APP_FINAL_SUMMARY.md` - Complete implementation summary
- `README_FLUTTER_APP.md` - Detailed app documentation
- `FLUTTER_APP_GUIDE.md` - Architecture and usage guide
- `FLUTTER_SETUP_GUIDE.md` - Flutter installation guide

---

## ✅ Pre-Flight Checklist

Before running the app:

- [ ] Flutter installed at `C:\flutter`
- [ ] Dependencies installed (`flutter pub get`)
- [ ] API URLs updated in `app_config.dart`
- [ ] Backend running on port 3000
- [ ] ML service running on port 5000
- [ ] Device connected or emulator running
- [ ] Permissions will be granted on first run

---

## 🎉 You're Ready!

Everything is set up and ready to go. Just run:

```bash
cd rrb_detection_app
C:\flutter\bin\flutter.bat run
```

The app will launch on your connected device/emulator!

---

## 💡 Pro Tips

1. **Hot Reload:** Press `r` in terminal while app is running to reload changes
2. **Hot Restart:** Press `R` for full restart
3. **Quit:** Press `q` to quit
4. **Logs:** Watch terminal for debug logs
5. **Performance:** Use release mode for better performance: `flutter run --release`

---

## 📞 Need Help?

Check the documentation files:
- Quick issues: This file
- Architecture: `FLUTTER_APP_GUIDE.md`
- Setup: `FLUTTER_SETUP_GUIDE.md`
- Complete info: `FLUTTER_APP_FINAL_SUMMARY.md`

---

**Status: READY TO RUN! 🚀**

