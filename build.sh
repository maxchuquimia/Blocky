#!/bin/bash

VERSION="$1"
ARTIFACT="Blocky"

set -e
set -o xtrace

caffeinate -w "$BASHPID" &

git checkout master

if [ -z "$VERSION" ]
then
    echo "Building older version"
else
    ARTIFACT="Blocky-$VERSION"
    echo "Creating $ARTIFACT"
    sleep 3
    
    # Update marketting version to match $VERSION
    sed -i '' "s/^				MARKETING_VERSION =.*$/				MARKETING_VERSION = $VERSION;/g" 'Blocky.xcodeproj/project.pbxproj'
    
    # Increment build number
    BUILD_VERSION=$(xcodebuild -project Blocky.xcodeproj -target Blocky -showBuildSettings | grep "CURRENT_PROJECT_VERSION" | sed 's/[ ]*CURRENT_PROJECT_VERSION = //')
    BUILD_VERSION=$((BUILD_VERSION+1))
    sed -i '' "s/^				CURRENT_PROJECT_VERSION =.*$/				CURRENT_PROJECT_VERSION = $BUILD_VERSION;/g" 'Blocky.xcodeproj/project.pbxproj'

    # Commit changes
    git add 'Blocky.xcodeproj/project.pbxproj'
    git commit -m "Increment version to $VERSION ($BUILD_VERSION)"
    git push
    git tag "$VERSION"
    git push --tags
fi

# Build
xcodebuild -project Blocky.xcodeproj -scheme AppStore -sdk iphoneos -configuration Release archive -archivePath /tmp/build/${ARTIFACT}.xcarchive

# Export & upload the archive
xcodebuild -exportArchive -archivePath /tmp/build/${ARTIFACT}.xcarchive -exportOptionsPlist exportOptions.plist

