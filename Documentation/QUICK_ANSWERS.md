# 🎯 Quick Answers - RRB Detection System

## 1. 🤖 Where is the ML Trained Model Saved?

### **Model Location:**
```
E:\RRB\ml_service\models\rrb_classifier.h5
```
- **Size**: 21.3 MB
- **Type**: Keras/TensorFlow model (.h5 format)
- **Trained**: January 3, 2026

### **Label Encoder Location:**
```
E:\RRB\ml_service\models\label_encoder.pkl
```
- **Contains**: 6 RRB categories
- **Categories**: hand_flapping, head_banging, head_nodding, spinning, atypical_hand_movements, normal

---

## 2. 🔐 Login Credentials for Flutter App

### **Important: No Pre-existing Credentials!**

The backend uses **in-memory storage**, so there are **NO default login credentials**.

### **How to Login:**

1. **Start the backend** (it must be running)
2. **Open the Flutter app**
3. **Click "Register" or "Sign Up"**
4. **Create a new account** with any credentials you want:
   - Email: `test@example.com` (or any email)
   - Password: `password123` (or any password)
   - Name: `Test User`
   - Organization: `RRB Detection Center`
   - Role: `Clinician`
5. **Login** with the credentials you just created

### **Note:**
- ⚠️ Credentials are stored in memory only
- ⚠️ When you restart the backend, you need to register again
- ✅ You can use the same email/password each time you register

---

## 3. 📱 How to Start Flutter App on Android Device

### **Your Computer's IP Address: 192.168.8.152**

### **Step-by-Step Guide:**

#### **A. Enable USB Debugging on Android Phone**
1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times (enables Developer Mode)
3. Go to **Settings** → **Developer Options**
4. Enable **USB Debugging**
5. Connect phone to computer via USB cable
6. Tap **Allow** when prompted on phone

#### **B. Configuration Already Updated! ✅**
The app is now configured to use your computer's IP:
- Backend: `http://192.168.8.152:3000/api`
- ML Service: `http://192.168.8.152:5000/api/v1`

**Important**: Phone and computer must be on the **same WiFi network**!

#### **C. Start All Services**

**Terminal 1 - ML Service:**
```cmd
cd E:\RRB\ml_service
set TF_USE_LEGACY_KERAS=1
set TF_CPP_MIN_LOG_LEVEL=2
python app.py
```

**Terminal 2 - Backend:**
```cmd
cd E:\RRB\backend
node server.js
```

**Terminal 3 - Flutter App:**
```cmd
cd E:\RRB\rrb_detection_app
flutter run
```

#### **D. Wait for App to Build**
- First build: 5-10 minutes (normal!)
- App will install automatically on your phone
- App will launch automatically

---

## 🎯 Complete Workflow

### **1. Start Services**
```cmd
E:\RRB\START_ALL_SERVICES.bat
```
(Close the Flutter window, we'll run it manually for Android)

### **2. Connect Android Device**
- Enable USB debugging
- Connect via USB cable
- Allow USB debugging on phone

### **3. Run Flutter App**
```cmd
cd E:\RRB\rrb_detection_app
flutter run
```

### **4. Use the App**
1. Register a new account
2. Login with your credentials
3. Record or upload a video
4. View detection results

---

## 🔍 Verification

### **Check Services are Running:**
On your **computer browser**:
- ML Service: http://localhost:5000/health
- Backend: http://localhost:3000/health

On your **Android phone browser**:
- Backend: http://192.168.8.152:3000/health
- ML Service: http://192.168.8.152:5000/health

If phone can't access these URLs:
- Check both devices on same WiFi
- Disable Windows Firewall temporarily
- Verify IP address hasn't changed

---

## 📋 Summary

| Question | Answer |
|----------|--------|
| **Model Location** | `E:\RRB\ml_service\models\rrb_classifier.h5` (21.3 MB) |
| **Label Encoder** | `E:\RRB\ml_service\models\label_encoder.pkl` |
| **Login Credentials** | No defaults - Register new account in app |
| **Computer IP** | 192.168.8.152 |
| **Android Setup** | Enable USB debugging, connect via USB, run `flutter run` |
| **Network Requirement** | Phone and computer on same WiFi |

---

## 🐛 Common Issues

### **"No devices found"**
- Enable USB debugging on phone
- Try different USB cable
- Install Android USB drivers

### **"Cannot connect to server"**
- Check both devices on same WiFi
- Verify services are running
- Check firewall settings

### **"Invalid credentials"**
- Backend was restarted - register again
- Use the register button, not login

---

## 📚 More Information

- **Android Setup**: `ANDROID_SETUP_GUIDE.md`
- **Quick Start**: `START_HERE.md`
- **Detailed Guide**: `QUICK_START_GUIDE.md`

---

**Ready to Start!** 🚀

1. ✅ Model saved at: `E:\RRB\ml_service\models\rrb_classifier.h5`
2. ✅ Login: Register new account in app
3. ✅ Android: Config updated, connect phone via USB, run `flutter run`

