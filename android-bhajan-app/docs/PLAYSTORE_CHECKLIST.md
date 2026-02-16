# Play Store Deployment Checklist (Bhajan App)

## Release & Security
- [ ] Use `release` build type with R8 minification and resource shrinking.
- [ ] Remove debug logs and debug-only endpoints.
- [ ] Enable Play App Signing.
- [ ] Store API keys securely (Encrypted local config / remote config).
- [ ] Add Network Security Config and HTTPS-only production traffic.

## Privacy & Policy
- [ ] Publish privacy policy URL in Play Console.
- [ ] Provide Data Safety form (audio downloads, analytics, crash data, notification usage).
- [ ] Ask runtime permission only when needed (notifications, storage scope where applicable).
- [ ] Explain reminder notifications and foreground playback in-app.

## Quality & Device Coverage
- [ ] Test Android 8 to latest Android version.
- [ ] Validate on small, normal, and large screens.
- [ ] Validate accessibility: TalkBack labels, contrast, scalable font, hit area.
- [ ] Verify offline mode, download recovery, low-network behavior.

## Media Playback Reliability
- [ ] Test MediaSession controls (notification + lock screen + headset buttons).
- [ ] Test foreground service starts/stops correctly.
- [ ] Verify audio focus handling and interruption recovery (calls, alarms).
- [ ] Validate sleep timer behavior and background playback continuity.

## Store Listing Readiness
- [ ] App icon, feature graphic, screenshots, short/long description.
- [ ] Localized listing (Hindi/English/Sanskrit where needed).
- [ ] Content rating questionnaire completed.
- [ ] Include devotional/festival playlist highlights in listing copy.

## Post-Launch
- [ ] Enable Crashlytics/ANR monitoring.
- [ ] Track playback startup time and stream failure rates.
- [ ] Add staged rollout plan (5% → 20% → 100%).
