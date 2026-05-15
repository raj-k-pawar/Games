# 🎓 EduQuest — Gamified Educational App

A fully functional Flutter educational gaming app for kids aged 5–15, with gamification, rewards, timer-based quizzes, lifelines, and a leaderboard.

---

## 📁 Project Structure

```
eduquest/
├── lib/
│   ├── main.dart                    # App entry, routing
│   ├── theme/
│   │   └── app_theme.dart           # Colors, gradients, decorations
│   ├── models/
│   │   ├── user_model.dart          # User data model
│   │   └── question_model.dart      # Question, GameResult, Subject models
│   ├── providers/
│   │   ├── user_provider.dart       # User state management
│   │   └── game_provider.dart       # Game state management
│   ├── services/
│   │   ├── subject_data.dart        # All 8 subjects with metadata
│   │   └── question_bank.dart       # 50+ questions across all subjects
│   └── screens/
│       ├── splash_screen.dart       # Animated splash
│       ├── login_screen.dart        # Name entry + avatar selection
│       ├── home_screen.dart         # Dashboard, leaderboard, profile
│       ├── game_select_screen.dart  # Choose mode + difficulty
│       ├── game_screen.dart         # Gameplay with timer + lifelines
│       └── result_screen.dart       # Score, stars, rewards, confetti
├── android/                         # Android config
├── codemagic.yaml                   # Codemagic CI/CD
└── pubspec.yaml                     # Dependencies
```

---

## 🚀 Local Setup (Run on your machine)

### Prerequisites
- Flutter SDK 3.x (stable channel)
- Android Studio / VS Code
- Android emulator or physical device (Android 5.0+ / API 21+)

### Steps

```bash
# 1. Clone or extract project
cd eduquest

# 2. Get dependencies
flutter pub get

# 3. Run on connected device / emulator
flutter run

# 4. Build debug APK
flutter build apk --debug

# 5. Build release APK (needs signing key)
flutter build apk --release
```

---

## ☁️ Codemagic Build (APK without local Flutter)

### Step 1 — Push to GitHub
```bash
git init
git add .
git commit -m "Initial EduQuest commit"
git remote add origin https://github.com/YOUR_USERNAME/eduquest.git
git push -u origin main
```

### Step 2 — Connect to Codemagic
1. Go to [codemagic.io](https://codemagic.io) and sign up (free)
2. Click **Add application** → Select your GitHub repo
3. Choose **Flutter App** as the project type
4. Select **codemagic.yaml** as the workflow config

### Step 3 — Start Build
1. Click **Start new build**
2. Select workflow: **android-debug** (no signing needed) or **android-release**
3. Wait ~10–15 minutes
4. Download the APK from the **Artifacts** section

### Step 4 — Install APK on Phone
- Download APK to your Android phone
- Enable "Install from Unknown Sources" in Settings → Security
- Open the APK file to install

---

## 🔑 Release Signing (for Google Play)

To build a signed release APK:

### Generate a keystore
```bash
keytool -genkey -v -keystore eduquest.keystore \
  -alias eduquest -keyalg RSA -keysize 2048 -validity 10000
```

### Add to Codemagic environment
In Codemagic → App Settings → Environment variables:
- `CM_KEYSTORE` — base64 of your .keystore file
- `CM_KEYSTORE_PASSWORD` — your keystore password
- `CM_KEY_ALIAS` — key alias (eduquest)
- `CM_KEY_PASSWORD` — key password

---

## 🎮 Features Implemented

| Feature | Status |
|---------|--------|
| Splash screen with animation | ✅ |
| Name entry + avatar selection (12 avatars) | ✅ |
| Home dashboard with XP bar, streak, coins | ✅ |
| 8 subjects (Math, Science, History, Logic, Coding, Geography, English, Finance) | ✅ |
| 50+ questions across all subjects + difficulties | ✅ |
| Game mode selection | ✅ |
| 3 difficulty levels (Easy / Medium / Hard) | ✅ |
| Timer-based gameplay | ✅ |
| 3 lifelines (Skip, 50:50, +15s Time) | ✅ |
| Answer feedback with explanation | ✅ |
| Score + XP + coins + gems rewards | ✅ |
| Result screen with confetti + stars | ✅ |
| Leaderboard (simulated) | ✅ |
| Profile with badges | ✅ |
| Persistent storage (SharedPreferences) | ✅ |
| Daily streak tracking | ✅ |
| Smooth animations throughout | ✅ |
| Dark theme, gradients, glow effects | ✅ |

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `flutter_animate` | Smooth animations |
| `confetti` | Celebration effects |
| `percent_indicator` | XP/timer progress bars |
| `shared_preferences` | Local data storage |
| `google_fonts` | Nunito font family |
| `fl_chart` | Charts (for analytics) |
| `audioplayers` | Sound effects (add your own audio) |

---

## 🎨 Adding More Content

### Add more questions
Edit `lib/services/question_bank.dart` — follow the `Question(...)` format.

### Add more subjects
Edit `lib/services/subject_data.dart` — add a new `SubjectModel(...)` entry.

### Add sound effects
Place `.mp3` files in `assets/audio/` and use `audioplayers` to play them in `game_screen.dart`.

### Add Lottie animations
Place `.json` files in `assets/animations/` and use the `lottie` package.

---

## 🛠️ Troubleshooting

**Build fails with "SDK not found"**
→ Make sure `local.properties` has `sdk.dir=/path/to/android/sdk`

**Packages not found**
→ Run `flutter pub get` again, then `flutter clean && flutter pub get`

**Gradle build fails**
→ Update `compileSdkVersion` and `targetSdkVersion` to 34 in `android/app/build.gradle`

**App crashes on start**
→ Check `flutter run` output for missing assets or null safety errors

---

## 📬 Support

Built with ❤️ using Flutter. For production deployment, consider adding:
- Firebase Authentication (real user accounts)
- Cloud Firestore (real-time leaderboard)
- Firebase Analytics (learning analytics)
- AdMob (ethical monetization)
- Push notifications (daily reminders)
