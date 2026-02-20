#!/bin/bash
set -e

# Install Flutter
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Verify Flutter installation
flutter doctor

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Generate code
echo "Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs || true

# Build for web
echo "Building Flutter web app..."
flutter build web --release

echo "Build completed successfully!"
