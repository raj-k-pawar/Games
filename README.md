# 🎓 Quizzo — Gamified Educational App

Flutter educational gaming app for kids 5–15 years.

---

## ✅ BUILD ON CODEMAGIC (Step-by-Step)

### Step 1 — Push to GitHub

```bash
cd quizzo
git init
git add .
git commit -m "Quizzo initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/quizzo.git
git push -u origin main
```

### Step 2 — Connect to Codemagic

1. Go to **https://codemagic.io** → Sign up / Sign in
2. Click **"Add application"**
3. Select **GitHub** → Authorize → Pick your `quizzo` repo
4. When asked project type → Choose **"Flutter App"**
5. When asked config → Choose **"Use codemagic.yaml"** ✅

### Step 3 — Start Build (No keystore needed!)

1. Click **"Start new build"**
2. Select branch: **main**
3. Select workflow: **`android-debug`** ← Start with this one
4. Click **Start**
5. Wait 10–15 minutes

### Step 4 — Download APK

1. Build finishes → Click **"Artifacts"** tab
2. Download `app-debug.apk`
3. Send to Android phone → Install (enable Unknown Sources)

---

## 📁 Project Structure

```
quizzo/
├── codemagic.yaml              ← CI/CD config (3 workflows)
├── pubspec.yaml                ← Dependencies
├── analysis_options.yaml       ← Lint config
├── android/
│   ├── app/
│   │   ├── build.gradle        ← App build config
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/com/quizzo/app/MainActivity.kt
│   │   │   └── res/
│   │   │       ├── drawable/launch_background.xml
│   │   │       └── values/{colors,styles}.xml
│   ├── build.gradle            ← Root build config
│   ├── settings.gradle         ← Plugin management
│   ├── gradle.properties
│   └── gradle/wrapper/gradle-wrapper.properties
└── lib/
    ├── main.dart               ← Entry point + routing
    ├── theme/app_theme.dart    ← Colors, gradients, decorations
    ├── models/
    │   ├── user_model.dart
    │   └── question_model.dart
    ├── providers/
    │   ├── user_provider.dart
    │   └── game_provider.dart
    ├── services/
    │   ├── subject_data.dart
    │   └── question_bank.dart
    └── screens/
        ├── splash_screen.dart
        ├── login_screen.dart
        ├── home_screen.dart
        ├── game_select_screen.dart
        ├── game_screen.dart
        ├── result_screen.dart
        ├── shop_screen.dart
        └── parent_dashboard_screen.dart
```

---

## 🔑 3 Workflows Explained

| Workflow | Signing | Use For |
|---|---|---|
| `android-debug` | Debug key (auto) | ✅ Quick test — works immediately, no setup |
| `android-release-unsigned` | Debug key (auto) | ✅ Release-mode build, no keystore needed |
| `android-release-signed` | Your keystore | 🔒 Google Play submission |

---

## 🔑 For Google Play (Signed Release)

Only needed if you want to publish to Google Play.

### 1. Generate keystore locally
```bash
keytool -genkey -v \
  -keystore quizzo.keystore \
  -alias quizzo \
  -keyalg RSA -keysize 2048 \
  -validity 10000
```

### 2. Base64-encode it
```bash
# macOS / Linux:
base64 -i quizzo.keystore | pbcopy

# Windows PowerShell:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("quizzo.keystore")) | clip
```

### 3. Add to Codemagic Environment Variables
In Codemagic → App → Environment variables → Add:
- `CM_KEYSTORE` = (paste base64 string)
- `CM_KEYSTORE_PASSWORD` = your keystore password
- `CM_KEY_ALIAS` = quizzo
- `CM_KEY_PASSWORD` = your key password

### 4. Use `android-release-signed` workflow

---

## 🏃 Run Locally

```bash
flutter pub get
flutter run                         # debug on device
flutter build apk --debug           # debug APK
flutter build apk --release         # release APK (uses debug signing)
```

---

## 🎮 Features

- 8 subjects: Math, Science, History, Logic, Coding, Geography, English, Finance
- 50+ questions at 3 difficulty levels
- Timer + 3 lifelines (Skip, 50:50, +15 sec)
- Coins, XP, Gems, Level, Streaks
- Confetti result screen with stars
- Avatar shop + pet shop + power-ups
- Parent dashboard (PIN-locked, screen time, progress)
- Leaderboard (simulated)
- Persistent storage via SharedPreferences
