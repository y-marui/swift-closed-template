#!/bin/bash
set -e

echo "🚀 Bootstrapping project..."

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew not found. Install it from https://brew.sh"
    exit 1
fi

# Install tools
echo "📦 Installing SwiftLint..."
brew install swiftlint || brew upgrade swiftlint

echo "📦 Installing SwiftFormat..."
brew install swiftformat || brew upgrade swiftformat

echo "📦 Installing pre-commit..."
brew install pre-commit || brew upgrade pre-commit

# Install pre-commit hooks
echo "🔒 Installing pre-commit hooks..."
pre-commit install

# Resolve Swift packages
echo "📦 Resolving packages (root)..."
swift package resolve

echo "📦 Resolving packages (Packages/Core)..."
swift package resolve --package-path Packages/Core

echo "✅ Bootstrap complete!"
