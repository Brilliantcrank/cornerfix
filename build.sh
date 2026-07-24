#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

APP_NAME="CornerFix"
BUILD_DIR=".build/release"
APP_BUNDLE="${APP_NAME}.app"

swift build -c release

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
cp "$BUILD_DIR/$APP_NAME" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
cp Resources/Info.plist "$APP_BUNDLE/Contents/Info.plist"

codesign --force --deep --sign - "$APP_BUNDLE"

echo "Built ${APP_BUNDLE}"
