#!/usr/bin/env bash
set -euo pipefail

echo "Checking host OS..."
uname -a

echo
if command -v xcodebuild >/dev/null 2>&1; then
  echo "✅ xcodebuild found"
  xcodebuild -version
else
  echo "❌ xcodebuild not found. Install Xcode (macOS only)."
fi

echo
if command -v xcrun >/dev/null 2>&1; then
  echo "✅ xcrun found"
  xcrun --version || true
else
  echo "❌ xcrun not found. Install Xcode command line tools."
fi

echo
if command -v swift >/dev/null 2>&1; then
  echo "✅ swift found"
  swift --version
else
  echo "❌ swift not found"
fi

echo
if command -v code >/dev/null 2>&1; then
  echo "✅ VS Code CLI found"
else
  echo "⚠️ VS Code CLI not found (optional in CI/containers)."
fi

echo
cat <<'TXT'
If you are on macOS:
1) Open this repo in VS Code.
2) Run task: "Environment: Validate iOS toolchain".
3) Ensure you have an Xcode project/workspace with scheme "GymRoutineApp".
4) Run task: "iOS: Build (Debug)" then "iOS: Launch Simulator App".
TXT
