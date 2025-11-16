#!/bin/bash
set -e

echo "=== Running RuboCop ==="
bundle exec rubocop

echo -e "\n=== Running Tests ==="
RAILS_ENV=test bundle exec rails test

echo -e "\n✅ All checks passed!"
