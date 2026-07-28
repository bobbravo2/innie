# Copilot Instructions

## Project overview

`innie` is an idempotent macOS developer-environment bootstrap script (`install.sh`) written in Bash. It installs a fixed set of tools via Homebrew (CLI tools with `brew install` and GUI apps with `brew install --cask`). The project is themed around the TV show *Severance* — comments and output messages use in-universe language.

## Repository layout

```
install.sh          # Main bootstrap script (the only production file)
test/
  install.bats      # bats unit-test suite (runs on Linux with mock binaries)
.github/
  workflows/
    ci.yml                    # CI: unit tests on Ubuntu + E2E on macOS
    copilot-setup-steps.yml   # Pre-installs bats + shellcheck for Copilot
```

## How to run tests

```bash
# Unit tests (Linux — no Homebrew required, uses mock binaries)
bats test/install.bats

# Static analysis
shellcheck install.sh
```

## Coding conventions

- `install.sh` uses `set -euo pipefail` and must pass `shellcheck` with no warnings.
- Every tool block follows the same pattern: check if already present → skip with a thematic message, or install with a thematic message.
- New tools should be added as a numbered section at the bottom, following the existing style.
- Tests live in `test/install.bats`. Every new tool section needs corresponding bats tests:
  - One test for "not installed → installs" (using a restricted `$MOCK_BIN` PATH).
  - One test for "already installed → skips" (stub binary in `$MOCK_BIN`).
- Keep output messages thematic — reference *Severance* lore where possible.
- Do not remove or weaken existing tests.
