#!/bin/bash
set -e

echo "🧪 Running Core unit tests..."
swift test --package-path Packages/Core

echo "✅ All tests passed!"
