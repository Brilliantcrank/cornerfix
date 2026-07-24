#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

APP_NAME="CornerFix"
APP_BUNDLE="${APP_NAME}.app"
VERSION="1.0"
IDENTIFIER="com.airbagindustries.cornerfix"
PKG_ROOT="pkgroot"
PKG_OUT="${APP_NAME}-${VERSION}.pkg"

./build.sh

rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/Applications"
COPYFILE_DISABLE=1 cp -R "$APP_BUNDLE" "$PKG_ROOT/Applications/$APP_BUNDLE"
find "$PKG_ROOT" -name '._*' -delete

chmod +x scripts/postinstall

pkgbuild \
    --root "$PKG_ROOT" \
    --scripts scripts \
    --identifier "${IDENTIFIER}.pkg" \
    --version "$VERSION" \
    --install-location / \
    "$PKG_OUT"

rm -rf "$PKG_ROOT"

echo "Built ${PKG_OUT}"
