#!/usr/bin/env bats
# Tests for install.sh
# Run with: bats test/install.bats

bats_require_minimum_version 1.5.0

SCRIPT="$BATS_TEST_DIRNAME/../install.sh"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Create a directory of mock executables and prepend it to PATH.
# Individual tests add/remove executables to simulate "installed" / "missing".
setup() {
  MOCK_BIN="$(mktemp -d)"
  export PATH="$MOCK_BIN:$PATH"

  # Default brew mock: returns 1 for "list --cask" (casks NOT installed by default).
  # NOTE: shebang must use absolute path to avoid infinite recursion when
  #       $MOCK_BIN is prepended to PATH (#!/usr/bin/env bash would resolve
  #       back to this mock).
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
# brew list --cask <name> — exit 1 means "not installed"
if [[ "${1:-}" == "list" && "${2:-}" == "--cask" ]]; then
  exit 1
fi
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  # curl mock: silently succeeds so Homebrew's install URL is never fetched.
  cat > "$MOCK_BIN/curl" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/curl"
}

teardown() {
  rm -rf "$MOCK_BIN"
}

# ---------------------------------------------------------------------------
# Syntax / static checks
# ---------------------------------------------------------------------------

@test "install.sh has no syntax errors" {
  run bash -n "$SCRIPT"
  [ "$status" -eq 0 ]
}

@test "install.sh passes shellcheck" {
  run shellcheck "$SCRIPT"
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# Homebrew section
# ---------------------------------------------------------------------------

@test "installs Homebrew when brew is not on PATH" {
  rm "$MOCK_BIN/brew"
  # The Homebrew install line is: /bin/bash -c "$(curl -fsSL ...)"
  # curl mock returns empty output → /bin/bash -c "" → exits 0.
  # After the Homebrew section the script will fail at section 2 (brew absent),
  # but by then it has already printed the "Installing Homebrew" message.
  # Exit 127 = command not found (brew unavailable for later sections).
  run -127 bash "$SCRIPT"
  [[ "$output" == *"Installing Homebrew"* ]]
}

@test "updates Homebrew when brew is already installed" {
  # brew is on PATH via our mock
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Homebrew already installed, updating"* ]]
}

# ---------------------------------------------------------------------------
# GCP CLI section
# ---------------------------------------------------------------------------

@test "installs GCP CLI when gcloud is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed gcloud
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing Google Cloud CLI"* ]]
}

@test "skips GCP CLI when gcloud is already installed" {
  cat > "$MOCK_BIN/gcloud" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/gcloud"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Google Cloud CLI already installed, skipping"* ]]
}

# ---------------------------------------------------------------------------
# Cursor section
# ---------------------------------------------------------------------------

@test "installs Cursor when the cask is not listed" {
  # Default brew mock returns 1 for "list --cask", so Cursor is not installed
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing Cursor"* ]]
}

@test "skips Cursor when the cask is already listed" {
  # Override brew to report all casks as installed
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Cursor already installed, skipping"* ]]
}

# ---------------------------------------------------------------------------
# Claude section
# ---------------------------------------------------------------------------

@test "installs Claude when the cask is not listed" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing Claude"* ]]
}

@test "skips Claude when the cask is already listed" {
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Claude already installed, skipping"* ]]
}

# ---------------------------------------------------------------------------
# OpenShift CLI section
# ---------------------------------------------------------------------------

@test "installs OpenShift CLI when oc is not on PATH" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing OpenShift CLI"* ]]
}

@test "skips OpenShift CLI when oc is already installed" {
  cat > "$MOCK_BIN/oc" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/oc"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"OpenShift CLI already installed, skipping"* ]]
}

# ---------------------------------------------------------------------------
# GitHub CLI section
# ---------------------------------------------------------------------------

@test "installs GitHub CLI when gh is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed gh
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing GitHub CLI"* ]]
}

@test "skips GitHub CLI when gh is already installed" {
  cat > "$MOCK_BIN/gh" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/gh"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"GitHub CLI already installed, skipping"* ]]
}

# ---------------------------------------------------------------------------
# End-to-end: all tools already present
# ---------------------------------------------------------------------------

@test "prints completion message" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"innie macOS setup complete"* ]]
}

@test "exits successfully when all tools are already installed" {
  # Stubs for every command-based tool
  for tool in gcloud oc gh; do
    cat > "$MOCK_BIN/$tool" <<'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$MOCK_BIN/$tool"
  done

  # Make brew report all casks as installed too
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Homebrew already installed"* ]]
  [[ "$output" == *"Google Cloud CLI already installed"* ]]
  [[ "$output" == *"Cursor already installed"* ]]
  [[ "$output" == *"Claude already installed"* ]]
  [[ "$output" == *"OpenShift CLI already installed"* ]]
  [[ "$output" == *"GitHub CLI already installed"* ]]
}
