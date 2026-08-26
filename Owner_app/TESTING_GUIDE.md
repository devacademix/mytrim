# 🧪 Testing Guide - Owner App

Complete testing guide for verifying environment configuration and production readiness.

---

## 📋 Pre-Build Verification Checklist

Before building for any environment, verify these configurations:

### ✅ Configuration Files Check

```bash
# Navigate to Owner_app directory
cd Owner_app

# Verify configuration files exist
ls -la lib/app/config/app_config.dart
ls -la .env.development
ls -la .env.staging
ls -la .env.production
ls -la SECURITY.md
ls -la ENVIRONMENT_SETUP.md
```

**Expected:** All files should exist ✅

---

## 🧪 Environment Configuration Tests

### Test 1: Verify AppConfig Class

```bash
# Run the app and check console output
flutter run
```

**Expected Console Output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📱 Owner App Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌍 Environment: dev
🔗 Base URL: http://localhost:8001/
🗺️  Maps Key: Using default (dev)
⏱️  API Timeout: 60s
📝 Debug Logs: Enabled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

✅ **Pass:** Configuration prints correctly  
❌ **Fail:** No output or incorrect values

---

### Test 2: Verify Staging Environment

```bash
flutter run --dart-define=ENV=staging --dart-define=MAPS_KEY=test_key
```

**Expected Console Output:**
```
🌍 Environment: staging
🔗 Base URL: https://staging-api.yourdomain.com/
🗺️  Maps Key: Provided ✓
⏱️  API Timeout: 45s
📝 Debug Logs: Enabled
```

✅ **Pass:** Staging configuration loads  
❌ **Fail:** Still shows dev environment

---

### Test 3: Verify Production Environment

```bash
flutter run --dart-define=ENV=prod --dart-define=MAPS_KEY=test_prod_key
```

**Expected Console Output:**
```
🌍 Environment: prod
🔗 Base URL: https://api.yourdomain.com/
🗺️  Maps Key: Provided ✓
⏱️  API Timeout: 30s
📝 Debug Logs: Disabled
```

✅ **Pass:** Production configuration loads  
❌ **Fail:** Wrong URL or debug logs still enabled

---

## 📱 Android Build Tests

### Test 4: Development APK Build

```bash
cd Owner_app
flutter build apk --debug --flavor dev
```

**Expected Results:**
- ✅ Build completes successfully
- ✅ APK created at: `build/app/outputs/flutter-apk/app-dev-debug.apk`
- ✅ File size: ~40-60 MB (debug build)

**Verify on Device:**
```bash
flutter install --flavor dev
```

**Check on Device:**
- App name shows: "Owner App (Dev)"
- Bundle ID: `io.saundarya.ultimate.salon.owner.dev`
- App connects to localhost (if backend running)

---

### Test 5: Staging APK Build

```bash
flutter build apk --flavor staging --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key
```

**Expected Results:**
- ✅ Build completes successfully
- ✅ APK created at: `build/app/outputs/flutter-apk/app-staging-release.apk`
- ✅ File size: ~20-30 MB (release build, no obfuscation yet)

**Verify:**
```bash
# Install staging build
adb install build/app/outputs/flutter-apk/app-staging-release.apk
```

**Check on Device:**
- App name shows: "Owner App (Staging)"
- Bundle ID: `io.saundarya.ultimate.salon.owner.staging`
- Can install alongside dev version ✅

---

### Test 6: Production App Bundle Build

```bash
flutter build appbundle --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key
```

**Expected Results:**
- ✅ Build completes successfully
- ✅ App bundle created at: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- ✅ File size: ~15-25 MB (optimized with ProGuard)
- ✅ ProGuard rules applied

**Verify ProGuard:**
```bash
# Check build output for ProGuard messages
# Should see: "R8: Shrinking and optimizing..."
```

---

## 🍎 iOS Build Tests

### Test 7: iOS Development Build

```bash
# Run on simulator
flutter run
```

**Expected Results:**
- ✅ App launches on simulator
- ✅ Console shows dev configuration
- ✅ App name in simulator: "Owner (Dev)"

---

### Test 8: iOS Production Build

```bash
flutter build ios --release --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key
```

**Expected Results:**
- ✅ Build completes successfully
- ✅ Build output at: `build/ios/iphoneos/Runner.app`
- ✅ No warnings about missing configurations

**Note:** Full iOS testing requires a Mac with Xcode installed.

---

## 🔐 Security Verification Tests

### Test 9: Verify No Hardcoded Secrets

```bash
# Search for hardcoded API keys in code
cd Owner_app
grep -r "AIzaSy" lib/ --exclude-dir={build,android,ios}
```

**Expected Result:**
```
lib/app/config/app_config.dart:      return 'AIzaSyAB_DxX4Xhb2qVxtzyPYD6B1Vh0SIh03ts';
```

