#!/bin/bash

# iPhone 8 Plus, iPhone Xs Max
DCODE="$1"

if [ "$DCODE" = "5_5" ]
then
    DEVICE_TYPE="iPhone 8 Plus"
else
    DEVICE_TYPE="iPhone Xs Max"
fi

cd "$(dirname "$0")/../"

set -o xtrace

DEVICE=$(xcrun simctl create "Tester" "$DEVICE_TYPE" "iOS14.0")

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

if [ "$DCODE" = "5_5" ]
then
    ffmpeg -y -i /tmp/preview1.mp4 -r 30 -s 1080x1920 -c:a copy -an /tmp/preview5_5.mp4
else
    ffmpeg -y -i /tmp/preview1.mp4 -r 30 -s 886x1920 -c:a copy -an /tmp/preview6_5.mp4
fi
echo "Assets stored in /tmp"
