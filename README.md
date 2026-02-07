# GymRoutineApp (SwiftUI + MVVM)

A production-oriented iOS app concept for Monday–Friday gym programming with exercise guidance, set tracking, rest timers, personalization, and progress analytics.

## 1) App Architecture Overview

### Architecture Pattern
- **MVVM** with modular folders:
  - `Models/`: domain entities (`Exercise`, `WorkoutDay`, `WorkoutProgressEntry`, etc.).
  - `ViewModels/`: screen/business state (`WorkoutPlanViewModel`, `ProgressViewModel`, `UserSettingsViewModel`).
  - `Views/`: SwiftUI UI layer.
  - `Services/`: local persistence and workout data (`StorageService`, `WorkoutDataService`).
  - `Utilities/`: reusable extensions (hex colors).

### Data Flow
1. App bootstraps `UserSettingsViewModel`, `WorkoutPlanViewModel`, `ProgressViewModel` in `GymRoutineApp`.
2. `WorkoutDataService` produces the weekly split and auto-adjusted sets/reps based on selected fitness level.
3. `WorkoutPlanViewModel` owns exercise performance state (sets done, weight, reps, favorites).
4. `ProgressViewModel` records completed exercises by date/day to compute completion %, streak, and monthly calendar data.
5. `StorageService` persists personalization/progress via **UserDefaults** using Codable JSON payloads.

### Scalability Notes
- Replace `StorageService` with Core Data/SwiftData without changing most view code.
- Convert `WorkoutDataService` to remote-config/API service later.
- Split each feature into its own module/package (`WorkoutFeature`, `ProgressFeature`, etc.) for App Store-scale apps.

## 2) SwiftUI Screen Structure

- `RootView`
  - `OnboardingView` (fitness level selection + dark mode)
  - `MainTabView`
    - `WorkoutListView` (daily split list + progress bar)
      - `ExerciseDetailView` (images, demo link, instructions, mistakes, safety, set tracking, rest timer)
    - `ProgressDashboardView` (weekly completion, streaks, personal bests, calendar)
    - `SettingsView` (fitness level updates + appearance)

## 3) Sample Data Model (Exercises + Workouts)

Core model (from `Models/WorkoutModels.swift`):
- `Exercise`
  - `name`, `muscleGroup`, `sets`, `reps`, `targetRepRange`, `restSeconds`, `difficulty`
  - `startImageURL`, `endImageURL`, optional `animationURL`
  - instructions, mistakes, safety, equipment, alternatives
- `WorkoutDay`
  - weekday and ordered exercises
- `ExercisePerformance`
  - completed sets, weight, achieved reps, favorites, personal bests
- `WorkoutProgressEntry`
  - date + completed exercise IDs for weekly/monthly analytics

## 4) Example SwiftUI Code Included

Implemented in project files:
- Workout list screen: `Views/WorkoutListView.swift`
- Exercise detail screen (interactive): `Views/ExerciseDetailView.swift`
- Progress tracking dashboard: `Views/ProgressDashboardView.swift`

## 5) Weekly Workout Split (Monday–Friday)

Configured in `Services/WorkoutDataService.swift`:
- Monday: Chest + Triceps
- Tuesday: Back + Biceps
- Wednesday: Legs + Core
- Thursday: Shoulders + Abs
- Friday: Full Body / Conditioning

Each exercise includes:
- ordered list placement
- muscle group
- sets × reps
- target rep range
- rest timer seconds
- difficulty level

## 6) Exercise Media (Legal Sourcing Guidance)

For App Store publication, use media with explicit commercial usage rights:

- **Self-produced media** (best): film/photo your own demos and own full rights.
- **Licensed stock platforms**:
  - Shutterstock, Adobe Stock, Getty/iStock (paid licenses; keep receipts and terms).
  - Free libraries with commercial terms: Unsplash, Pexels, Pixabay (still verify each asset/license and trademark/personality constraints).
- **Fitness content providers/APIs**:
  - Use providers offering embedding/commercial rights contracts for app usage.

Best practices:
- Store source URL + license metadata for each asset.
- Keep attribution where required.
- Avoid copyrighted brand logos/equipment marks unless licensed.
- Prefer consistent style guide for all exercise pairs (start/end) to improve UX clarity.

## 7) Accessibility + UX Considerations

- Dynamic Type compatible text styles.
- Color-coded muscle tags with readable contrast.
- Large card tap targets and segmented weekday picker.
- Minimal visual noise, Apple-style materials, smooth banners/transitions.

## 8) App Store Readiness Recommendations

- Add privacy policy and telemetry consent.
- Add offline-first SwiftData/Core Data migration.
- Add unit tests for progression logic and streak calculations.
- Add localized strings and VoiceOver labels.
- Replace placeholder images/GIF links with owned/licensed assets.

## 9) Running from Visual Studio Code

You can **edit in VS Code**, but iOS apps still require Apple tooling to build/run:
- Required: macOS + Xcode + iOS Simulator.
- VS Code can trigger build/test through shell tasks.

Added:
- `.vscode/tasks.json` with tasks for build/test/simulator.
- `scripts/validate_ios_env.sh` to verify environment.

### Steps
1. Open repo in VS Code.
2. Run task **Environment: Validate iOS toolchain**.
3. Ensure this source is inside an Xcode project/workspace with scheme `GymRoutineApp`.
4. Run **iOS: Build (Debug)** task.
5. Run **iOS: Launch Simulator App**.

> Note: This Linux container cannot run SwiftUI iOS apps because `xcodebuild`/Simulator are macOS-only.
