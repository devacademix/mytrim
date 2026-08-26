#!/bin/bash
# Owner App - Configuration Verification Script
# Run this to verify Phase 1 implementation is complete

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Owner App - Configuration Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Test 1: Check configuration files
echo "📁 Checking configuration files..."
if [ -f "lib/app/config/app_config.dart" ]; then
    echo "  ✅ app_config.dart exists"
    ((PASS_COUNT++))
else
    echo "  ❌ app_config.dart missing"
    ((FAIL_COUNT++))
fi

if [ -f "lib/app/env.dart" ]; then
    echo "  ✅ env.dart exists"
    ((PASS_COUNT++))
else
    echo "  ❌ env.dart missing"
    ((FAIL_COUNT++))
fi

if [ -f ".env.development" ]; then
    echo "  ✅ .env.development exists"
    ((PASS_COUNT++))
else
    echo "  ❌ .env.development missing"
    ((FAIL_COUNT++))
fi

if [ -f ".env.staging" ]; then
    echo "  ✅ .env.staging exists"
    ((PASS_COUNT++))
else
    echo "  ❌ .env.staging missing"
    ((FAIL_COUNT++))
fi

if [ -f ".env.production" ]; then
    echo "  ✅ .env.production exists"
    ((PASS_COUNT++))
else
    echo "  ❌ .env.production missing"
    ((FAIL_COUNT++))
fi

echo ""

# Test 2: Check documentation
echo "📚 Checking documentation files..."
if [ -f "README.md" ]; then
    echo "  ✅ README.md exists"
    ((PASS_COUNT++))
else
    echo "  ❌ README.md missing"
    ((FAIL_COUNT++))
fi

if [ -f "SECURITY.md" ]; then
    echo "  ✅ SECURITY.md exists"
    ((PASS_COUNT++))
else
    echo "  ❌ SECURITY.md missing"
    ((FAIL_COUNT++))
fi

if [ -f "ENVIRONMENT_SETUP.md" ]; then
    echo "  ✅ ENVIRONMENT_SETUP.md exists"
    ((PASS_COUNT++))
else
    echo "  ❌ ENVIRONMENT_SETUP.md missing"
    ((FAIL_COUNT++))
fi

if [ -f "TESTING_GUIDE.md" ]; then
    echo "  ✅ TESTING_GUIDE.md exists"
    ((PASS_COUNT++))
else
    echo "  ❌ TESTING_GUIDE.md missing"
    ((FAIL_COUNT++))
fi

echo ""

# Test 3: Check Android configuration
echo "🤖 Checking Android configuration..."
if [ -f "android/app/build.gradle" ]; then
    if grep -q "flavorDimensions" android/app/build.gradle; then
        echo "  ✅ Android flavors configured"
        ((PASS_COUNT++))
    else
        echo "  ❌ Android flavors not configured"
        ((FAIL_COUNT++))
    fi
    
    if grep -q "proguard-rules.pro" android/app/build.gradle; then
        echo "  ✅ ProGuard configured"
        ((PASS_COUNT++))
    else
        echo "  ❌ ProGuard not configured"
        ((FAIL_COUNT++))
    fi
else
    echo "  ❌ build.gradle missing"
    ((FAIL_COUNT+=2))
fi

if [ -f "android/app/proguard-rules.pro" ]; then
    echo "  ✅ ProGuard rules file exists"
    ((PASS_COUNT++))
else
    echo "  ❌ ProGuard rules file missing"
    ((FAIL_COUNT++))
fi

echo ""

# Test 4: Check iOS configuration
echo "🍎 Checking iOS configuration..."
if [ -f "ios/Flutter/Development.xcconfig" ]; then
    echo "  ✅ Development.xcconfig exists"
    ((PASS_COUNT++))
else
    echo "  ❌ Development.xcconfig missing"
    ((FAIL_COUNT++))
fi

if [ -f "ios/Flutter/Staging.xcconfig" ]; then
    echo "  ✅ Staging.xcconfig exists"
    ((PASS_COUNT++))
else
    echo "  ❌ Staging.xcconfig missing"
    ((FAIL_COUNT++))
fi

