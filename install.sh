#!/usr/bin/env bash
set -euo pipefail

# Idempotent macOS setup script
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobbravo2/innie/main/install.sh)"

echo "==> Starting innie macOS setup..."

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed, updating..."
  brew update
fi

# 2. GCP CLI
if ! command -v gcloud &>/dev/null; then
  echo "==> Installing Google Cloud CLI..."
  brew install --cask google-cloud-sdk
else
  echo "==> Google Cloud CLI already installed, skipping."
fi

# 3. Cursor
if ! brew list --cask cursor &>/dev/null; then
  echo "==> Installing Cursor..."
  brew install --cask cursor
else
  echo "==> Cursor already installed, skipping."
fi

# 4. Claude
if ! brew list --cask claude &>/dev/null; then
  echo "==> Installing Claude..."
  brew install --cask claude
else
  echo "==> Claude already installed, skipping."
fi

# 5. OpenShift CLI (oc)
if ! command -v oc &>/dev/null; then
  echo "==> Installing OpenShift CLI..."
  brew install openshift-cli
else
  echo "==> OpenShift CLI already installed, skipping."
fi

# 6. GitHub CLI
if ! command -v gh &>/dev/null; then
  echo "==> Installing GitHub CLI..."
  brew install gh
else
  echo "==> GitHub CLI already installed, skipping."
fi

echo "==> innie macOS setup complete!"
