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
  [[ "$output" == *"Refining package manager"* ]]
}

@test "updates Homebrew when brew is already installed" {
  # brew is on PATH via our mock
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Homebrew already refined"* ]]
}

# ---------------------------------------------------------------------------
# GCP CLI section
# ---------------------------------------------------------------------------

@test "installs GCP CLI when gcloud is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed gcloud
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Google Cloud CLI has been placed"* ]]
}

@test "skips GCP CLI when gcloud is already installed" {
  cat > "$MOCK_BIN/gcloud" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/gcloud"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Google Cloud CLI already present"* ]]
}

# ---------------------------------------------------------------------------
# Cursor section
# ---------------------------------------------------------------------------

@test "installs Cursor when the cask is not listed" {
  # Default brew mock returns 1 for "list --cask", so Cursor is not installed
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Cursor awaits in the Break Room"* ]]
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
  [[ "$output" == *"Cursor is already on the Severed Floor"* ]]
}

@test "skips Cursor cask install when app already exists but cask is not listed" {
  cursor_app_path="$MOCK_BIN/Cursor.app"
  mkdir -p "$cursor_app_path"

  run env CURSOR_APP_PATH="$cursor_app_path" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Cursor app already detected"* ]]
}

# ---------------------------------------------------------------------------
# Claude section
# ---------------------------------------------------------------------------

@test "installs Claude when the cask is not listed" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Claude has not yet reported"* ]]
}

@test "skips Claude when the cask is already listed" {
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Claude is already seated"* ]]
}

# ---------------------------------------------------------------------------
# OpenShift CLI section
# ---------------------------------------------------------------------------

@test "installs OpenShift CLI when oc is not on PATH" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"OpenShift CLI has been approved"* ]]
}

@test "skips OpenShift CLI when oc is already installed" {
  cat > "$MOCK_BIN/oc" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/oc"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"OpenShift CLI is already badged in"* ]]
}

# ---------------------------------------------------------------------------
# GitHub CLI section
# ---------------------------------------------------------------------------

@test "installs GitHub CLI when gh is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed gh
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"GitHub CLI not found"* ]]
}

@test "skips GitHub CLI when gh is already installed" {
  cat > "$MOCK_BIN/gh" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/gh"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"GitHub CLI is already on the floor"* ]]
}

# ---------------------------------------------------------------------------
# uvx section
# ---------------------------------------------------------------------------

@test "installs uvx when uvx is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed uvx
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"uvx not detected"* ]]
}

@test "skips uvx when uvx is already installed" {
  cat > "$MOCK_BIN/uvx" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/uvx"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"uvx is already present"* ]]
}

# ---------------------------------------------------------------------------
# Python + pip section
# ---------------------------------------------------------------------------

@test "installs Python when python3 is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system python3
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Python not found"* ]]
}

@test "skips Python when python3 is already installed" {
  cat > "$MOCK_BIN/python3" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/python3"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Python is already slithering"* ]]
}

# ---------------------------------------------------------------------------
# Miro section
# ---------------------------------------------------------------------------

@test "installs Miro when the cask is not listed" {
  # Default brew mock returns 1 for "list --cask", so Miro is not installed
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Miro has not been cleared"* ]]
}

@test "skips Miro when the cask is already listed" {
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Miro is already on the Severed Floor"* ]]
}

# ---------------------------------------------------------------------------
# Podman Desktop section
# ---------------------------------------------------------------------------

@test "installs Podman Desktop when the cask is not listed" {
  # Default brew mock returns 1 for "list --cask", so Podman Desktop is not installed
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Podman Desktop has not been issued a corridor badge"* ]]
}

@test "skips Podman Desktop when the cask is already listed" {
  cat > "$MOCK_BIN/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Podman Desktop is already cleared for the floor"* ]]
}

# ---------------------------------------------------------------------------
# Google Workspace CLI section
# ---------------------------------------------------------------------------

@test "installs Google Workspace CLI when gws is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed gws
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Google Workspace CLI has not reported for duty"* ]]
}

@test "skips Google Workspace CLI when gws is already installed" {
  cat > "$MOCK_BIN/gws" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/gws"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Google Workspace CLI is already filing reports"* ]]
}

# ---------------------------------------------------------------------------
# Node.js + npm section
# ---------------------------------------------------------------------------

@test "installs Node.js when node is not on PATH" {
  # Use absolute bash path + restricted PATH to prevent finding system-installed node
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Node.js not found"* ]]
  [[ "$output" == *"stops at the elevator"* ]]
}

@test "skips Node.js when node is already installed" {
  cat > "$MOCK_BIN/node" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/node"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Defiant Jazz"* ]]
}

# ---------------------------------------------------------------------------
# cloc section
# ---------------------------------------------------------------------------

@test "installs cloc when cloc is not on PATH" {
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"cloc not found"* ]]
}

@test "skips cloc when cloc is already installed" {
  cat > "$MOCK_BIN/cloc" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/cloc"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"cloc is already tallying lines"* ]]
}

# ---------------------------------------------------------------------------
# act section
# ---------------------------------------------------------------------------

@test "installs act when act is not on PATH" {
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"act not found"* ]]
}

@test "skips act when act is already installed" {
  cat > "$MOCK_BIN/act" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/act"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"act is already running scenes"* ]]
}

# ---------------------------------------------------------------------------
# End-to-end: all tools already present
# ---------------------------------------------------------------------------

@test "prints completion message" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Macrodata Refinement environment initialised"* ]]
}

@test "exits successfully when all tools are already installed" {
  # Stubs for every command-based tool
  for tool in gcloud oc gh uvx python3 gws node cloc act; do
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
  [[ "$output" == *"Homebrew already refined"* ]]
  [[ "$output" == *"Google Cloud CLI already present"* ]]
  [[ "$output" == *"Cursor is already on the Severed Floor"* ]]
  [[ "$output" == *"Claude is already seated"* ]]
  [[ "$output" == *"OpenShift CLI is already badged in"* ]]
  [[ "$output" == *"GitHub CLI is already on the floor"* ]]
  [[ "$output" == *"uvx is already present"* ]]
  [[ "$output" == *"Python is already slithering"* ]]
  [[ "$output" == *"Miro is already on the Severed Floor"* ]]
  [[ "$output" == *"Podman Desktop is already cleared for the floor"* ]]
  [[ "$output" == *"Google Workspace CLI is already filing reports"* ]]
  [[ "$output" == *"Defiant Jazz"* ]]
  [[ "$output" == *"cloc is already tallying lines"* ]]
  [[ "$output" == *"act is already running scenes"* ]]
}
