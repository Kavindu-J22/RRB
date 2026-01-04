# Flutter Setup Guide for VS Code

## Problem
Flutter works in Command Prompt but not in VS Code terminal (PowerShell).

## Root Cause
The Flutter installation path (`C:\flutter\bin`) is not in the system PATH environment variable that VS Code uses.

## Solutions

### ✅ Solution 1: VS Code Settings (Immediate - Already Applied)

I've created `.vscode/settings.json` with Flutter PATH configuration. This makes Flutter available in VS Code terminals immediately.

**To apply:**
1. Close all VS Code terminals (click the trash icon)
2. Open a new terminal in VS Code (Ctrl + `)
3. Test: `flutter --version`

### ✅ Solution 2: Add to System PATH (Permanent - Recommended)

**Option A: Using Batch Script (Easiest)**
1. Run `add_flutter_to_path.bat` (double-click or run from terminal)
2. Close and reopen VS Code
3. Test: `flutter --version`

**Option B: Manual Setup**
1. Press `Win + X` and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "User variables", select "Path" and click "Edit"
5. Click "New" and add: `C:\flutter\bin`
6. Click "OK" on all dialogs
7. Close and reopen VS Code
8. Test: `flutter --version`

### ✅ Solution 3: Use Full Path (Temporary Workaround)

If you need to use Flutter immediately without restarting:
```powershell
C:\flutter\bin\flutter.bat --version
C:\flutter\bin\flutter.bat doctor
C:\flutter\bin\flutter.bat create my_app
```

## Verification

After applying any solution, verify Flutter is working:

```bash
# Check Flutter version
flutter --version

# Check Flutter installation
flutter doctor

# Check Flutter devices
flutter devices
```

## Current Status

✅ Flutter installed at: `C:\flutter`
✅ Flutter version: `3.38.5`
✅ Dart version: `3.10.4`
✅ VS Code settings configured
⏳ System PATH update pending (run `add_flutter_to_path.bat`)

## Next Steps

1. **Verify Flutter in VS Code:**
   - Close all terminals in VS Code
   - Open new terminal (Ctrl + `)
   - Run: `flutter --version`

2. **Run Flutter Doctor:**
   ```bash
   flutter doctor
   ```
   This will check for any missing dependencies.

3. **Create Flutter App:**
   Once Flutter is working, we'll create the RRB Detection mobile app.

## Troubleshooting

### If Flutter still doesn't work after restarting VS Code:

1. Check if PATH was added:
   ```powershell
   $env:PATH -split ';' | Select-String -Pattern 'flutter'
   ```

2. Manually refresh environment:
   ```powershell
   $env:PATH = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")
   ```

3. Use full path temporarily:
   ```powershell
   C:\flutter\bin\flutter.bat doctor
   ```

## Additional Resources

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Installation Guide: https://docs.flutter.dev/get-started/install/windows
- VS Code Flutter Extension: Install from Extensions marketplace

