# Bhajan App Architecture Overview

## 1) High-Level Architecture
The app follows **Clean Architecture + MVVM** in three layers:

- **UI Layer (Compose + ViewModel)**
  - Stateless composables render state from `StateFlow`.
  - ViewModels expose immutable UI state and consume use-cases.
- **Domain Layer (Use Cases + Models + Repository contracts)**
  - Business rules live in use-cases (`GetGodsUseCase`, `ToggleFavoriteUseCase`, etc.).
  - Domain models are framework-agnostic.
- **Data Layer (Room + Remote + DataStore + ExoPlayer integration)**
  - Repository implementations merge local and remote sources.
  - Offline-first policy: Room is source of truth, remote sync updates cache.

## 2) Key Design Decisions
- **Offline-first**: All bhajan metadata persisted in Room, downloads tracked with local URI.
- **Audio playback**: `ExoPlayerManager` singleton wraps ExoPlayer, MediaSession, queue, progress flow.
- **Background playback**: ForegroundService provides persistent notification controls.
- **Preferences**: DataStore stores theme, language, reminder time, quality settings.
- **Scalability**: Feature-centric packages (`ui/home`, `ui/player`, `ui/goddetail`) and repository abstractions.

## 3) Data Flow
1. UI triggers ViewModel intent (`onPlay`, `onFavorite`, `onDownload`).
2. ViewModel calls domain use-case.
3. Use-case uses repository interface.
4. Repository reads from Room and optionally remote API.
5. UI observes Flow from repository and recomposes.

## 4) Accessibility & Elder-Friendly UX
- Large typography defaults and high contrast text.
- Big tap targets for transport controls.
- Minimal clutter; clear hierarchy with cards and consistent iconography.
- Saffron/cream theme option and simple navigation depth.

## 5) Suggested Project Folder Structure
```text
app/
 └── src/main/java/com/devotional/bhajan/
     ├── di/
     │   ├── DatabaseModule.kt
     │   ├── NetworkModule.kt
     │   ├── PlayerModule.kt
     │   └── RepositoryModule.kt
     ├── data/
     │   ├── local/
     │   │   ├── dao/
     │   │   ├── entity/
     │   │   └── BhajanDatabase.kt
     │   ├── remote/
     │   │   ├── api/
     │   │   └── dto/
     │   ├── repository/
     │   │   └── BhajanRepositoryImpl.kt
     │   └── preferences/
     │       └── UserPreferencesDataStore.kt
     ├── domain/
     │   ├── model/
     │   ├── repository/
     │   └── usecase/
     ├── player/
     │   ├── ExoPlayerManager.kt
     │   └── PlaybackState.kt
     ├── service/
     │   └── BhajanPlaybackService.kt
     ├── ui/
     │   ├── navigation/
     │   ├── home/
     │   ├── goddetail/
     │   ├── player/
     │   ├── settings/
     │   └── components/
     ├── worker/
     │   └── ReminderWorker.kt
     └── MainActivity.kt
```
