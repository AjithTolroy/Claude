# Devotional Bhajan App (Android)

Production-ready reference implementation blueprint using Kotlin, Jetpack Compose, MVVM, Clean Architecture, Room, ExoPlayer, DataStore, and Hilt.

## Included in this package
1. App architecture overview: `docs/ARCHITECTURE.md`
2. Project folder structure: `docs/ARCHITECTURE.md`
3. ExoPlayer manager: `app/src/main/java/com/devotional/bhajan/player/ExoPlayerManager.kt`
4. Room database schema: `app/src/main/java/com/devotional/bhajan/data/local/BhajanDatabase.kt`
5. Sample Compose screens:
   - `ui/home/HomeScreen.kt`
   - `ui/goddetail/GodDetailScreen.kt`
   - `ui/player/PlayerScreen.kt`
6. Foreground service example: `service/BhajanPlaybackService.kt`
7. Play Store deployment checklist: `docs/PLAYSTORE_CHECKLIST.md`

## UX Notes
- Elder friendly typography and simple touch targets.
- Calm spiritual design direction with saffron-first theming support.
- Minimal cognitive load navigation: Home → God detail → Player.

## Bonus-ready extension points
- Festival playlist tags in DB.
- Daily devotional quote via WorkManager sync.
- Home screen quick-play widget.
- Chromecast integration with MediaRouter.