if [ -f "ios/Flutter/Production.xcconfig" ]; then
    echo "  ✅ Production.xcconfig exists"
    ((PASS_COUNT++))
else
    echo "  ❌ Production.xcconfig missing"
    ((FAIL_COUNT++))
fi

if [ -f "ios/CONFIGURATION.md" ]; then
    echo "  ✅ iOS CONFIGURATION.md exists"
    ((PASS_COUNT++))
else
    echo "  ❌ iOS CONFIGURATION.md missing"
    ((FAIL_COUNT++))
fi

echo ""

# Test 5: Check for hardcoded secrets
echo "🔐 Checking for hardcoded secrets..."
SECRET_COUNT=$(grep -r "AIzaSy" lib/ --exclude-dir=build 2>/dev/null | wc -l)
if [ "$SECRET_COUNT" -le 1 ]; then
    echo "  ✅ No excessive hardcoded API keys (found: $SECRET_COUNT)"
    ((PASS_COUNT++))
else
    echo "  ⚠️  Warning: Found $SECRET_COUNT instances of API keys"
    ((FAIL_COUNT++))
fi

# Check AndroidManifest
if grep -q '${mapsApiKey}' android/app/src/main/AndroidManifest.xml 2>/dev/null; then
    echo "  ✅ AndroidManifest uses placeholder for Maps key"
    ((PASS_COUNT++))
else
    echo "  ❌ AndroidManifest has hardcoded Maps key"
    ((FAIL_COUNT++))
fi

echo ""

# Test 6: Check .gitignore
echo "🙈 Checking .gitignore..."
if grep -q ".env.local" .gitignore; then
    echo "  ✅ .env.local is ignored"
    ((PASS_COUNT++))
else
    echo "  ❌ .env.local not ignored"
    ((FAIL_COUNT++))
fi

if grep -q "key.properties" .gitignore; then
    echo "  ✅ key.properties is ignored"
    ((PASS_COUNT++))
else
    echo "  ❌ key.properties not ignored"
    ((FAIL_COUNT++))
fi

echo ""

# Test 7: Check Flutter dependencies
echo "📦 Checking Flutter setup..."
if command -v flutter &> /dev/null; then
    echo "  ✅ Flutter is installed"
    ((PASS_COUNT++))
    
    # Try to get dependencies
    flutter pub get > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  ✅ Dependencies resolved successfully"
        ((PASS_COUNT++))
    else
        echo "  ⚠️  Could not resolve dependencies"
        ((FAIL_COUNT++))
    fi
else
    echo "  ❌ Flutter not found in PATH"
    ((FAIL_COUNT+=2))
fi

echo ""

# Test 8: Run Flutter analyze
echo "🔍 Running Flutter analyzer..."
if command -v flutter &> /dev/null; then
    flutter analyze --no-pub > /tmp/flutter_analyze.txt 2>&1
    ANALYZE_EXIT=$?
    if [ $ANALYZE_EXIT -eq 0 ]; then
        echo "  ✅ No analyzer issues"
        ((PASS_COUNT++))
    else
        ISSUE_COUNT=$(grep -c "info •" /tmp/flutter_analyze.txt 2>/dev/null || echo "0")
        echo "  ⚠️  Analyzer found $ISSUE_COUNT issues"
        echo "     Run 'flutter analyze' for details"
        ((FAIL_COUNT++))
    fi
else
    echo "  ⚠️  Flutter not available, skipping analyze"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Results Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  ✅ Passed: $PASS_COUNT tests"
echo "  ❌ Failed: $FAIL_COUNT tests"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "🎉 All checks passed! Configuration is complete."
    echo ""
    echo "Next steps:"
    echo "  1. Update production URL in lib/app/config/app_config.dart"
    echo "  2. Test with: flutter run --dart-define=ENV=staging"
    echo "  3. Build production: flutter build appbundle --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=your_key"
    echo ""
    exit 0
else
    echo "⚠️  Some checks failed. Please review and fix the issues above."
    echo ""
    echo "For help, see:"
    echo "  - ENVIRONMENT_SETUP.md"
    echo "  - SECURITY.md"
    echo "  - TESTING_GUIDE.md"
    echo ""
    exit 1
fi
