#!/bin/bash

cd "$(dirname "$0")/../"

set -o xtrace

DEVICE=$(xcrun simctl create "Tester" "iPhone 8 Plus" "iOS14.0")

xcrun simctl boot "$DEVICE"

xcrun simctl io booted recordVideo --codec=h264 --mask=ignored --force /tmp/preview1.mp4 &
RECORDING_PID="$!"

xcodebuild \
    -project Blocky.xcodeproj \
    -scheme "Blocky" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=Tester,OS=14.0' \
    -only-testing:BlockyUITests/BlockyAppPreview/preview1 \
    test

kill -INT "$RECORDING_PID"

xcrun simctl shutdown "$DEVICE"

xcrun simctl delete "$DEVICE"

echo "Assets stored in /tmp"
