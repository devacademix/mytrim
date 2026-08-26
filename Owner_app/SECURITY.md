# Security Guidelines for Owner App

## 🔐 API Keys & Secrets Management

### CRITICAL: Never Commit Sensitive Data

**❌ NEVER commit these to Git:**
- Production API keys
- Google Maps API keys (production)
- Firebase configuration files with real credentials
- Database credentials
- OAuth client secrets
- Signing keys or keystores

### ✅ How to Handle API Keys Safely

#### 1. **Google Maps API Key**

**For Development:**
```bash
# Use the key in .env.development (already configured)
flutter run
```

**For Staging:**
```bash
flutter run --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_maps_key
```

**For Production:**
```bash
flutter build apk --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_maps_key
flutter build appbundle --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_maps_key
flutter build ios --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_maps_key
```

#### 2. **Backend API URLs**

Backend URLs are configured in `lib/app/config/app_config.dart`:

- **Development:** `http://localhost:8001/`
- **Staging:** `https://staging-api.yourdomain.com/`
- **Production:** `https://api.yourdomain.com/`

**To update production URL:**
1. Open `lib/app/config/app_config.dart`
2. Update the `prod` entry in `_baseUrls` map
3. Replace `yourdomain.com` with your actual domain

```dart
static const Map<String, String> _baseUrls = {
  'dev': 'http://localhost:8001/',
  'staging': 'https://staging-api.yourdomain.com/',
  'prod': 'https://api.yourdomain.com/',  // ← Update this
};
```

---

## 🔒 Secure Build Process

### Development Builds
```bash
# Default development build
flutter run

# With custom Maps key
flutter run --dart-define=MAPS_KEY=your_dev_key
```

### Staging Builds
```bash
# Android APK
flutter build apk --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key

# Android App Bundle
flutter build appbundle --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key

# iOS
flutter build ios --dart-define=ENV=staging --dart-define=MAPS_KEY=your_staging_key
```

### Production Builds
```bash
# Android APK (for testing)
flutter build apk --release --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key

# Android App Bundle (for Google Play)
flutter build appbundle --release --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key

# iOS (for App Store)
flutter build ios --release --dart-define=ENV=prod --dart-define=MAPS_KEY=your_production_key
```

---

## 🛡️ CI/CD Integration

### GitHub Actions Example

```yaml
name: Build Owner App

on:
  push:
    branches: [ main, staging, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Build Staging APK
        if: github.ref == 'refs/heads/staging'
        run: |
          flutter build apk \
            --dart-define=ENV=staging \
            --dart-define=MAPS_KEY=${{ secrets.STAGING_MAPS_KEY }}
            
      - name: Build Production APK
        if: github.ref == 'refs/heads/main'
        run: |
          flutter build apk --release \
            --dart-define=ENV=prod \
            --dart-define=MAPS_KEY=${{ secrets.PRODUCTION_MAPS_KEY }}
```

**Required GitHub Secrets:**
- `STAGING_MAPS_KEY` - Staging Google Maps API key
- `PRODUCTION_MAPS_KEY` - Production Google Maps API key

---

## 📋 Security Checklist

### Before Committing Code
- [ ] No API keys in source code
- [ ] No hardcoded URLs (use AppConfig)
- [ ] No sensitive data in comments
- [ ] `.gitignore` is properly configured
- [ ] `.env.*.local` files are not tracked

### Before Production Release
- [ ] Production API URL is configured
- [ ] Production Maps API key is set via build command
- [ ] HTTPS is enabled for all API calls
- [ ] SSL certificate pinning implemented (recommended)
- [ ] Debug logs are disabled in production
- [ ] Crashlytics/error tracking is configured
- [ ] All test credentials removed

### Regular Security Audits
- [ ] Review `.gitignore` regularly
- [ ] Check for accidentally committed secrets
- [ ] Rotate API keys periodically
- [ ] Monitor API key usage in Google Cloud Console
- [ ] Review app permissions

---

## 🔍 How to Check for Leaked Secrets

### Scan Git History
```bash
# Check for potential secrets in git history
git log --all --full-history --source --all -- *key* *secret* *password* *token*

# Search for API keys pattern
git grep -i "AIza" $(git rev-list --all)
```

### Use Secret Scanner Tools
```bash
# Install gitleaks
brew install gitleaks

# Scan repository
gitleaks detect --source . --verbose
```

---

## 🚨 If You Accidentally Commit a Secret

1. **Immediately rotate the compromised credential**
2. **Remove from Git history:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push to remote:**
   ```bash
   git push origin --force --all
   ```
4. **Notify team members to re-clone**

---

## 📞 Security Contact

If you discover a security vulnerability, please email:
**security@yourdomain.com**

Do not open public issues for security vulnerabilities.
