# iOS Configuration Guide for Owner App

## Environment-Specific Schemes

The app now supports three environment schemes:

1. **Development** - For local development
2. **Staging** - For testing on staging servers
3. **Production** - For App Store releases

## Setting Up Schemes in Xcode

### Step 1: Open Xcode

```bash
cd Owner_app/ios
open Runner.xcworkspace
```

### Step 2: Create Schemes

1. In Xcode, go to **Product > Scheme > Manage Schemes...**

2. Click the **+** button to add a new scheme

3. **Create Development Scheme:**
   - Name: `Runner-Dev`
   - Target: `Runner`
   - Click **OK**

4. **Create Staging Scheme:**
   - Name: `Runner-Staging`
   - Target: `Runner`
   - Click **OK**

5. **Create Production Scheme:**
   - Name: `Runner-Prod`
   - Target: `Runner`
   - Click **OK**

### Step 3: Configure Build Settings

1. Select **Runner** project in the navigator
2. Select **Runner** target
3. Go to **Build Settings** tab
4. Search for "Bundle Identifier"
5. Expand **Product Bundle Identifier**
6. Set for each configuration:
   - **Debug**: `io.saundarya.ultimate.salon.owner.dev`
   - **Release**: `io.saundarya.ultimate.salon.owner`

### Step 4: Configure Schemes

For each scheme:

1. Go to **Product > Scheme > Edit Scheme...** (or click on scheme name)

2. **For Runner-Dev:**
   - Build Configuration: **Debug**
   - In **Run** section, **Info** tab:
     - Build Configuration: **Debug**
   - In **Arguments** tab, add:
     - `--dart-define=ENV=dev`
     - `--dart-define=MAPS_KEY=your_dev_key`

3. **For Runner-Staging:**
   - Build Configuration: **Release**
   - In **Run** section, **Info** tab:
     - Build Configuration: **Release**
   - In **Arguments** tab, add:
     - `--dart-define=ENV=staging`
     - `--dart-define=MAPS_KEY=your_staging_key`

4. **For Runner-Prod:**
   - Build Configuration: **Release**
   - In **Archive** section:
     - Build Configuration: **Release**
   - In **Arguments** tab, add:
     - `--dart-define=ENV=prod`
     - `--dart-define=MAPS_KEY=your_production_key`

## Building from Command Line

### Development Build
```bash
# Run on simulator
flutter run --flavor dev

# Run on device
flutter run --flavor dev --dart-define=MAPS_KEY=your_dev_key
```

### Staging Build
```bash
flutter build ios --flavor staging --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key
```

### Production Build (App Store)
```bash
flutter build ios --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key
```

## App Display Names

- **Development**: "Owner (Dev)"
- **Staging**: "Owner (Staging)"
- **Production**: "Owner App"

This helps differentiate between environments when testing on the same device.

## Bundle Identifiers

- **Development**: `io.saundarya.ultimate.salon.owner.dev`
- **Staging**: `io.saundarya.ultimate.salon.owner.staging`
- **Production**: `io.saundarya.ultimate.salon.owner`

Different bundle IDs allow installing all three versions side-by-side on the same device.

## Google Maps API Key Configuration

### Option 1: Via dart-define (Recommended)
```bash
flutter run --dart-define=MAPS_KEY=your_actual_key
```

### Option 2: Via Info.plist (Less secure)
The app automatically uses the key from AppConfig, which reads from dart-define.

## Troubleshooting

### "No such module 'Flutter'"
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### CocoaPods Issues
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Archive Build Fails
1. Ensure you're using the correct scheme (Runner-Prod)
2. Check that all signing certificates are valid
3. Verify provisioning profiles are up to date
4. Clean build folder: **Product > Clean Build Folder** (⇧⌘K)

### Bundle Identifier Conflicts
If you see "An app with identifier X already exists", you need to:
1. Update the bundle identifier in Xcode
2. Create a new App ID in Apple Developer Portal
3. Generate new provisioning profiles

## App Store Submission Checklist

- [ ] Build using **Runner-Prod** scheme
- [ ] Bundle identifier is `io.saundarya.ultimate.salon.owner`
- [ ] Version number is updated in pubspec.yaml
- [ ] Production Maps API key is provided via dart-define
- [ ] All signing certificates are valid
- [ ] Provisioning profile is for production
- [ ] Tested on real device
- [ ] Screenshot ready for App Store
- [ ] Privacy policy URL ready
- [ ] App Store description prepared

## Firebase Configuration

If using different Firebase projects per environment:

1. Create three GoogleService-Info.plist files:
   - `GoogleService-Info-Dev.plist`
   - `GoogleService-Info-Staging.plist`
   - `GoogleService-Info-Prod.plist`

2. Add a Run Script phase in Xcode:
```bash
# Copy appropriate Firebase config based on configuration
if [ "${CONFIGURATION}" = "Debug" ]; then
    cp "${PROJECT_DIR}/Runner/GoogleService-Info-Dev.plist" "${PROJECT_DIR}/Runner/GoogleService-Info.plist"
elif [ "${CONFIGURATION}" = "Staging" ]; then
    cp "${PROJECT_DIR}/Runner/GoogleService-Info-Staging.plist" "${PROJECT_DIR}/Runner/GoogleService-Info.plist"
else
    cp "${PROJECT_DIR}/Runner/GoogleService-Info-Prod.plist" "${PROJECT_DIR}/Runner/GoogleService-Info.plist"
fi
```

3. Add `GoogleService-Info.plist` to .gitignore (keep the -Dev, -Staging, -Prod versions)

## Support

For issues with iOS configuration:
- Check Flutter documentation: https://docs.flutter.dev/deployment/ios
- Check Xcode documentation
- Review Apple Developer guidelines
