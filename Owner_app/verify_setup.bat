@echo off
REM Owner App - Configuration Verification Script (Windows)
REM Run this to verify Phase 1 implementation is complete

echo ============================================
echo Owner App - Configuration Verification
echo ============================================
echo.

set PASS_COUNT=0
set FAIL_COUNT=0

REM Test 1: Check configuration files
echo [Files] Checking configuration files...
if exist "lib\app\config\app_config.dart" (
    echo   [OK] app_config.dart exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] app_config.dart missing
    set /a FAIL_COUNT+=1
)

if exist "lib\app\env.dart" (
    echo   [OK] env.dart exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] env.dart missing
    set /a FAIL_COUNT+=1
)

if exist ".env.development" (
    echo   [OK] .env.development exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] .env.development missing
    set /a FAIL_COUNT+=1
)

if exist ".env.staging" (
    echo   [OK] .env.staging exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] .env.staging missing
    set /a FAIL_COUNT+=1
)

if exist ".env.production" (
    echo   [OK] .env.production exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] .env.production missing
    set /a FAIL_COUNT+=1
)

echo.

REM Test 2: Check documentation
echo [Docs] Checking documentation files...
if exist "README.md" (
    echo   [OK] README.md exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] README.md missing
    set /a FAIL_COUNT+=1
)

if exist "SECURITY.md" (
    echo   [OK] SECURITY.md exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] SECURITY.md missing
    set /a FAIL_COUNT+=1
)

if exist "ENVIRONMENT_SETUP.md" (
    echo   [OK] ENVIRONMENT_SETUP.md exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] ENVIRONMENT_SETUP.md missing
    set /a FAIL_COUNT+=1
)

if exist "TESTING_GUIDE.md" (
    echo   [OK] TESTING_GUIDE.md exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] TESTING_GUIDE.md missing
    set /a FAIL_COUNT+=1
)

echo.

REM Test 3: Check Android configuration
echo [Android] Checking Android configuration...
if exist "android\app\build.gradle" (
    findstr /C:"flavorDimensions" android\app\build.gradle >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo   [OK] Android flavors configured
        set /a PASS_COUNT+=1
    ) else (
        echo   [FAIL] Android flavors not configured
        set /a FAIL_COUNT+=1
    )
    
    findstr /C:"proguard-rules.pro" android\app\build.gradle >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo   [OK] ProGuard configured
        set /a PASS_COUNT+=1
    ) else (
        echo   [FAIL] ProGuard not configured
        set /a FAIL_COUNT+=1
    )
) else (
    echo   [FAIL] build.gradle missing
    set /a FAIL_COUNT+=2
)

if exist "android\app\proguard-rules.pro" (
    echo   [OK] ProGuard rules file exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] ProGuard rules file missing
    set /a FAIL_COUNT+=1
)

echo.

REM Test 4: Check iOS configuration
echo [iOS] Checking iOS configuration...
if exist "ios\Flutter\Development.xcconfig" (
    echo   [OK] Development.xcconfig exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] Development.xcconfig missing
    set /a FAIL_COUNT+=1
)

if exist "ios\Flutter\Staging.xcconfig" (
    echo   [OK] Staging.xcconfig exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] Staging.xcconfig missing
    set /a FAIL_COUNT+=1
)

if exist "ios\Flutter\Production.xcconfig" (
    echo   [OK] Production.xcconfig exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] Production.xcconfig missing
    set /a FAIL_COUNT+=1
)

if exist "ios\CONFIGURATION.md" (
    echo   [OK] iOS CONFIGURATION.md exists
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] iOS CONFIGURATION.md missing
    set /a FAIL_COUNT+=1
)

echo.

REM Test 5: Check .gitignore
echo [Security] Checking .gitignore...
findstr /C:".env.local" .gitignore >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   [OK] .env.local is ignored
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] .env.local not ignored
    set /a FAIL_COUNT+=1
)

findstr /C:"key.properties" .gitignore >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   [OK] key.properties is ignored
    set /a PASS_COUNT+=1
) else (
    echo   [FAIL] key.properties not ignored
    set /a FAIL_COUNT+=1
)

echo.

REM Test 6: Check Flutter
echo [Flutter] Checking Flutter setup...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   [OK] Flutter is installed
    set /a PASS_COUNT+=1
    
    flutter pub get >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo   [OK] Dependencies resolved
        set /a PASS_COUNT+=1
    ) else (
        echo   [WARN] Could not resolve dependencies
        set /a FAIL_COUNT+=1
    )
) else (
    echo   [FAIL] Flutter not found in PATH
    set /a FAIL_COUNT+=2
)

echo.
echo ============================================
echo Results Summary
echo ============================================
echo.
echo   [OK] Passed: %PASS_COUNT% tests
echo   [FAIL] Failed: %FAIL_COUNT% tests
echo.

if %FAIL_COUNT% EQU 0 (
    echo SUCCESS! All checks passed.
    echo.
    echo Next steps:
    echo   1. Update production URL in lib\app\config\app_config.dart
    echo   2. Test: flutter run --dart-define=ENV=staging
    echo   3. Build: flutter build appbundle --release --flavor prod --dart-define=ENV=prod --dart-define=MAPS_KEY=your_key
    echo.
    exit /b 0
) else (
    echo WARNING: Some checks failed.
    echo.
    echo For help, see:
    echo   - ENVIRONMENT_SETUP.md
    echo   - SECURITY.md
    echo   - TESTING_GUIDE.md
    echo.
    exit /b 1
)
