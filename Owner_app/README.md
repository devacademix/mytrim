# Owner App - Ultimate Salon & Shop Management

Professional salon and shop owner management app built with Flutter. Manage appointments, services, products, staff, packages, and more from your mobile device.

---

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run development build
flutter run

# Run with custom Maps API key
flutter run --dart-define=MAPS_KEY=your_google_maps_key
```

---

## ✨ Features

### 📅 Appointment Management
- View all appointments (salon/individual)
- Update appointment status
- Calendar view with daily/monthly appointments
- Filter by status (pending, accepted, ongoing, completed)

### 💼 Services Management
- Create, edit, delete services
- Set prices and discounts
- Add service images
- Categorize services

### 🛍️ Products Management
- Manage product inventory
- Set prices, discounts, stock levels
- Product categories and subcategories
- Track product orders

### 👨‍💼 Staff Management (Salon Owners)
- Add/manage stylists/specialists
- Assign categories to staff
- Track staff performance

### 🎁 Packages Management (Salon Owners)
- Create service packages
- Bundle services with discounts
- Assign specialists to packages

### 📊 Analytics Dashboard
- Revenue tracking
- Appointment statistics
- Product sales analytics
- Monthly/yearly trends

### 💬 Communication
- In-app chat with customers
- Push notifications
- Order/appointment updates

### ⭐ Reviews & Ratings
- View customer reviews
- Track ratings
- Monitor feedback

---

## 🛠️ Setup & Configuration

### Prerequisites

- Flutter SDK 3.4.1+
- Dart SDK
- Android Studio / Xcode
- Git
- Google Maps API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Owner_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   
   See [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) for detailed instructions.

4. **Update backend URL**
   
   Edit `lib/app/config/app_config.dart`:
   ```dart
   static const Map<String, String> _baseUrls = {
     'dev': 'http://localhost:8001/',
     'staging': 'https://your-staging-api.com/',
     'prod': 'https://your-production-api.com/',
   };
   ```

---

## 🏗️ Building

### Development
```bash
flutter run
```

### Staging
```bash
# Android
flutter build apk --dart-define=ENV=staging --dart-define=MAPS_KEY=your_key

# iOS
flutter build ios --dart-define=ENV=staging --dart-define=MAPS_KEY=your_key
```

### Production
```bash
# Android (Google Play)
flutter build appbundle --release \
  --flavor prod \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key

# iOS (App Store)
flutter build ios --release \
  --dart-define=ENV=prod \
  --dart-define=MAPS_KEY=your_production_key
```

---

## 📚 Documentation

- **[Environment Setup Guide](ENVIRONMENT_SETUP.md)** - Complete build & deployment guide
- **[Security Guidelines](SECURITY.md)** - API key management & security best practices
- **[iOS Configuration](ios/CONFIGURATION.md)** - Xcode schemes & iOS-specific setup
- **[Technical Audit Report](../OWNER_APP_AUDIT_REPORT.md)** - Complete architecture audit

---

## 🏛️ Architecture

### Tech Stack

- **Framework:** Flutter 3.4.1+
- **State Management:** GetX 4.6.6
- **HTTP Client:** http 1.2.1
- **Local Storage:** SharedPreferences 2.2.3
- **Backend:** Laravel API
- **Firebase:** Core + Messaging
- **Maps:** Google Maps Flutter
- **Calendar:** Syncfusion Calendar
- **Charts:** Syncfusion Charts

### Project Structure

```
lib/
├── app/
│   ├── backend/
│   │   ├── api/          # HTTP client
│   │   ├── binding/      # Dependency injection
│   │   ├── models/       # Data models (32 models)
│   │   └── parse/        # API service layer (45+ services)
│   ├── config/
│   │   └── app_config.dart  # Environment configuration
│   ├── controller/       # Business logic (45+ controllers)
│   ├── view/            # UI screens (50+ screens)
│   ├── helper/          # Utilities & routing
│   ├── util/            # Constants, theme, utilities
│   └── env.dart         # Environment settings
└── main.dart
```

---

## 🌍 Environments

| Environment | Purpose | Base URL | Bundle ID |
|------------|---------|----------|-----------|
| **Development** | Local testing | `http://localhost:8001/` | `.dev` |
| **Staging** | Pre-production | `https://staging-api.yourdomain.com/` | `.staging` |
| **Production** | Live app | `https://api.yourdomain.com/` | (base) |

All three environments can be installed simultaneously on the same device.

---

## 🔐 Security

- ✅ No hardcoded API keys
- ✅ Environment-based configuration
- ✅ Secure API key injection via dart-define
- ✅ JWT token authentication
- ✅ ProGuard enabled for production (Android)
- ✅ Separate bundle IDs per environment

See [SECURITY.md](SECURITY.md) for complete security guidelines.

---

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

---

## 🚢 Deployment

### Android (Google Play)

1. Build app bundle:
   ```bash
   flutter build appbundle --release \
     --flavor prod \
     --dart-define=ENV=prod \
     --dart-define=MAPS_KEY=your_key
   ```

2. Upload to Google Play Console
3. Submit for review

### iOS (App Store)

1. Build for iOS:
   ```bash
   flutter build ios --release \
     --dart-define=ENV=prod \
     --dart-define=MAPS_KEY=your_key
   ```

2. Open `ios/Runner.xcworkspace` in Xcode
3. Archive and upload to App Store Connect
4. Submit for review

---

## 🐛 Troubleshooting

### Maps not showing
```bash
flutter run --dart-define=MAPS_KEY=your_actual_google_maps_key
```

### Build fails
```bash
flutter clean
flutter pub get
flutter build apk
```

### iOS CocoaPods issues
```bash
cd ios
pod deintegrate
pod install
cd ..
```

See [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) for more troubleshooting tips.

---

## 📦 Dependencies

Key dependencies (see `pubspec.yaml` for complete list):

- `get: ^4.6.6` - State management & navigation
- `http: ^1.2.1` - HTTP client
- `shared_preferences: ^2.2.3` - Local storage
- `image_picker: ^1.1.2` - Image selection
- `google_maps_flutter: ^2.7.0` - Maps integration
- `firebase_core: ^4.0.0` - Firebase core
- `firebase_messaging: ^16.0.0` - Push notifications
- `syncfusion_flutter_calendar: ^30.1.38` - Calendar widget
- `syncfusion_flutter_charts: ^30.1.38` - Charts

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 📞 Support

For technical support or questions:
- Check documentation in this repository
- Review the [Technical Audit Report](../OWNER_APP_AUDIT_REPORT.md)
- Contact the development team

---

## 🎯 Project Status

✅ **Phase 1 Complete** - Critical production fixes implemented:
- Environment configuration system
- Secure API key management
- Android/iOS build flavors
- Production-ready builds

See [OWNER_APP_AUDIT_REPORT.md](../OWNER_APP_AUDIT_REPORT.md) for the complete technical audit and roadmap.

---

**Version:** 1.0.0+1  
**Flutter:** 3.4.1+  
**Last Updated:** Phase 1 Implementation Complete
