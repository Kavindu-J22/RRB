# 📱 Running Flutter App on Android Device

## Quick Reference

### 🤖 ML Model Location
- **Model File**: `E:\RRB\ml_service\models\rrb_classifier.h5` (21.3 MB)
- **Label Encoder**: `E:\RRB\ml_service\models\label_encoder.pkl`

### 🔐 Login Credentials
- **No pre-existing credentials** - Backend uses in-memory storage
- **You must register** a new account each time you start the backend
- **Example credentials**:
  - Email: `test@example.com`
  - Password: `password123`
  - Name: `Test User`

---

## 📱 Android Device Setup

### Step 1: Enable USB Debugging on Android

1. **Open Settings** on your Android phone
2. **Go to About Phone**
3. **Tap "Build Number" 7 times** (you'll see "You are now a developer!")
4. **Go back to Settings**
5. **Open "Developer Options"** (or "System" → "Developer Options")
6. **Enable "USB Debugging"**
7. **Connect your phone** to computer via USB cable
8. **On your phone**: Tap "Allow" when prompted for USB debugging

### Step 2: Verify Device Connection

Open Command Prompt and run:
```cmd
cd E:\RRB\rrb_detection_app
flutter devices
```

You should see your Android device listed. If not:
- Try a different USB cable
- Disable and re-enable USB debugging
- Install Android USB drivers for your phone model

---

## 🌐 Network Configuration

### Your Computer's IP Address: **192.168.8.152**

### ✅ Already Updated!
The Flutter app configuration has been updated to use your computer's IP address:
- **Backend URL**: `http://192.168.8.152:3000/api`
- **ML Service URL**: `http://192.168.8.152:5000/api/v1`

**Important**: Your phone and computer must be on the **same WiFi network**!

---

## 🚀 Running the App on Android

### Method 1: Using Flutter Run Command

1. **Start all services** (ML Service + Backend):
   ```cmd
   E:\RRB\START_ALL_SERVICES.bat
   ```
   (Close the Flutter window that opens, we'll run it manually)

2. **Connect your Android device** via USB

3. **Open a new Command Prompt** and run:
   ```cmd
   cd E:\RRB\rrb_detection_app
   flutter run
   ```

4. **Wait for the app to build** (first time takes 5-10 minutes)

5. **App will install and launch** on your Android device

### Method 2: Using Android Studio

1. **Open Android Studio**
2. **Open project**: `E:\RRB\rrb_detection_app`
3. **Select your Android device** from the device dropdown
4. **Click the Run button** (green play icon)

---

## 🔥 Complete Startup Sequence

### Terminal 1 - ML Service
```cmd
cd E:\RRB\ml_service
set TF_USE_LEGACY_KERAS=1
set TF_CPP_MIN_LOG_LEVEL=2
python app.py
```
**Wait for**: `Running on http://0.0.0.0:5000`

### Terminal 2 - Backend
```cmd
cd E:\RRB\backend
node server.js
```
**Wait for**: `Server running on port 3000`

### Terminal 3 - Flutter App (Android)
```cmd
cd E:\RRB\rrb_detection_app
flutter run
```
**Wait for**: App to build and install on your device

---

## ✅ Verification Steps

### 1. Check Services are Running
On your **computer**, open browser:
- ML Service: http://localhost:5000/health
- Backend: http://localhost:3000/health

### 2. Check Network Connectivity
On your **Android phone**, open browser:
- Backend: http://192.168.8.152:3000/health
- ML Service: http://192.168.8.152:5000/health

If these don't work:
- Check firewall settings on your computer
- Ensure phone and computer are on same WiFi
- Try disabling Windows Firewall temporarily

### 3. Test the App
1. **Open the app** on your Android device
2. **Register** a new account
3. **Login** with your credentials
4. **Record or upload** a test video
5. **View results**

---

## 🐛 Troubleshooting

### Problem: Android device not detected
**Solutions**:
- Install Android USB drivers for your phone
- Try different USB cable
- Enable "File Transfer" mode on phone
- Run: `flutter doctor --android-licenses` and accept all

### Problem: App can't connect to backend
**Solutions**:
- Verify both devices on same WiFi network
- Check computer's IP hasn't changed: `ipconfig`
- Disable Windows Firewall temporarily
- Check backend is running: http://192.168.8.152:3000/health

### Problem: "Unable to connect to remote server"
**Solutions**:
- Ensure ML Service and Backend are running
- Check firewall isn't blocking ports 3000 and 5000
- Verify IP address in app_config.dart matches your computer's IP

### Problem: First build takes too long
**This is normal!** First Android build can take 5-15 minutes. Subsequent builds are much faster.

---

## 📝 Important Notes

### Network Requirements
- ✅ Phone and computer on **same WiFi network**
- ✅ Computer's IP: **192.168.8.152**
- ✅ Firewall allows ports **3000** and **5000**

### Login Credentials
- ❌ No default credentials
- ✅ Register new account each time backend restarts
- ✅ Use any email/password you want

### Model Location
- ✅ Model: `E:\RRB\ml_service\models\rrb_classifier.h5`
- ✅ Encoder: `E:\RRB\ml_service\models\label_encoder.pkl`

---

## 🎯 Quick Start Checklist

- [ ] USB Debugging enabled on Android phone
- [ ] Phone connected via USB cable
- [ ] Phone and computer on same WiFi
- [ ] ML Service running (port 5000)
- [ ] Backend running (port 3000)
- [ ] Flutter app config updated with IP (192.168.8.152)
- [ ] Run `flutter run` in rrb_detection_app directory
- [ ] Wait for app to build and install
- [ ] Register account in app
- [ ] Test video upload

---

## 🔄 If IP Address Changes

If your computer's IP address changes, update the configuration:

1. **Find new IP**:
   ```cmd
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.x.x)

2. **Update app_config.dart**:
   ```dart
   static const String apiBaseUrl = 'http://NEW_IP:3000/api';
   static const String mlServiceUrl = 'http://NEW_IP:5000/api/v1';
   ```

3. **Rebuild app**:
   ```cmd
   flutter run
   ```

---

## 📞 Need Help?

Check these files:
- `START_HERE.md` - Quick start guide
- `QUICK_START_GUIDE.md` - Detailed instructions
- `SYSTEM_STATUS_REPORT.md` - System status

---

**Your Setup**:
- 🖥️ Computer IP: **192.168.8.152**
- 🤖 ML Model: **E:\RRB\ml_service\models\rrb_classifier.h5**
- 🔐 Login: **Register new account in app**
- 📱 Android: **Connect via USB, enable USB debugging**

