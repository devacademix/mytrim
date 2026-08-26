# 🚀 Owner App - Environment Setup Guide

Complete guide for building and deploying the Owner App across different environments.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Environment Overview](#environment-overview)
- [Development Setup](#development-setup)
- [Building for Different Environments](#building-for-different-environments)
- [Configuration Files](#configuration-files)
- [Troubleshooting](#troubleshooting)
- [CI/CD Integration](#cicd-integration)

---

## ⚡ Quick Start

### Run Development Build
```bash
# Default development environment (localhost)
flutter run

# With custom Maps API key
flutter run --dart-define=MAPS_KEY=your_dev_key
```

### Build for Staging
```bash
# Android
flutter build apk --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key

# iOS
flutter build ios --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key
```

### Build for Production
```bash
# Android App Bundle (for Google Play)
flutter build appbundle --release \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key

# iOS (for App Store)
flutter build ios --release \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key
```

---

## 🌍 Environment Overview

The app supports three environments:

| Environment | Purpose | Base URL | Bundle ID Suffix |
|------------|---------|----------|------------------|
| **Development** | Local development & testing | `http://localhost:8001/` | `.dev` |
| **Staging** | Pre-production testing | `https://staging-api.yourdomain.com/` | `.staging` |
| **Production** | Live app for users | `https://api.yourdomain.com/` | (none) |

### Environment Features

- ✅ Separate API endpoints
- ✅ Different app names & icons
- ✅ Unique bundle identifiers (can install all 3 simultaneously)
- ✅ Environment-specific timeouts
- ✅ Debug logging control
- ✅ Secure API key management

---

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK 3.4.1+
- Dart SDK
- Android Studio / Xcode
- Git

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Owner_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Update Production URL** (Important!)
   
   Open `lib/app/config/app_config.dart` and update:
   ```dart
   static const Map<String, String> _baseUrls = {
     'dev': 'http://localhost:8001/',
     'staging': 'https://staging-api.yourdomain.com/',  // Update this
     'prod': 'https://api.yourdomain.com/',             // Update this
   };
   ```

4. **Configure Google Maps API Keys**
   
   You have two options:

   **Option A: Via Command Line (Recommended)**
   ```bash
   flutter run --dart-define=MAPS_KEY=your_actual_key
   ```

   **Option B: Via .env File (Development Only)**
   
   Update `.env.development`:
   ```
   MAPS_KEY=your_development_key
   ```
   ⚠️ Never commit production keys!

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Building for Different Environments

### Android Builds

#### Development APK
```bash
# Debug build (default)
flutter build apk --debug --flavor dev

# With custom key
flutter build apk --debug --flavor dev --dart-define=MAPS_KEY=your_dev_key
```

#### Staging APK
```bash
flutter build apk \
  --flavor staging \
  --dart-define=ENV=staging \
  --dart-define=MAPS_KEY=your_staging_key
```

#### Production App Bundle (Google Play)
```bash
flutter build appbundle --release \
  --flavor prod \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key
```

#### Production APK (Testing)
```bash
flutter build apk --release \
  --flavor prod \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key
```

### iOS Builds

#### Development (Simulator)
```bash
flutter run
```

#### Development (Device)
```bash
flutter run --dart-define=MAPS_KEY=your_dev_key
```

#### Staging
```bash
flutter build ios \
  --dart-define=ENV=staging \
  --dart-define=MAPS_KEY=your_staging_key
```

#### Production (App Store)
```bash
flutter build ios --release \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key
```

**Note:** For iOS, you also need to configure schemes in Xcode. See [ios/CONFIGURATION.md](ios/CONFIGURATION.md) for detailed instructions.

---

## 📁 Configuration Files

### Environment Configuration

**Location:** `lib/app/config/app_config.dart`

This is the central configuration file that manages:
- Base URLs for each environment
- API timeouts
- Debug logging flags
- Google Maps API key handling

### Environment Templates

| File | Purpose | Committed to Git? |
|------|---------|-------------------|
| `.env.development` | Dev config template | ✅ Yes |
| `.env.staging` | Staging config template | ✅ Yes |
| `.env.production` | Prod config template | ✅ Yes |
| `.env.*.local` | Actual secrets | ❌ No (gitignored) |

### Android Configuration

- **build.gradle**: Product flavors (dev/staging/prod)
- **AndroidManifest.xml**: Dynamic app name & Maps key placeholder
- **proguard-rules.pro**: Code obfuscation rules for production

### iOS Configuration

- **Info.plist**: Dynamic app display name
- **Development.xcconfig**: Dev scheme configuration
- **Staging.xcconfig**: Staging scheme configuration
- **Production.xcconfig**: Production scheme configuration

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "API Base URL is localhost"

**Problem:** App can't connect to backend after installing on device.

**Solution:** 
- For dev: Use your computer's IP address instead of localhost
- For staging/prod: Ensure you're building with correct environment flag

```bash
# Update dev URL temporarily in app_config.dart
'dev': 'http://192.168.1.100:8001/',

# Or build for staging
flutter build apk --dart-define=ENV=staging --dart-define=MAPS_KEY=key
```

#### 2. "Google Maps not showing"

**Problem:** Maps show blank or "For development purposes only" watermark.

**Solution:**
```bash
# Ensure you're passing the Maps key
flutter run --dart-define=MAPS_KEY=your_actual_google_maps_key

# Check the key is correct in Google Cloud Console
# Ensure the key has the right API enabled:
# - Maps SDK for Android
# - Maps SDK for iOS
```

#### 3. "Build failed: Duplicate class found"

**Problem:** Conflicting dependencies or cached builds.

**Solution:**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build apk
```

#### 4. "Environment variable ENV not found"

**Problem:** App doesn't know which environment to use.

**Solution:**
```bash
# Always specify environment for non-dev builds
flutter build apk --dart-define=ENV=staging

# For development, it defaults to 'dev'
flutter run  # This is fine
```

#### 5. iOS Build Fails

**Problem:** Pod installation or signing issues.

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

#### 6. "Cannot install app - Bundle ID already exists"

**Problem:** Trying to install same bundle ID.

**Solution:**
- Dev and staging have different bundle IDs (.dev, .staging)
- You can install all three versions simultaneously
- Make sure you're building with the correct flavor

```bash
# Install dev version
flutter install --flavor dev

# Install staging version  
flutter install --flavor staging
```

---

## 🔐 Security Best Practices

### DO ✅

- ✅ Pass API keys via `--dart-define` in CI/CD
- ✅ Use environment variables in GitHub Actions secrets
- ✅ Update production URLs in `app_config.dart`
- ✅ Test on real devices before production release
- ✅ Enable ProGuard for production Android builds
- ✅ Use proper code signing for production

### DON'T ❌

- ❌ Commit API keys to git
- ❌ Hardcode production URLs in code
- ❌ Use development keys in production
- ❌ Commit `.env.local` files
- ❌ Skip testing on real devices
- ❌ Release debug builds to production

---

## 🤖 CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build Owner App

on:
  push:
    branches: [ main, staging, develop ]
  pull_request:
    branches: [ main, staging ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.4.1'
          channel: 'stable'
      
      - name: Install dependencies
        run: |
          cd Owner_app
          flutter pub get
      
      - name: Build Development APK
        if: github.ref == 'refs/heads/develop'
        run: |
          cd Owner_app
          flutter build apk --debug --flavor dev
      
      - name: Build Staging APK
        if: github.ref == 'refs/heads/staging'
        run: |
          cd Owner_app
          flutter build apk \
            --flavor staging \
            --dart-define=ENV=staging \
            --dart-define=MAPS_KEY=${{ secrets.STAGING_MAPS_KEY }}
      
      - name: Build Production App Bundle
        if: github.ref == 'refs/heads/main'
        run: |
          cd Owner_app
          flutter build appbundle --release \
            --flavor prod \
            --dart-define=ENV=prod \
            --dart-define=MAPS_KEY=${{ secrets.PRODUCTION_MAPS_KEY }}
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: Owner_app/build/app/outputs/
  
  build-ios:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.4.1'
          channel: 'stable'
      
      - name: Install dependencies
        run: |
          cd Owner_app
          flutter pub get
          cd ios
          pod install
      
      - name: Build iOS (Production)
        if: github.ref == 'refs/heads/main'
        run: |
          cd Owner_app
          flutter build ios --release --no-codesign \
            --dart-define=ENV=prod \
            --dart-define=MAPS_KEY=${{ secrets.PRODUCTION_MAPS_KEY }}
```

### Required GitHub Secrets

Add these in **Settings > Secrets and variables > Actions**:

- `STAGING_MAPS_KEY` - Staging Google Maps API key
- `PRODUCTION_MAPS_KEY` - Production Google Maps API key
- `ANDROID_KEYSTORE` - Android signing keystore (base64 encoded)
- `KEYSTORE_PASSWORD` - Keystore password
- `KEY_ALIAS` - Key alias
- `KEY_PASSWORD` - Key password

---

## 📱 App Variants

When you build for different environments, you get:

| Environment | App Name | Bundle ID | Installable Together? |
|------------|----------|-----------|----------------------|
| Dev | "Owner (Dev)" | `io.saundarya.ultimate.salon.owner.dev` | ✅ Yes |
| Staging | "Owner (Staging)" | `io.saundarya.ultimate.salon.owner.staging` | ✅ Yes |
| Production | "Owner App" | `io.saundarya.ultimate.salon.owner` | ✅ Yes |

**You can install all three on the same device for testing!**

---

## 🧪 Testing Checklist

### Before Production Release

- [ ] Built with `ENV=prod`
- [ ] Production API URL is correct
- [ ] Production Maps API key is set
- [ ] Tested on real Android device
- [ ] Tested on real iOS device
- [ ] Login/Signup works
- [ ] API calls work correctly
- [ ] Google Maps displays properly
- [ ] Firebase notifications work
- [ ] No debug logs in production
- [ ] App displays correct name "Owner App"
- [ ] Version number is updated
- [ ] ProGuard is enabled (Android)
- [ ] Code signing is configured (iOS)

---

## 📞 Support & Additional Documentation

- **Security Guidelines**: See [SECURITY.md](SECURITY.md)
- **iOS Configuration**: See [ios/CONFIGURATION.md](ios/CONFIGURATION.md)
- **API Integration**: See [OWNER_APP_AUDIT_REPORT.md](../OWNER_APP_AUDIT_REPORT.md)

For issues or questions:
- Check the troubleshooting section above
- Review the audit report for architecture details
- Contact the development team

---

## 🎯 Quick Reference Commands

```bash
# Development
flutter run
flutter run --dart-define=MAPS_KEY=key

# Staging Android
flutter build apk --dart-define=ENV=staging --dart-define=MAPS_KEY=key

# Staging iOS
flutter build ios --dart-define=ENV=staging --dart-define=MAPS_KEY=key

# Production Android (App Bundle)
flutter build appbundle --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=key

# Production iOS
flutter build ios --release --dart-define=ENV=prod --dart-define=MAPS_KEY=key

# Clean build
flutter clean && flutter pub get

# Check configuration
flutter run  # Look for the configuration print in console
```

---

**Last Updated:** Phase 1 - Critical Production Fixes Complete  
**App Version:** 1.0.0+1  
**Flutter Version:** 3.4.1+
