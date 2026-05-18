# 🎓 Quizzo — Learn, Play, Win!

A complete Flutter educational gaming app for children aged 5–15.

---

## 🚀 Build on Codemagic (3 steps)

```bash
# 1. Push to GitHub
git init && git add . && git commit -m "Quizzo v2.0"
git remote add origin https://github.com/YOUR_USERNAME/quizzo.git
git push -u origin main

# 2. codemagic.io → Add App → GitHub → quizzo
#    Config: "Use codemagic.yaml"
#    Workflow: "android-debug" ← Start here (no signing needed)

# 3. Download app-debug.apk from Artifacts tab
```

---

## 📱 App Architecture

### Screens (15 screens)
| Screen | Description |
|--------|-------------|
| Splash | Animated logo + loading |
| Onboarding | Role selection (Child / Parent) + avatar creation |
| Child Home | Dashboard, Leaderboard, Profile tabs |
| Game Select | Choose difficulty (Easy/Medium/Hard) + 10/25/50 questions |
| Game Play | Timer, lifelines (Skip/50:50/+15s), answer feedback, explanations |
| Result | Stars, confetti, rewards breakdown, performance bars |
| Shop | Avatars (12), Pets (8), Power-ups (8) with coin/gem purchases |
| Parent Login | Separate PIN-protected entry — completely separate from child UI |
| Parent Dashboard | Progress tracking, screen time controls, safety settings |
| Challenge/Battle | 1v1 battles, friend search by Quizzo ID |
| Leaderboard | Global rankings |

### Data Persistence
- All child + parent data stored locally via SharedPreferences
- Session management (child session / parent session)
- No-repeat question tracking across games

---

## 🎮 Features

### Child Features
- 8 subjects: Math, Science, History, Logic, Coding, Geography, English, Finance
- 225 unique questions across 3 difficulty levels (Grade 5–10)
- 25 questions per game (configurable: 10/25/50)
- Timer per question (25/30/35 sec by difficulty)
- 3 lifelines: Skip ⏭️, 50:50 🎯, +15sec ⏱️
- Smooth slide animation between questions
- No question repeats within a session
- XP → Level up system
- Daily streak tracking 🔥
- Coins + Gems currency
- 12 unlockable avatars
- 8 collectible pets with bonuses
- 8 power-up types
- 6 earnable badges
- Unique Quizzo ID for friend challenges
- Battle Arena with subject selection

### Parent Features (Completely Separate Login)
- PIN-protected parent account
- Per-child settings (screen time, bedtime lock, difficulty, safe mode)
- Subject performance tracking
- Weekly usage charts
- Enable/disable: multiplayer, leaderboard, safe mode
- Age group configuration (5-7 / 8-12 / 13-15)
- Weekly report toggle

---

## 🏗️ Tech Stack
- **Flutter 3.27.4** (stable)
- **Provider** — state management
- **flutter_animate** — smooth animations
- **confetti** — celebration effects
- **percent_indicator** — XP/timer bars
- **shared_preferences** — local persistence

---

## 📦 Project Structure
```
quizzo/
├── lib/
│   ├── main.dart                    ← App entry + 11 routes
│   ├── theme/app_theme.dart         ← Colors, gradients, decorations
│   ├── models/models.dart           ← All data models
│   ├── providers/
│   │   ├── app_provider.dart        ← Child + Parent state
│   │   └── game_provider.dart       ← Game state + no-repeat logic
│   ├── services/
│   │   ├── data_service.dart        ← Subjects, shop items, avatar map
│   │   └── question_service.dart   ← 225 questions for grades 5–10
│   └── screens/ (15 screens)
├── assets/images/icon.png           ← Your Quizzo logo
├── android/                         ← Android config
│   ├── app/build.gradle             ← AGP 8.7.3, NDK 27, Java 17
│   ├── settings.gradle              ← pluginManagement DSL
│   └── gradle/wrapper/              ← Gradle 8.10.2
└── codemagic.yaml                   ← Debug + Release workflows
```