✅ **Pass:** Only found in fallback for development  
❌ **Fail:** Found in multiple files

---

### Test 10: Verify .gitignore Protection

```bash
# Check if sensitive files are ignored
git status

# Should NOT show:
# - .env.local
# - .env.*.local
# - android/key.properties
```

✅ **Pass:** Sensitive files not tracked  
❌ **Fail:** Sensitive files appear in git status

---

### Test 11: Verify Android Manifest

```bash
# Check AndroidManifest.xml
cat android/app/src/main/AndroidManifest.xml | grep "API_KEY"
```

**Expected Result:**
```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="${mapsApiKey}" />
```

✅ **Pass:** Uses placeholder, not hardcoded key  
❌ **Fail:** Shows actual API key

---

## 🌐 API Integration Tests

### Test 12: Development API Connection

1. **Start local backend:**
   ```bash
   cd ../API
   php artisan serve --port=8001
   ```

2. **Run Owner App:**
   ```bash
   cd ../Owner_app
   flutter run
   ```

3. **Test Login:**
   - Open app
   - Enter test credentials
   - Verify login works

**Expected:**
- ✅ App connects to `http://localhost:8001/`
- ✅ API calls succeed
- ✅ Login works

---

### Test 13: Staging API Connection

1. **Build staging APK:**
   ```bash
   flutter build apk --flavor staging --dart-define=ENV=staging --dart-define=MAPS_KEY=key
   ```

2. **Install on device:**
   ```bash
   flutter install --flavor staging
   ```

3. **Test on device:**
   - Open app
   - Should connect to staging API
   - Test login with staging credentials

**Expected:**
- ✅ App connects to staging URL
- ✅ API calls work over internet
- ✅ No localhost references

---

## 🗺️ Google Maps Tests

### Test 14: Maps Display

1. **Run app with Maps key:**
   ```bash
   flutter run --dart-define=MAPS_KEY=your_actual_google_maps_key
   ```

2. **Navigate to location picker:**
   - Go to Profile → Edit Profile → Pick Location
   - Or go to Signup → Location Selection

**Expected:**
- ✅ Map displays correctly
- ✅ No "For development purposes only" watermark
- ✅ Location picker works
- ✅ Can get current location

❌ **Fail if:**
- Map shows blank gray screen
- Watermark appears
- "Authorization failure" error

---

## 🔄 Multi-Environment Installation Test

### Test 15: Install All Three Versions

```bash
# Install development
flutter install --flavor dev

# Install staging  
flutter build apk --flavor staging --dart-define=ENV=staging --dart-define=MAPS_KEY=key
adb install build/app/outputs/flutter-apk/app-staging-release.apk

# Install production (if you have production build)
flutter build apk --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=key
adb install build/app/outputs/flutter-apk/app-prod-release.apk
```

**Verify on Device:**
- ✅ Three separate app icons visible
- ✅ "Owner App (Dev)"
- ✅ "Owner App (Staging)"
- ✅ "Owner App" (production)
- ✅ Can open each independently
- ✅ Each connects to different backend

---

## 📊 Build Size Verification

### Test 16: Verify Build Optimization

```bash
# Build production
flutter build apk --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=key

# Check size
ls -lh build/app/outputs/flutter-apk/app-prod-release.apk
```

**Expected Sizes:**
- **Debug APK:** 40-60 MB
- **Release APK (no ProGuard):** 25-35 MB
- **Release APK (with ProGuard):** 15-25 MB
- **App Bundle:** 15-20 MB

✅ **Pass:** Production build is optimized  
⚠️ **Warning:** If production APK > 30 MB, ProGuard might not be working

---

## 🎯 Production Readiness Checklist

### Before Submitting to Store

#### Configuration
- [ ] Production URL is set in `app_config.dart`
- [ ] Production Maps API key is ready
- [ ] Firebase project is configured for production
- [ ] Version number updated in `pubspec.yaml`
- [ ] Build number incremented

#### Security
- [ ] No hardcoded secrets in code
- [ ] `.gitignore` properly configured
- [ ] API keys passed via `--dart-define`
- [ ] ProGuard enabled for Android
- [ ] Debug logs disabled in production

#### Testing
- [ ] Tested on real Android device
- [ ] Tested on real iOS device (if available)
- [ ] Login/Signup works
- [ ] API calls work correctly
- [ ] Google Maps works
- [ ] Push notifications work
- [ ] Image uploads work
- [ ] All major features tested

#### Build Quality
- [ ] No compiler warnings
- [ ] No analyzer errors: `flutter analyze`
- [ ] Production build size is optimized
- [ ] App name is correct: "Owner App"
- [ ] Bundle ID is correct
- [ ] Signing configured correctly

#### Documentation
- [ ] SECURITY.md reviewed
- [ ] ENVIRONMENT_SETUP.md updated
- [ ] README.md accurate
- [ ] Release notes prepared

