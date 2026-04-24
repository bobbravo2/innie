#!/usr/bin/env bash
set -euo pipefail

# Idempotent macOS setup script — a Lumon Industries production
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobbravo2/innie/main/install.sh)"

echo "🏢 Welcome to Lumon Industries."
echo "   Your innie has been activated. Initiating Macrodata Refinement environment..."
echo ""

# 1. Homebrew — the package handler of the Severed Floor
if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew not found. Refining package manager from the source..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "🍺 Homebrew already refined. Updating the bins..."
  brew update
fi

# 2. GCP CLI — access to the outer cloud (outie's cloud, really)
if ! command -v gcloud &>/dev/null; then
  echo "☁️  Google Cloud CLI has been placed in the perpetual testing bin. Refining..."
  brew install --cask google-cloud-sdk
else
  echo "☁️  Google Cloud CLI already present on the Severed Floor."
fi

# 3. Cursor — the IDE your innie deserves
if ! brew list --cask cursor &>/dev/null; then
  echo "🖥️  Cursor awaits in the Break Room. Installing..."
  brew install --cask cursor
else
  echo "🖥️  Cursor is already on the Severed Floor."
fi

# 4. Claude — your Optics & Design colleague
if ! brew list --cask claude &>/dev/null; then
  echo "🤖 Claude has not yet reported to their department. Installing..."
  brew install --cask claude
else
  echo "🤖 Claude is already seated at their workstation."
fi

# 5. OpenShift CLI (oc) — the container corridor
if ! command -v oc &>/dev/null; then
  echo "🔴 OpenShift CLI has been approved by Ms. Cobel. Installing..."
  brew install openshift-cli
else
  echo "🔴 OpenShift CLI is already badged in."
fi

# 6. GitHub CLI — your outie's code vault
if ! command -v gh &>/dev/null; then
  echo "🐙 GitHub CLI not found. Submitting a waiver to O&D... Installing..."
  brew install gh
else
  echo "🐙 GitHub CLI is already on the floor."
fi

# 7. uvx (via uv) — lightning-fast Python tooling
if ! command -v uvx &>/dev/null; then
  echo "⚡ uvx not detected. The handbook requires it. Installing via uv..."
  brew install uv
else
  echo "⚡ uvx is already present and accounted for."
fi

# 8. Python + pip — the serpent of productivity
if ! command -v python3 &>/dev/null; then
  echo "🐍 Python not found. Kier wills it installed..."
  brew install python
else
  echo "🐍 Python is already slithering through the floor."
fi

# 9. Google Workspace CLI (gws) — one API for all of Workspace
if ! command -v gws &>/dev/null; then
  echo "📧 Google Workspace CLI has not reported for duty. Installing..."
  brew install googleworkspace-cli
else
  echo "📧 Google Workspace CLI is already filing reports on the floor."
fi

echo ""
echo "✅ Macrodata Refinement environment initialised."
echo "   The work is mysterious and important. Praise Kier. 🫱"