---

## 🐛 Common Issues & Solutions

### Issue 1: "Environment dev not recognized"
**Solution:**
```bash
# Ensure dart-define is passed correctly
flutter run --dart-define=ENV=staging

# Not: flutter run ENV=staging (wrong)
```

---

### Issue 2: Maps show blank
**Solution:**
```bash
# Pass Maps API key
flutter run --dart-define=MAPS_KEY=your_actual_key

# Verify key in Google Cloud Console
# Enable: Maps SDK for Android, Maps SDK for iOS
```

---

### Issue 3: Build fails with "Duplicate class"
**Solution:**
```bash
flutter clean
rm -rf build/
flutter pub get
flutter build apk
```

---

### Issue 4: "Cannot connect to localhost"
**Solution:**
- On physical device, use computer's IP instead:
  ```dart
  'dev': 'http://192.168.1.100:8001/',
  ```
- Or build for staging to test with remote server

---

### Issue 5: ProGuard not working
**Solution:**
```bash
# Check build.gradle has:
minifyEnabled true
shrinkResources true

# Rebuild
flutter clean
flutter build apk --release --flavor prod
```

---

## 📈 Performance Testing

### Test 17: App Launch Time

1. **Cold start:**
   - Force stop app
   - Clear from recent apps
   - Launch and measure time to splash screen

   **Target:** < 3 seconds

2. **Warm start:**
   - Press home button
   - Relaunch from launcher

   **Target:** < 1 second

---

### Test 18: API Response Time

1. **Open app**
2. **Navigate to Appointments**
3. **Measure time from tap to data display**

**Target:** < 2 seconds on good connection

---

## ✅ Final Verification Script

Create this script to automate checks:

```bash
#!/bin/bash
# test-configuration.sh

echo "🧪 Testing Owner App Configuration..."
echo ""

# Test 1: Check files exist
echo "✓ Checking configuration files..."
test -f lib/app/config/app_config.dart && echo "  ✅ app_config.dart exists" || echo "  ❌ app_config.dart missing"
test -f .env.development && echo "  ✅ .env.development exists" || echo "  ❌ .env.development missing"
test -f SECURITY.md && echo "  ✅ SECURITY.md exists" || echo "  ❌ SECURITY.md missing"

echo ""

# Test 2: Check for hardcoded secrets
echo "✓ Checking for hardcoded secrets..."
SECRET_COUNT=$(grep -r "AIzaSy" lib/ --exclude-dir=build | wc -l)
if [ "$SECRET_COUNT" -le 1 ]; then
    echo "  ✅ No hardcoded secrets found"
else
    echo "  ⚠️  Warning: Found $SECRET_COUNT instances of API keys"
fi

echo ""

# Test 3: Run flutter analyze
echo "✓ Running Flutter analyzer..."
flutter analyze > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  ✅ No analyzer issues"
else
    echo "  ⚠️  Analyzer found issues"
fi

echo ""

# Test 4: Check gitignore
echo "✓ Checking .gitignore..."
grep -q ".env.local" .gitignore && echo "  ✅ .env.local is ignored" || echo "  ❌ .env.local not ignored"
grep -q "key.properties" .gitignore && echo "  ✅ key.properties is ignored" || echo "  ❌ key.properties not ignored"

echo ""
echo "✅ Configuration test complete!"
```

**Run:**
```bash
chmod +x test-configuration.sh
./test-configuration.sh
```

---

## 📝 Test Report Template

After completing all tests, document results:

```markdown
# Owner App - Test Report

**Date:** [Date]
**Tester:** [Name]
**Version:** 1.0.0+1

## Environment Tests
- [ ] Development configuration: PASS/FAIL
- [ ] Staging configuration: PASS/FAIL  
- [ ] Production configuration: PASS/FAIL

## Build Tests
- [ ] Android Dev APK: PASS/FAIL
- [ ] Android Staging APK: PASS/FAIL
- [ ] Android Production Bundle: PASS/FAIL
- [ ] iOS Development: PASS/FAIL
- [ ] iOS Production: PASS/FAIL

## Security Tests
- [ ] No hardcoded secrets: PASS/FAIL
- [ ] .gitignore configured: PASS/FAIL
- [ ] AndroidManifest secure: PASS/FAIL

## Integration Tests
- [ ] Dev API connection: PASS/FAIL
- [ ] Staging API connection: PASS/FAIL
- [ ] Google Maps: PASS/FAIL

## Multi-Environment Test
- [ ] All three versions install: PASS/FAIL

## Issues Found
1. [List any issues]

## Overall Status
✅ READY FOR PRODUCTION
⚠️ NEEDS FIXES
❌ NOT READY
```

---

**Ready to test? Start with Test 1 and work through each test systematically!**
